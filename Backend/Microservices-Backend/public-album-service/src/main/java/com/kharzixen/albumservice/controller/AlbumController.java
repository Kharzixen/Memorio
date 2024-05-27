package com.kharzixen.albumservice.controller;

import com.kharzixen.albumservice.dto.incomming.*;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumContributorsPatchedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionPatchedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.collectionDto.MemoryCollectionPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.DetailedMemoryDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewOfCollectionDtoOut;
import com.kharzixen.albumservice.error.ErrorResponse;
import com.kharzixen.albumservice.exception.CollectionNameDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.service.AlbumService;
import com.kharzixen.albumservice.service.MemoryCollectionService;
import com.kharzixen.albumservice.service.MemoryService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/public-albums")
public class AlbumController {

    private final AlbumService albumService;
    private final MemoryCollectionService collectionService;
    private final MemoryService memoryService;

    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<AlbumDtoOut> createAlbum(@ModelAttribute AlbumDtoIn albumDtoIn) {
        AlbumDtoOut responseBody = albumService.createAlbum(albumDtoIn);
        return new ResponseEntity<>(responseBody, HttpStatus.OK);
    }

    @PostMapping("/{albumId}/collections")
    ResponseEntity<MemoryCollectionDtoOut> createCollection(@PathVariable Long albumId, @RequestBody MemoryCollectionDtoIn collectionDtoIn) {
        MemoryCollectionDtoOut dtoOut = collectionService.createCollection(albumId, collectionDtoIn);
        return new ResponseEntity<>(dtoOut, HttpStatus.CREATED);
    }

