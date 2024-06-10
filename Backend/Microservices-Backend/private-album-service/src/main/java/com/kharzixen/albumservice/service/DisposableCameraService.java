package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.DisposableCameraPatchDtoIn;
import com.kharzixen.albumservice.dto.outgoing.albumDto.DisposableCameraDtoOut;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
import com.kharzixen.albumservice.mapper.DisposableCameraMapper;
import com.kharzixen.albumservice.model.*;
import com.kharzixen.albumservice.repository.*;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class DisposableCameraService {

    private final DisposableCameraRepository disposableCameraRepository;
    private final AlbumRepository albumRepository;
    private final MemoryCollectionRepository memoryCollectionRepository;
    private final MemoryRepository memoryRepository;
    private final MemoryCollectionRelationshipRepository relationshipRepository;
    private final DisposableCameraMemoryRepository disposableCameraMemoryRepository;

    @Transactional
    public DisposableCameraDtoOut patchDisposableCameraOfAlbum(Long albumId, DisposableCameraPatchDtoIn patchDtoIn, Long requesterId) {
        Album album = albumRepository.findById(albumId).orElseThrow(() -> new NotFoundException("ALBUM", albumId));
        if(Objects.equals(album.getOwner().getId(), requesterId)){
            DisposableCamera disposableCamera = album.getDisposableCamera();
            if(patchDtoIn.getIsActive() == null){
                throw new RuntimeException("isActive error");
            }
            if(patchDtoIn.getIsActive() && !disposableCamera.getIsActive()){
                disposableCamera.setIsActive(true);
                disposableCamera.setDescription(patchDtoIn.getDescription());
                disposableCamera.setCloseTime(patchDtoIn.getCloseTime());
                DisposableCamera saved = disposableCameraRepository.save(disposableCamera);
                return DisposableCameraMapper.INSTANCE.modelToDto(saved);
            } else if(!patchDtoIn.getIsActive() && disposableCamera.getIsActive()){
                //if the user wants to make the disposable camera inactive
                if(!disposableCamera.getMemories().isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/YYYY HH:mm:ss");
                    String dateString = sdf.format(new Date());
                    MemoryCollection memoryCollection = new MemoryCollection(null,
                            "Disposable Camera - " + dateString,
                            "Disposable Camera Collection Created on: " + dateString,
                            album.getOwner(), album,
                            List.of(),
                            new Date());
                    MemoryCollection savedMemoryCollection = memoryCollectionRepository.save(memoryCollection);
                    List<Memory> memories = new ArrayList<>(album.getDisposableCamera().getMemories().stream()
                            .map((e) -> new Memory(null, e.getCaption(), e.getImageId(), e.getCreationDate(),
                                    e.getUploader(), album, List.of(), List.of(), List.of())).toList());

                    List<Memory> savedMemories = memoryRepository.saveAll(memories);
                    List<MemoryCollectionRelationship> relationships = savedMemories.stream()
                            .map(memory ->
                                    new MemoryCollectionRelationship(null, memory,
                                            memoryCollection, memory.getCreationDate())).toList();
                    relationshipRepository.saveAll(relationships);
                }
                disposableCamera.setIsActive(false);
                disposableCamera.setDescription(patchDtoIn.getDescription());
                disposableCamera.getMemories().clear();
                DisposableCamera saved = disposableCameraRepository.save(disposableCamera);
                return DisposableCameraMapper.INSTANCE.modelToDto(saved);
            } else {
                throw new RuntimeException("Bad request");
            }
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }

    }
}
