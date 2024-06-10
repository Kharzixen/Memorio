package com.kharzixen.publicalbumservice.service;


import com.kharzixen.publicalbumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.publicalbumservice.dto.incomming.MemoryDtoIn;
import com.kharzixen.publicalbumservice.dto.incomming.PatchMemoryDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.DetailedMemoryDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.publicalbumservice.exception.NotFoundException;
import com.kharzixen.publicalbumservice.exception.UnauthorizedRequestException;
import com.kharzixen.publicalbumservice.mapper.MemoryMapper;
import com.kharzixen.publicalbumservice.model.Album;
import com.kharzixen.publicalbumservice.model.Memory;
import com.kharzixen.publicalbumservice.model.MemoryEventOutbox;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.projection.MemoryProjection;
import com.kharzixen.publicalbumservice.repository.*;
import com.kharzixen.publicalbumservice.webclient.ImageServiceClient;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@AllArgsConstructor
@Service
@Slf4j
public class MemoryService {
    private final MemoryRepository memoryRepository;
    private final UserRepository userRepository;
    private final AlbumRepository albumRepository;
    private final MemoryEventOutboxRepository memoryEventOutboxRepository;
    private final LikeRepository likeRepository;


    private ImageServiceClient imageServiceClient;

    @Transactional
    public MemoryPreviewDtoOut createMemory(Long albumId, MemoryDtoIn memoryDtoIn, Long requesterId) {
        try {
            if (!Objects.equals(albumId, memoryDtoIn.getAlbumId())) {
                throw new RuntimeException("AlbumId in path must be equal to albumId in dto");
            }

            //verify if album exists
            Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));


            if (memoryDtoIn.getImage() == null ||
                    !Objects.requireNonNull(memoryDtoIn.getImage().getContentType()).startsWith("image/")) {
                throw new RuntimeException("File is not an image");
            }


            Memory memory = MemoryMapper.INSTANCE.dtoToModel(memoryDtoIn);
            //getting and checking user
            User uploader = userRepository.findById(requesterId)
                    .orElseThrow(() -> new NotFoundException("User", memoryDtoIn.getUploaderId()));

            memory.setUploader(uploader);
            memory.setCreationDate(new Date());
            memory.setAlbum(album);
            ImageCreatedResponseDto response = imageServiceClient.postImageToMediaService(memoryDtoIn.getImage(),
                    album.getId());
            memory.setImageId(response.getImageId());
            memory.setIsHighlighted(false);
            Memory saved = memoryRepository.save(memory);

            if(!album.getContributors().contains(uploader)){
                List<User> contributors = album.getContributors();
                contributors.add(uploader);
                album.setContributors(contributors);
            }
            albumRepository.save(album);
            return MemoryMapper.INSTANCE.modelToPreviewDto(saved);

        } catch (Exception ex) {
            log.info(ex.getMessage());
            throw ex;
        }
    }



    public Page<MemoryPreviewDtoOut> getMemoriesOfAlbumPaginated(Long albumId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Optional<Album> album = albumRepository.findById(albumId);
        if (album.isEmpty()) {
            throw new NotFoundException("Album", albumId);
        }
        Page<MemoryProjection> pageResponse = memoryRepository
                .findMemoriesOfAlbumPaginated(album.get().getId(), pageRequest);
        List<MemoryPreviewDtoOut> dtos = pageResponse.getContent()
                .stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
    }



    public DetailedMemoryDtoOut getMemoryById(Long albumId, Long memoryId) {
        Memory memory = memoryRepository.findById(memoryId).orElseThrow(() -> new NotFoundException("Memory", memoryId));
//        if(memory.isIncludedInDisposableCamera()){
//            //check if requester is the owner, or the requester is the album owner
//        }
        if (Objects.equals(memory.getAlbum().getId(), albumId)) {
            //check user authorization
            DetailedMemoryDtoOut memoryDtoOut = MemoryMapper.INSTANCE.modelToDetailedDto(memory);
            memoryDtoOut.setLikeCount(likeRepository.findAllWhereMemoryId(memoryId).size());
            return memoryDtoOut;

        } else {
            throw new RuntimeException("Unatuthorized");
        }

    }

    @Transactional
    public void deleteMemory(Long albumId, Long memoryId, Long requesterId) {
        Memory memory = memoryRepository.findById(memoryId).orElseThrow(() -> new NotFoundException("Memory", memoryId));
        if(requesterId == memory.getUploader().getId()) {
            memoryEventOutboxRepository.save(new MemoryEventOutbox(null, "DELETE", memory.getImageId()));
            memoryRepository.deleteById(memory.getId());
            log.info("Memory deleted");
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }

    }


    public Page<MemoryPreviewDtoOut> getMemoriesOfAlbumByUploaderPaginated(Long albumId,
                                                                           Long uploaderId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
        User uploader = userRepository.findById(uploaderId).orElseThrow(() -> new NotFoundException("Collection", uploaderId));


        if (!album.getContributors().contains(uploader)) {
            throw new RuntimeException("User not contributor of this album");
        }

        Page<MemoryProjection> pageResponse = memoryRepository
                .findMemoriesOfAlbumByUploaderPaginated(album.getId(), uploader.getId(), pageRequest);
        List<MemoryPreviewDtoOut> dtos = pageResponse.getContent()
                .stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());

    }

    public Page<MemoryPreviewDtoOut> getHighlightedMemoriesOfAlbumPaginated(Long albumId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Optional<Album> album = albumRepository.findById(albumId);
        if (album.isEmpty()) {
            throw new NotFoundException("Album", albumId);
        }
        Page<MemoryProjection> pageResponse = memoryRepository
                .findHighlightedMemoriesOfAlbumPaginated(album.get().getId(), pageRequest);
        List<MemoryPreviewDtoOut> dtos = pageResponse.getContent()
                .stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
    }

    public DetailedMemoryDtoOut patchMemoryDtoIn(Long albumId, Long memoryId, PatchMemoryDtoIn dtoIn, Long requesterId) {

        Memory memory = memoryRepository.findById(memoryId).orElseThrow(() -> new NotFoundException("Memory", memoryId));
        if (Objects.equals(memory.getAlbum().getId(), albumId) && Objects.equals(memory.getAlbum().getOwner().getId(), requesterId)) {
            if(dtoIn.getIsHighlighted() != null){
                memory.setIsHighlighted(dtoIn.getIsHighlighted());

            }
            Memory saved = memoryRepository.save(memory);
            DetailedMemoryDtoOut memoryDtoOut = MemoryMapper.INSTANCE.modelToDetailedDto(saved);
            memoryDtoOut.setLikeCount(likeRepository.findAllWhereMemoryId(memoryId).size());
            return memoryDtoOut;

        } else {
            throw new RuntimeException("Unatuthorized");
        }
    }
}