    @PostMapping(path = "/{albumId}/memories", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<MemoryPreviewDtoOut> createMemory(@PathVariable Long albumId, @ModelAttribute MemoryDtoIn memoryDtoIn) {
        MemoryPreviewDtoOut dtoOut = memoryService.createMemory(albumId, memoryDtoIn);
        return new ResponseEntity<>(dtoOut, HttpStatus.CREATED);
    }

    @GetMapping("/{albumId}")
    ResponseEntity<AlbumDtoOut> getAlbumInfo(@PathVariable Long albumId) {
        AlbumDtoOut albumDtoOut = albumService.getAlbumById(albumId);
        return ResponseEntity.ok(albumDtoOut);
    }

    @GetMapping("/{albumId}/contributors")
    ResponseEntity<List<UserDtoOut>> getContributorsOfAlbum(@PathVariable Long albumId){
        List<UserDtoOut> contributors = albumService.getContributorsOfAlbum(albumId);
        return ResponseEntity.ok(contributors);
    }

    @GetMapping("/{albumId}/contributors/{contributorId}")
    ResponseEntity<UserDtoOut> getContributorOfAlbumById(@PathVariable Long albumId, @PathVariable Long contributorId){
        UserDtoOut contributor = albumService.getContributorByIdOfAlbum(albumId, contributorId);
        return ResponseEntity.ok(contributor);
    }

    @PatchMapping("/{albumId}/contributors")
    ResponseEntity<AlbumContributorsPatchedDtoOut> patchContributorsOfAlbum(@PathVariable Long albumId,@RequestBody PatchAlbumContributorsDtoIn patchDto) {
        switch (patchDto.getMethod()) {
            case "ADD":
                AlbumContributorsPatchedDtoOut response = albumService
                        .addContributors(albumId, patchDto);
                return new ResponseEntity<>(response, HttpStatus.OK);
            default:
                throw new RuntimeException("Unknown method");
        }
    }

    @GetMapping("/{albumId}/collections")
    ResponseEntity<Page<MemoryCollectionPreviewDtoOut>> getCollectionPreviewsOfAlbum(
            @PathVariable Long albumId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        Page<MemoryCollectionPreviewDtoOut> pageOfCollections = collectionService
                .getCollectionPreviewsPaginated(albumId, page, pageSize);
        return ResponseEntity.ok(pageOfCollections);
    }

    @GetMapping("/{albumId}/collections/{collectionId}")
    ResponseEntity<MemoryCollectionPreviewDtoOut> getCollectionPreviewById(@PathVariable Long albumId, @PathVariable Long collectionId) {
        MemoryCollectionPreviewDtoOut responseObject = collectionService.getCollectionPreviewById(albumId, collectionId);
        return ResponseEntity.ok(responseObject);
    }

    @GetMapping("/{albumId}/collections/{collectionId}/memories")
    ResponseEntity<Page<MemoryPreviewOfCollectionDtoOut>> getMemoriesOfCollection(
            @PathVariable Long albumId,
            @PathVariable Long collectionId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        Page<MemoryPreviewOfCollectionDtoOut> pageOfMemories =
                memoryService.getMemoriesOfCollectionPaginated(albumId, collectionId, page, pageSize);
        return ResponseEntity.ok(pageOfMemories);

    }

    @PatchMapping("/{albumId}/memories/{memoryId}/collections")
    ResponseEntity<DetailedMemoryDtoOut> getMemoriesOfCollection(
            @PathVariable Long albumId,
            @PathVariable Long memoryId,
            @Valid @RequestBody PatchMemoryCollectionsDtoIn dtoIn) {
        DetailedMemoryDtoOut memoryDtoOut = memoryService.patchCollectionsOfMemory(albumId, memoryId, dtoIn);
        return ResponseEntity.ok(memoryDtoOut);
    }


    @GetMapping("/{albumId}/memories")
    ResponseEntity<Page<MemoryPreviewDtoOut>> getMemoriesOfAlbum(
            @PathVariable Long albumId,
            @RequestParam(required = false) Long uploaderId,
            @RequestParam(required = false, name = "notIncludedInCollectionId") Long collectionId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        if (uploaderId != null && collectionId != null) {
            Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumByUploaderWhichNotIncludedInCollectionPaginated(albumId, uploaderId, collectionId, page, pageSize);
            return ResponseEntity.ok(pageOfMemories);
        }

        if (uploaderId != null) {
            Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumByUploaderPaginated(albumId, uploaderId, page, pageSize);
            return ResponseEntity.ok(pageOfMemories);
        }

        Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumPaginated(albumId, page, pageSize);
        return ResponseEntity.ok(pageOfMemories);
    }

    @GetMapping("/{albumId}/memories/{memoryId}")
    ResponseEntity<DetailedMemoryDtoOut> getMemoryById(
            @PathVariable Long albumId,
            @PathVariable Long memoryId) {
        DetailedMemoryDtoOut responseDto = memoryService.getMemoryById(albumId, memoryId);
        return ResponseEntity.ok(responseDto);
    }

    @DeleteMapping("/{albumId}/memories/{memoryId}")
    ResponseEntity<Void> deleteMemoryById(@PathVariable Long albumId, @PathVariable Long memoryId) {
        memoryService.deleteMemory(albumId, memoryId);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{albumId}")
    ResponseEntity<Void>  deleteAlbumWithEverything(@PathVariable Long albumId){
        albumService.removeAlbum(albumId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{albumId}/collections/{collectionId}/memories")
    ResponseEntity<MemoryCollectionPatchedDtoOut> patchMemoriesOfCollection(
            @PathVariable Long albumId,
            @PathVariable Long collectionId,
            @RequestBody PatchCollectionMemoriesDtoIn patchCollectionMemoriesDtoIn) {
        switch (patchCollectionMemoriesDtoIn.getMethod()) {
            case "ADD":
                MemoryCollectionPatchedDtoOut resp = collectionService
                        .addMemoriesToCollection(albumId, collectionId, patchCollectionMemoriesDtoIn);
                return new ResponseEntity<>(resp, HttpStatus.OK);
            default:
                throw new RuntimeException("Unknown method");
        }
    }

    @DeleteMapping("/{albumId}/collections/{collectionId}")
    ResponseEntity<Void> deleteCollection(@PathVariable Long albumId,
                                          @PathVariable Long collectionId){
        collectionService.deleteCollection(albumId, collectionId);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{albumId}/contributors/{userId}")
    ResponseEntity<Void> patchUserAlbums(@PathVariable Long userId, @PathVariable Long albumId){
        albumService.removeUserFromAlbum(userId, albumId);
        return ResponseEntity.noContent().build();
    }

    @ExceptionHandler(CollectionNameDuplicateException.class)
    ResponseEntity<ErrorResponse> handleDuplicateCollectionNameException(CollectionNameDuplicateException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.CONFLICT.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(NotFoundException.class)
    ResponseEntity<ErrorResponse> handleDuplicateCollectionNameException(NotFoundException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.NOT_FOUND.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

}
