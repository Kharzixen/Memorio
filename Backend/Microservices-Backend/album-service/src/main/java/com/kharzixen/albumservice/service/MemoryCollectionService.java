package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.MemoryCollectionDtoIn;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.albumservice.exception.CollectionNameDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.mapper.MemoryCollectionMapper;
import com.kharzixen.albumservice.mapper.MemoryMapper;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.MemoryCollection;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.projection.MemoryCollectionPreviewProjection;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.MemoryCollectionRepository;
import com.kharzixen.albumservice.repository.MemoryRepository;
import com.kharzixen.albumservice.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
@Slf4j
public class MemoryCollectionService {
    private final MemoryCollectionRepository memoryCollectionRepository;
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;
    private final MemoryRepository memoryRepository;

    @Transactional
    public MemoryCollectionDtoOut createCollection(Long albumId, MemoryCollectionDtoIn dtoIn)
            throws EntityNotFoundException {
        try {
            if (!Objects.equals(dtoIn.getAlbumId(), albumId)) {
                //TODO same with userID and jwt id
                throw new RuntimeException("albumId in body and path must be equal");
            }

            if (!albumRepository.isUserContributorOfAlbum(dtoIn.getCreatorId(), dtoIn.getAlbumId())) {
                throw new RuntimeException("User not a contributor of the album");
            }

            //move to mapper logic
            MemoryCollection memoryCollection = new MemoryCollection();
            memoryCollection.setCollectionName(dtoIn.getCollectionName());
            memoryCollection.setMemories(new ArrayList<>());
            Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("Album", albumId));
            User user = userRepository.findById(dtoIn.getCreatorId()).orElseThrow(() -> new NotFoundException("User", dtoIn.getCreatorId()));
            memoryCollection.setCreator(user);
            memoryCollection.setAlbum(album);
            memoryCollection.setCreationDate(new Date());
            memoryCollection.setCollectionDescription(dtoIn.getCollectionDescription());
            MemoryCollection savedMemoryCollection = memoryCollectionRepository.save(memoryCollection);
            return MemoryCollectionMapper.INSTANCE.modelToDto(savedMemoryCollection);
        } catch (DataIntegrityViolationException ex) {

            if (ex.getMessage().contains("Duplicate entry")) {
                throw new CollectionNameDuplicateException("Collection with name: " + dtoIn.getCollectionName() + " already exists in this album");
            }
            if (ex.getMessage().contains("album")) {
                throw new NotFoundException("Album", albumId);
            }
            if (ex.getMessage().contains("user")) {
                throw new NotFoundException("User", dtoIn.getCreatorId());
            }

            throw new RuntimeException(ex.getMessage());

        }
    }

    public Page<MemoryCollectionPreviewDtoOut> getCollectionPreviewsPaginated(Long albumId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable collectionPageRequest = PageRequest.of(page,pageSize,sort);

        Pageable memoryPageRequest = PageRequest.of(0, 4, sort);

        Page<MemoryCollectionPreviewProjection> pageResponse = memoryCollectionRepository
                .findAllCollectionsOfAlbumPaginated(albumId, collectionPageRequest );
        List<MemoryCollectionPreviewDtoOut> collectionDtos = pageResponse.getContent().stream()
                .map(projection -> {
                    MemoryCollectionPreviewDtoOut dtoOut = MemoryCollectionMapper.INSTANCE.projectionToDto(projection);
                    List<MemoryPreviewDtoOut> latestMemories =
                            memoryRepository.findMemoriesOfCollectionPaginated(projection.getId(), memoryPageRequest).stream()
                                    .map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList();
                    dtoOut.setLatestMemories(latestMemories);
                    return dtoOut;
                })
                .toList();
        return new PageImpl<>(collectionDtos,collectionPageRequest, pageResponse.getTotalElements());
    }

    public MemoryCollectionPreviewDtoOut getCollectionPreviewById(Long albumId, Long collectionId) {
        MemoryCollection collection = memoryCollectionRepository.findById(collectionId)
                .orElseThrow(() -> new NotFoundException("Collection", collectionId));
        MemoryCollectionPreviewDtoOut responseDto =  MemoryCollectionMapper.INSTANCE.modelToPreviewDto(collection);
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable memoryPageRequestForLatestMemories = PageRequest.of(0, 4, sort);
        List<MemoryPreviewDtoOut> latestMemories =
                memoryRepository.
                        findMemoriesOfCollectionPaginated(collection.getId(), memoryPageRequestForLatestMemories)
                        .stream()
                        .map(MemoryMapper.INSTANCE::projectionToPreviewDto).toList();
        responseDto.setLatestMemories(latestMemories);
        return responseDto;
    }
}
