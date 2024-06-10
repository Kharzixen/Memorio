package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.albumservice.dto.incomming.DisposableCameraMemoryDtoIn;
import com.kharzixen.albumservice.dto.outgoing.disposableCameraMemoryDto.DisposableCameraMemoryDtoOut;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
import com.kharzixen.albumservice.mapper.DisposableCameraMemoryMapper;
import com.kharzixen.albumservice.model.*;
import com.kharzixen.albumservice.projection.DisposableCameraMemoryProjection;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.DisposableCameraMemoryRepository;
import com.kharzixen.albumservice.repository.MemoryEventOutboxRepository;
import com.kharzixen.albumservice.repository.UserRepository;
import com.kharzixen.albumservice.webclient.ImageServiceClient;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@AllArgsConstructor
@Slf4j
public class DisposableCameraMemoryService {
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;
    private final DisposableCameraMemoryRepository memoryRepository;
    private final ImageServiceClient imageServiceClient;
    private final MemoryEventOutboxRepository memoryEventOutboxRepository;

    public Page<DisposableCameraMemoryDtoOut> getDisposableCameraMemoriesByUploaderPaginated(Long albumId, Long uploaderId, int page, int pageSize, Long requesterId) {
        if(Objects.equals(uploaderId, requesterId) && albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
            Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
            Pageable pageRequest = PageRequest.of(page, pageSize, sort);
            Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
            User uploader = userRepository.findById(requesterId).orElseThrow(() -> new NotFoundException("Uploader", requesterId));


            if (!album.getContributors().contains(uploader)) {
                throw new RuntimeException("User not contributor of this album");
            }

            if(!album.getDisposableCamera().getIsActive()){
                throw new RuntimeException("Unauthorized");
            }

            Page<DisposableCameraMemoryProjection> pageResponse = memoryRepository
                    .findDisposableCameraMemoriesOfAlbumByUploaderPaginated(album.getId(), requesterId, pageRequest);
            List<DisposableCameraMemoryDtoOut> dtos = pageResponse.getContent()
                    .stream().map(DisposableCameraMemoryMapper.INSTANCE::projectionToPreviewDto).toList();
            return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    public Page<DisposableCameraMemoryDtoOut> getDisposableCameraMemoriesPaginated(Long albumId, int page, int pageSize, Long requesterId) {
        Album album = albumRepository.findById(albumId)
                .orElseThrow(()-> new NotFoundException("Album", albumId));

        if(Objects.equals(album.getOwner().getId(), requesterId)){
            Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
            Pageable pageRequest = PageRequest.of(page, pageSize, sort);


            if(!album.getDisposableCamera().getIsActive()){
                throw new RuntimeException("Unauthorized");
            }

            Page<DisposableCameraMemoryProjection> pageResponse = memoryRepository
                    .findDisposableCameraMemoriesOfAlbumPaginated(album.getId(), pageRequest);
            List<DisposableCameraMemoryDtoOut> dtos = pageResponse.getContent()
                    .stream().map(DisposableCameraMemoryMapper.INSTANCE::projectionToPreviewDto).toList();
            return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }

    }

    public DisposableCameraMemoryDtoOut createDisposableCameraMemory(Long albumId, DisposableCameraMemoryDtoIn memoryDtoIn, Long requesterId) {
        if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
            try {
                Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));

                if (!Objects.equals(albumId, memoryDtoIn.getAlbumId())) {
                    throw new RuntimeException("AlbumId in path must be equal to albumId in dto");
                }

                if(!album.getDisposableCamera().getIsActive()){
                    throw new RuntimeException("Unauthorized");
                }

                if (memoryDtoIn.getImage() == null ||
                        !Objects.requireNonNull(memoryDtoIn.getImage().getContentType()).startsWith("image/")) {
                    throw new RuntimeException("File is not an image");
                }


                DisposableCameraMemory memory = DisposableCameraMemoryMapper.INSTANCE.dtoToModel(memoryDtoIn);
                //getting and checking user
                User uploader = userRepository.findById(requesterId)
                        .orElseThrow(() -> new NotFoundException("User", requesterId));

                memory.setUploader(uploader);
                memory.setCreationDate(new Date());
                memory.setDisposableCamera(album.getDisposableCamera());
                ImageCreatedResponseDto response = imageServiceClient.postImageToMediaService(memoryDtoIn.getImage(),
                        album.getId());
                memory.setImageId(response.getImageId());
                DisposableCameraMemory saved = memoryRepository.save(memory);
                return DisposableCameraMemoryMapper.INSTANCE.modelToDto(saved);

            } catch (Exception ex) {
                log.info(ex.getMessage());
                throw ex;
            }
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    public DisposableCameraMemoryDtoOut getDisposableCameraMemoryOfAlbumById(Long albumId,
                                                                             Long disposableCameraMemoryId, Long requesterId) {
        DisposableCameraMemory memory = memoryRepository.findById(disposableCameraMemoryId)
                .orElseThrow(() -> new NotFoundException("DisposableCameraMemory", disposableCameraMemoryId));
        if(Objects.equals(memory.getUploader().getId(), requesterId)){
            return DisposableCameraMemoryMapper.INSTANCE.modelToDto(memory);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    public void deleteDisposableMemoryById(Long albumId, Long disposableCameraMemoryId, Long requesterId) {
        DisposableCameraMemory memory = memoryRepository.findById(disposableCameraMemoryId).orElseThrow(() -> new RuntimeException("Memory not found"));

        if(Objects.equals(memory.getUploader().getId(), albumId)
                || Objects.equals(memory.getDisposableCamera().getAlbum().getOwner().getId(), requesterId)){
            memoryRepository.deleteById(disposableCameraMemoryId);
            MemoryEventOutbox memoryEventOutbox = MemoryEventOutbox.builder()
                    .eventType("DELETE")
                    .imageId(memory.getImageId())
                    .build();
            memoryEventOutboxRepository.save(memoryEventOutbox);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }

    }
}
