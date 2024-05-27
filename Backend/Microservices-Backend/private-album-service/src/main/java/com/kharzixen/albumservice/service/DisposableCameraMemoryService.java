package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.albumservice.dto.incomming.DisposableCameraMemoryDtoIn;
import com.kharzixen.albumservice.dto.outgoing.disposableCameraMemoryDto.DisposableCameraMemoryDtoOut;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.mapper.DisposableCameraMemoryMapper;
import com.kharzixen.albumservice.model.*;
import com.kharzixen.albumservice.projection.DisposableCameraMemoryProjection;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.DisposableCameraMemoryRepository;
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

    public Page<DisposableCameraMemoryDtoOut> getDisposableCameraMemoriesByUploaderPaginated(Long albumId, Long uploaderId, int page, int pageSize) {

        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
        User uploader = userRepository.findById(uploaderId).orElseThrow(() -> new NotFoundException("Uploader", uploaderId));


        if (!album.getContributors().contains(uploader)) {
            throw new RuntimeException("User not contributor of this album");
        }

        if(!album.getDisposableCamera().getIsActive()){
            throw new RuntimeException("Unauthorized");
        }

        Page<DisposableCameraMemoryProjection> pageResponse = memoryRepository
                .findDisposableCameraMemoriesOfAlbumByUploaderPaginated(album.getId(), uploaderId, pageRequest);
        List<DisposableCameraMemoryDtoOut> dtos = pageResponse.getContent()
                .stream().map(DisposableCameraMemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
    }

    public Page<DisposableCameraMemoryDtoOut> getDisposableCameraMemoriesPaginated(Long albumId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Optional<Album> album = albumRepository.findById(albumId);
        if (album.isEmpty()) {
            throw new NotFoundException("Album", albumId);
        }
        if(!album.get().getDisposableCamera().getIsActive()){
            throw new RuntimeException("Unauthorized");
        }

        Page<DisposableCameraMemoryProjection> pageResponse = memoryRepository
                .findDisposableCameraMemoriesOfAlbumPaginated(album.get().getId(), pageRequest);
        List<DisposableCameraMemoryDtoOut> dtos = pageResponse.getContent()
                .stream().map(DisposableCameraMemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());

    }

    public DisposableCameraMemoryDtoOut createDisposableCameraMemory(Long albumId, DisposableCameraMemoryDtoIn memoryDtoIn) {
        try {
            if (!Objects.equals(albumId, memoryDtoIn.getAlbumId())) {
                throw new RuntimeException("AlbumId in path must be equal to albumId in dto");
            }

            //verify if album exists
            Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));

            if(!album.getDisposableCamera().getIsActive()){
                throw new RuntimeException("Unauthorized");
            }

            //should check via JWT token
            // it is faster like this, the album.contributors is lazy loaded.
            if (!albumRepository.isUserContributorOfAlbum(memoryDtoIn.getUploaderId(), albumId)) {
                throw new RuntimeException("User is not contributor of the album");
            }

            if (memoryDtoIn.getImage() == null ||
                    !Objects.requireNonNull(memoryDtoIn.getImage().getContentType()).startsWith("image/")) {
                throw new RuntimeException("File is not an image");
            }


            DisposableCameraMemory memory = DisposableCameraMemoryMapper.INSTANCE.dtoToModel(memoryDtoIn);
            //getting and checking user
            User uploader = userRepository.findById(memoryDtoIn.getUploaderId())
                    .orElseThrow(() -> new NotFoundException("User", memoryDtoIn.getUploaderId()));

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
    }

    public DisposableCameraMemoryDtoOut getDisposableCameraMemoryOfAlbumById(Long albumId,
                                                                             Long disposableCameraMemoryId) {
        DisposableCameraMemory memory = memoryRepository.findById(disposableCameraMemoryId)
                .orElseThrow(() -> new NotFoundException("DisposableCameraMemory", disposableCameraMemoryId));
        return DisposableCameraMemoryMapper.INSTANCE.modelToDto(memory);
    }

    public void deleteDisposableMemoryById(Long albumId, Long disposableCameraMemoryId) {
        memoryRepository.deleteById(disposableCameraMemoryId);
    }
}
