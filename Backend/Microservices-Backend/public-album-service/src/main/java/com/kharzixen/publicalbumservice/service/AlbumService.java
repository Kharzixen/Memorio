package com.kharzixen.publicalbumservice.service;


import com.kharzixen.publicalbumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.publicalbumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.publicalbumservice.dto.incomming.PatchAlbumContributorsDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumContributorsPatchedDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.publicalbumservice.exception.NotFoundException;
import com.kharzixen.publicalbumservice.exception.UnauthorizedRequestException;
import com.kharzixen.publicalbumservice.mapper.AlbumMapper;
import com.kharzixen.publicalbumservice.mapper.MemoryMapper;
import com.kharzixen.publicalbumservice.mapper.UserMapper;
import com.kharzixen.publicalbumservice.model.Album;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.projection.AlbumPreviewProjection;
import com.kharzixen.publicalbumservice.projection.MemoryProjection;
import com.kharzixen.publicalbumservice.repository.AlbumRepository;
import com.kharzixen.publicalbumservice.repository.MemoryRepository;
import com.kharzixen.publicalbumservice.repository.UserRepository;
import com.kharzixen.publicalbumservice.webclient.ImageServiceClient;
import com.kharzixen.publicalbumservice.model.Memory;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;
    private final MemoryRepository memoryRepository;
    private final ImageServiceClient imageServiceClient;

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

        album.setMemories(List.of());
        album.setContributorCount(contributors.size());
        album.setAlbumImageLink("default_album_image.jpg");
        Album savedAlbumWithDefaultImage= albumRepository.save(album);

        if(album.getId() != null && !albumDtoIn.getImage().isEmpty()) {
            ImageCreatedResponseDto response = imageServiceClient.postImageToMediaService(albumDtoIn.getImage(),
                    savedAlbumWithDefaultImage.getId());
            album.setAlbumImageLink(response.getImageId());
        }
        Album savedAlbum = albumRepository.save(album);
        return AlbumMapper.INSTANCE.modelToDto(savedAlbum);
    }

    public AlbumDtoOut getAlbumById(Long id) {
        Album album = albumRepository.findById(id).orElseThrow(() -> new NotFoundException("Album", id));
        return AlbumMapper.INSTANCE.modelToDto(album);
    }

    public Page<AlbumPreviewDto> getAlbumPreviews(Long userId, int page, int pageSize) {

        Sort memorySort = Sort.by(Sort.Direction.DESC, "creationDate");
        Sort albumSort = Sort.by(Sort.Direction.DESC, "albumName");
        Pageable albumPageRequest = PageRequest.of(page, pageSize, albumSort);
        Pageable memoryPageRequest = PageRequest.of(0, 4, memorySort);
        Page<AlbumPreviewProjection> albums = albumRepository.findAllWhereUserIsContributor(userId, albumPageRequest);

        List<AlbumPreviewDto> previews = albums.stream().map(album -> {
            AlbumPreviewDto albumDto = AlbumMapper.INSTANCE.projectionToDto(album);
            List<MemoryProjection> recentMemoriesProjection = memoryRepository
                    .findMemoriesOfAlbumPaginated(album.getId(), memoryPageRequest).getContent();

            albumDto.setRecentMemories(recentMemoriesProjection.stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList());
            return albumDto;
        }).toList();

        return new PageImpl<>(previews, albumPageRequest, albums.getTotalElements());
    }

    @Transactional
    public void removeAlbum(Long albumId, Long requesterId) {
        Album album = albumRepository.findById(albumId).orElseThrow(()-> new NotFoundException("ALBUM", albumId));
        if(Objects.equals(album.getOwner().getId(), requesterId)) {
            memoryRepository.deleteAllById(album.getMemories().stream().map(Memory::getId).toList());
            albumRepository.deleteById(albumId);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    public List<UserDtoOut> getContributorsOfAlbum(Long albumId) {
        List<User> contributors = albumRepository.findAllContributorsOfAlbum(albumId);
        return contributors.stream().map(UserMapper.INSTANCE::modelToDto).toList();
    }

    @Transactional
    public AlbumContributorsPatchedDtoOut addContributors(Long albumId, PatchAlbumContributorsDtoIn patchDto, Long requesterId) {
        Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
        if(Objects.equals(album.getOwner().getId(), requesterId)){

            List<UserDtoOut> changedUsers = new ArrayList<>();
            for (Long userId : patchDto.getUserIds()) {

                User user = userRepository.findById(userId).orElseThrow(() -> new NotFoundException("User", userId));
                if (! album.getContributors().contains(user)) {
                    album.getContributors().add(user);
                    user.getAlbums().add(album);
                    changedUsers.add(UserMapper.INSTANCE.modelToDto(user));
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
       if(Objects.equals(requesterId, userId)) {
           User user = userRepository.findById(userId).orElseThrow(() -> new NotFoundException("USER", userId));
           Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("ALBUM", albumId));
           user.getAlbums().remove(album);
           album.getContributors().remove(user);

           if (album.getContributors().isEmpty()) {
               //if no more contributors, delete the album
               this.removeAlbum(album.getId(), requesterId);
           } else if (album.getOwner() == user) {
               //if there are contributors, set another owner
               album.setOwner(album.getContributors().get(0));
           }

           userRepository.save(user);
       } else {
           throw new UnauthorizedRequestException("Unauthorized");
       }
    }

    public UserDtoOut getContributorByIdOfAlbum(Long albumId, Long contributorId) {
        User user = userRepository.findById(contributorId).orElseThrow(() -> new NotFoundException("USER", contributorId));
        Album album = albumRepository.findById(albumId).orElseThrow(()-> new NotFoundException("ALBUM", albumId));

        if(album.getContributors().contains(user)){
            return UserMapper.INSTANCE.modelToDto(user);
        }

        throw new RuntimeException("user not contributor of album");
    }

    public Page<AlbumPreviewDto> getAllAlbumPreviews(int page, int pageSize) {
        Sort memorySort = Sort.by(Sort.Direction.DESC, "creationDate");
        Sort albumSort = Sort.by(Sort.Direction.DESC, "albumName");
        Pageable albumPageRequest = PageRequest.of(page, pageSize, albumSort);
        Pageable memoryPageRequest = PageRequest.of(0, 4, memorySort);
        Page<Album> albums = albumRepository.findAll(albumPageRequest);

        List<AlbumPreviewDto> previews = albums.stream().map(album -> {
            AlbumPreviewDto albumDto = AlbumMapper.INSTANCE.modelToPreviewDto(album);
            List<MemoryProjection> recentMemoriesProjection = memoryRepository
                    .findMemoriesOfAlbumPaginated(album.getId(), memoryPageRequest).getContent();

            albumDto.setRecentMemories(recentMemoriesProjection.stream()
                    .map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList());
            return albumDto;
        }).toList();

        return new PageImpl<>(previews, albumPageRequest, albums.getTotalElements());
    }
}
