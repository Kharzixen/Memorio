package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.albumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.albumservice.dto.incomming.PatchAlbumContributorsDtoIn;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumContributorsPatchedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
import com.kharzixen.albumservice.mapper.AlbumMapper;
import com.kharzixen.albumservice.mapper.MemoryMapper;
import com.kharzixen.albumservice.mapper.UserMapper;
import com.kharzixen.albumservice.model.*;
import com.kharzixen.albumservice.projection.AlbumPreviewProjection;
import com.kharzixen.albumservice.projection.MemoryProjection;
import com.kharzixen.albumservice.repository.*;
import com.kharzixen.albumservice.webclient.ImageServiceClient;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;
    private final MemoryRepository memoryRepository;
    private final ImageServiceClient imageServiceClient;
    private final MemoryCollectionRelationshipRepository memoryCollectionRelationshipRepository;
    private final MemoryCollectionRepository collectionRepository;
    private final DisposableCameraRepository disposableCameraRepository;
    private final ContributorChangedEventRepository contributorChangedEventRepository;

    @Transactional
    public AlbumDtoOut createAlbum(AlbumDtoIn albumDtoIn, Long requesterId) {
        Album album = AlbumMapper.INSTANCE.dtoToModel(albumDtoIn);
        User owner = userRepository.findById(requesterId)
                .orElseThrow(() -> new RuntimeException("user does not exists with id: " + albumDtoIn.getOwnerId()));
        List<User> contributors = new ArrayList<>(albumDtoIn.getInvitedUserIds().stream().
                map(userId -> userRepository.findById(userId).
                        orElseThrow(() -> new RuntimeException("user does not exists with id: " + userId)))
                .toList());
        contributors.add(owner);
        album.setOwner(owner);
        album.setContributors(contributors);

        album.setCollections(List.of());
        album.setMemories(List.of());
        album.setContributorCount(contributors.size());
        album.setAlbumImageLink("default_album_image.jpg");
        Album savedAlbumWithDefaultImage= albumRepository.save(album);

        if(album.getId() != null && !albumDtoIn.getImage().isEmpty()) {
            ImageCreatedResponseDto response = imageServiceClient.postImageToMediaService(albumDtoIn.getImage(),
                    savedAlbumWithDefaultImage.getId());
            album.setAlbumImageLink(response.getImageId());
        }
        DisposableCamera disposableCamera = new DisposableCamera(null, false, "", new Date(), album, List.of());
        DisposableCamera savedDisposableCamera = disposableCameraRepository.save(disposableCamera);
        album.setDisposableCamera(savedDisposableCamera);
        Album savedAlbum = albumRepository.save(album);
        contributorChangedEventRepository.save(new ContributorChangedEventOutbox(null, "ADD",
                savedAlbum.getId(), savedAlbum.getOwner().getId(), savedAlbum.getOwner().getUsername()));
        return AlbumMapper.INSTANCE.modelToDto(savedAlbum);
    }

    public AlbumDtoOut getAlbumById(Long id, Long requesterId) {
       if(albumRepository.isUserContributorOfAlbum(requesterId, id)){
           Album album = albumRepository.findById(id).orElseThrow(() -> new NotFoundException("Album", id));
           return AlbumMapper.INSTANCE.modelToDto(album);
       } else {
           throw new UnauthorizedRequestException("Unauthorized");
       }
    }

    public Page<AlbumPreviewDto> getAlbumPreviews(Long userId, int page, int pageSize, Long requesterId) {

        if(Objects.equals(userId, requesterId)){
            Sort memorySort = Sort.by(Sort.Direction.DESC, "creationDate");
            Sort albumSort = Sort.by(Sort.Direction.ASC, "albumName");
            Pageable albumPageRequest = PageRequest.of(page, pageSize, albumSort);
            Pageable memoryPageRequest = PageRequest.of(0, 4, memorySort);
            Page<AlbumPreviewProjection> albums = albumRepository.findAllWhereUserIsContributor(requesterId, albumPageRequest);

            List<AlbumPreviewDto> previews = albums.stream().map(album -> {
                AlbumPreviewDto albumDto = AlbumMapper.INSTANCE.projectionToDto(album);
                List<MemoryProjection> recentMemoriesProjection = memoryRepository
                        .findMemoriesOfAlbumPaginated(album.getId(), memoryPageRequest).getContent();

                albumDto.setRecentMemories(recentMemoriesProjection.stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList());
                return albumDto;
            }).toList();

            return new PageImpl<>(previews, albumPageRequest, albums.getTotalElements());
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    @Transactional
    public void removeAlbum(Long albumId, Long requesterId) {
        Album album = albumRepository.findById(albumId).orElseThrow(()-> new NotFoundException("ALBUM", albumId));
       if(Objects.equals(album.getOwner().getId(), requesterId)){
           for(MemoryCollection collection : album.getCollections()){
               List<Long> relationshipIds = collection.getMemories().stream().map(MemoryCollectionRelationship::getId).toList();
               memoryCollectionRelationshipRepository.deleteAllById(relationshipIds);
               collectionRepository.deleteById(collection.getId());
           }
           memoryRepository.deleteAllById(album.getMemories().stream().map(Memory::getId).toList());
           albumRepository.deleteById(albumId);
       } else {
           throw new UnauthorizedRequestException("Unauthorized");
       }
    }

    public List<UserDtoOut> getContributorsOfAlbum(Long albumId, Long requesterId) {
        if(albumRepository.isUserContributorOfAlbum( requesterId, albumId)){
            List<User> contributors = albumRepository.findAllContributorsOfAlbum(albumId);
            return contributors.stream().map(UserMapper.INSTANCE::modelToDto).toList();
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    @Transactional
    public AlbumContributorsPatchedDtoOut addContributors(Long albumId, PatchAlbumContributorsDtoIn patchDto, Long requesterId) {
        if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
            Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
            List<UserDtoOut> changedUsers = new ArrayList<>();
            for (Long userId : patchDto.getUserIds()) {

                User user = userRepository.findById(userId).orElseThrow(() -> new NotFoundException("User", userId));
                if (! album.getContributors().contains(user)) {
                    album.getContributors().add(user);
                    user.getAlbums().add(album);
                    changedUsers.add(UserMapper.INSTANCE.modelToDto(user));
                    contributorChangedEventRepository.save(new ContributorChangedEventOutbox(null, "ADD",
                            albumId, user.getId(),user.getUsername()));
                }
            }
            Album savedAlbum = albumRepository.save(album);

            return new AlbumContributorsPatchedDtoOut(patchDto.getMethod(), savedAlbum.getId().toString(), changedUsers);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    @Transactional
    public void removeUserFromAlbum(Long userId, Long albumId, Long requesterId) {

        User user = userRepository.findById(userId).orElseThrow(() -> new NotFoundException("USER", userId));
        Album album = albumRepository.findById(albumId).orElseThrow(()-> new NotFoundException("ALBUM", albumId));
        //if the requester is the owner of the album, or the requester wants to leave
        if(Objects.equals(album.getOwner().getId(), requesterId)
                || userId.equals(requesterId)){
            user.getAlbums().remove(album);
            album.getContributors().remove(user);

            if(album.getContributors().isEmpty()){
                //if no more contributors, delete the album
                this.removeAlbum(album.getId(), requesterId);
            } else if(album.getOwner() == user){
                //if there are contributors, set another owner
                album.setOwner(album.getContributors().get(0));
            }
            contributorChangedEventRepository.save(new ContributorChangedEventOutbox(null, "REMOVE",
                    albumId, user.getId(), user.getUsername()));
            userRepository.save(user);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    public UserDtoOut getContributorByIdOfAlbum(Long albumId, Long contributorId, Long requesterId) {
       if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
           User user = userRepository.findById(contributorId).orElseThrow(() -> new NotFoundException("USER", contributorId));
           Album album = albumRepository.findById(albumId).orElseThrow(()-> new NotFoundException("ALBUM", albumId));

           if(album.getContributors().contains(user)){
               return UserMapper.INSTANCE.modelToDto(user);
           }

           throw new NotFoundException("user", contributorId);
       } else {
           throw new UnauthorizedRequestException("Unauthorized");
       }
    }
}
