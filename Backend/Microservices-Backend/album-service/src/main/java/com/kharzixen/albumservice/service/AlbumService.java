package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.albumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.mapper.AlbumMapper;
import com.kharzixen.albumservice.mapper.MemoryMapper;
import com.kharzixen.albumservice.mapper.UserMapper;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.projection.AlbumPreviewProjection;
import com.kharzixen.albumservice.projection.MemoryProjection;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.MemoryCollectionRepository;
import com.kharzixen.albumservice.repository.MemoryRepository;
import com.kharzixen.albumservice.repository.UserRepository;
import com.kharzixen.albumservice.webclient.ImageServiceClient;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@AllArgsConstructor
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;
    private final MemoryRepository memoryRepository;
    private final ImageServiceClient imageServiceClient;
    private final MemoryCollectionRepository memoryCollectionRepository;

    @Transactional
    public AlbumDtoOut createAlbum(AlbumDtoIn albumDtoIn) {
        Album album = AlbumMapper.INSTANCE.dtoToModel(albumDtoIn);
        User owner = userRepository.findById(albumDtoIn.getOwnerId())
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
        ImageCreatedResponseDto response = imageServiceClient.postImageToMediaService(albumDtoIn.getImage());
        album.setAlbumImageLink(response.getImageId());
        Album savedAlbum = albumRepository.save(album);
        AlbumDtoOut responseDto = AlbumMapper.INSTANCE.modelToDto(album);
        List<UserDtoOut> contributorsPreview =
                userRepository.getContributorsOfAlbumByIdPaginated(savedAlbum.getId(), PageRequest.of(0,4))
                        .getContent().stream().map(UserMapper.INSTANCE::projectionToDto)
                        .toList();
        responseDto.setContributorsPreview(contributorsPreview);
        return responseDto;
    }

    public AlbumDtoOut getAlbumById(Long id){
        Album album = albumRepository.findById(id).orElseThrow(() -> new NotFoundException("Album", id));
        AlbumDtoOut responseDto = AlbumMapper.INSTANCE.modelToDto(album);
        List<UserDtoOut> contributorsPreview =
                userRepository.getContributorsOfAlbumByIdPaginated(id, PageRequest.of(0,4))
                        .getContent().stream().map(UserMapper.INSTANCE::projectionToDto)
                        .toList();
        responseDto.setContributorsPreview(contributorsPreview);
        return responseDto;
    }

    public Page<AlbumPreviewDto> getAlbumPreviews(Long userId, int page, int pageSize) {
        Pageable albumPageRequest = PageRequest.of(page,pageSize);
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable memoryPageRequest = PageRequest.of(0, 4, sort);
        Page<AlbumPreviewProjection> albums = albumRepository.findAllWhereUserIsContributor(userId, albumPageRequest);

        List<AlbumPreviewDto> previews =  albums.stream().map(album -> {
            AlbumPreviewDto albumDto = AlbumMapper.INSTANCE.projectionToDto(album);
            List<MemoryProjection> recentMemoriesProjection = memoryRepository
                    .findMemoriesOfAlbumPaginated(album.getId(), memoryPageRequest).getContent();

            albumDto.setRecentMemories(recentMemoriesProjection.stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList());
            return albumDto;
        }).toList();
        //TODO: marks the response as unsorted FIX
        return new PageImpl<>(previews);
    }

}
