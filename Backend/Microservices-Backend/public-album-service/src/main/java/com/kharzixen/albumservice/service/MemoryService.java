package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.ImageCreatedResponseDto;
import com.kharzixen.albumservice.dto.incomming.MemoryDtoIn;
import com.kharzixen.albumservice.dto.incomming.PatchMemoryCollectionsDtoIn;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.DetailedMemoryDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewOfCollectionDtoOut;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.mapper.MemoryMapper;
import com.kharzixen.albumservice.model.*;
import com.kharzixen.albumservice.projection.MemoryOfCollectionProjection;
import com.kharzixen.albumservice.projection.MemoryProjection;
import com.kharzixen.albumservice.repository.*;
import com.kharzixen.albumservice.webclient.ImageServiceClient;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@AllArgsConstructor
@Service
@Slf4j
public class MemoryService {
    private final MemoryRepository memoryRepository;
    private final UserRepository userRepository;
    private final AlbumRepository albumRepository;
    private final MemoryCollectionRepository collectionRepository;
    private final MemoryCollectionRelationshipRepository memoryCollectionRelationshipRepository;
    private final MemoryEventOutboxRepository memoryEventOutboxRepository;


    private ImageServiceClient imageServiceClient;

    @Transactional
    public MemoryPreviewDtoOut createMemory(Long albumId, MemoryDtoIn memoryDtoIn) {
        try {
            if (!Objects.equals(albumId, memoryDtoIn.getAlbumId())) {
                throw new RuntimeException("AlbumId in path must be equal to albumId in dto");
            }

            //verify if album exists
            Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));

            //should check via JWT token
            // it is faster like this, the album.contributors is lazy loaded.
            if (!albumRepository.isUserContributorOfAlbum(memoryDtoIn.getUploaderId(), albumId)) {
                throw new RuntimeException("User is not contributor of the album");
            }

            if (memoryDtoIn.getImage() == null ||
                    !Objects.requireNonNull(memoryDtoIn.getImage().getContentType()).startsWith("image/")) {
                throw new RuntimeException("File is not an image");
            }


            Memory memory = MemoryMapper.INSTANCE.dtoToModel(memoryDtoIn);
            //getting and checking user
            User uploader = userRepository.findById(memoryDtoIn.getUploaderId())
                    .orElseThrow(() -> new NotFoundException("User", memoryDtoIn.getUploaderId()));

            memory.setCollections(new ArrayList<>());
            for (Long collectionId : memoryDtoIn.getCollectionIds()) {
                MemoryCollection collection = collectionRepository.findById(collectionId)
                        .orElseThrow(() -> new NotFoundException("Collection", collectionId));
                if (!Objects.equals(collection.getAlbum().getId(), album.getId())) {
                    throw new RuntimeException("Unknown collections in album");
                }
                MemoryCollectionRelationship collectionMemoryRelation =
                        new MemoryCollectionRelationship(null, memory, collection, new Date());
                memory.getCollections().add(collectionMemoryRelation);
                collection.getMemories().add(collectionMemoryRelation);
            }


            memory.setUploader(uploader);
            memory.setCreationDate(new Date());
            memory.setAlbum(album);
            ImageCreatedResponseDto response = imageServiceClient.postImageToMediaService(memoryDtoIn.getImage(),
                    album.getId());
            memory.setImageId(response.getImageId());
            Memory saved = memoryRepository.save(memory);
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

    public Page<MemoryPreviewOfCollectionDtoOut> getMemoriesOfCollectionPaginated(Long albumId, Long collectionId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "addedDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Page<MemoryOfCollectionProjection> pageResponse = memoryRepository
                .findMemoriesOfCollectionPaginated(collectionId, pageRequest);
        List<MemoryPreviewOfCollectionDtoOut> dtos = pageResponse.getContent()
                .stream().map((projection) ->
                        new MemoryPreviewOfCollectionDtoOut(MemoryMapper.INSTANCE.modelToPreviewDto(projection.getMemory()), projection.getAddedDate())).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
    }

    public DetailedMemoryDtoOut getMemoryById(Long albumId, Long memoryId) {
        Memory memory = memoryRepository.findById(memoryId).orElseThrow(() -> new NotFoundException("Memory", memoryId));

        if (Objects.equals(memory.getAlbum().getId(), albumId)) {
            //check user authorization
            return MemoryMapper.INSTANCE.modelToDetailedDto(memory);
        } else {
            throw new RuntimeException("Unatuthorized");
        }

    }

    @Transactional
    public void deleteMemory(Long albumId, Long memoryId) {
        //TODO authorization for this method;
        Memory memory = memoryRepository.findById(memoryId).orElseThrow(() -> new NotFoundException("Memory", memoryId));

        memoryCollectionRelationshipRepository.deleteAllMemoryCollectionRelationshipWhereMemoryId(memoryId);
        memoryEventOutboxRepository.save(new MemoryEventOutbox(null, "DELETE", memory.getImageId()));
        memoryRepository.deleteById(memory.getId());
        log.info("Memory deleted");

    }

    //TODO: REDO with new collection-memory relation
    public DetailedMemoryDtoOut patchCollectionsOfMemory(Long albumId, Long memoryId, PatchMemoryCollectionsDtoIn dtoIn) {
        //check if jwt token userId is authorized to perform this action (is contributor of album);
        Memory memory = memoryRepository.findById(memoryId).orElseThrow(() -> new NotFoundException("Memory", memoryId));
        ArrayList<MemoryCollection> newCollectionsList = dtoIn.getCollectionIds().stream()
                .map((collectionId) ->
                        collectionRepository.findById(collectionId)
                                .orElseThrow(() -> new NotFoundException("Collection", collectionId)))
                .collect(Collectors.toCollection(ArrayList::new));
        List<MemoryCollectionRelationship> _memoryCollectionRelationships = new ArrayList<>();
        for (MemoryCollection collection : newCollectionsList) {
            _memoryCollectionRelationships.add(new MemoryCollectionRelationship(null, memory, collection, new Date()));
        }
        memory.setCollections(_memoryCollectionRelationships);
        Memory saved = memoryRepository.saveAndFlush(memory);
        return MemoryMapper.INSTANCE.modelToDetailedDto(saved);
    }

    public Page<MemoryPreviewDtoOut> getMemoriesOfAlbumByUploaderWhichNotIncludedInCollectionPaginated(
            Long albumId, Long uploaderId, Long collectionId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
        MemoryCollection collection = collectionRepository.findById(collectionId).orElseThrow(() -> new NotFoundException("Collection", collectionId));
        User uploader = userRepository.findById(uploaderId).orElseThrow(() -> new NotFoundException("User", uploaderId));


        if (!album.getContributors().contains(uploader)) {
            throw new RuntimeException("User not contributor of this album");
        }

        if (collection.getAlbum() != album) {
            throw new RuntimeException("Collection not part of the album");
        }


        Page<MemoryProjection> pageResponse = memoryRepository
                .findMemoriesOfAlbumByUploaderWhichNotIncludedInCollectionPaginated(album.getId(), collection.getId(), uploader.getId(), pageRequest);
        List<MemoryPreviewDtoOut> dtos = pageResponse.getContent()
                .stream().map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        return new PageImpl<>(dtos, pageRequest, pageResponse.getTotalElements());
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
}