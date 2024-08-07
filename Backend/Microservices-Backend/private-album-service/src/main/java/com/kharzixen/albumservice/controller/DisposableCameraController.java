package com.kharzixen.albumservice.controller;

import com.kharzixen.albumservice.dto.incomming.DisposableCameraMemoryDtoIn;
import com.kharzixen.albumservice.dto.incomming.DisposableCameraPatchDtoIn;
import com.kharzixen.albumservice.dto.outgoing.albumDto.DisposableCameraDtoOut;
import com.kharzixen.albumservice.dto.outgoing.disposableCameraMemoryDto.DisposableCameraMemoryDtoOut;
import com.kharzixen.albumservice.service.DisposableCameraMemoryService;
import com.kharzixen.albumservice.service.DisposableCameraService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api/private-albums")
public class DisposableCameraController {


    private final DisposableCameraService disposableCameraService;
    private final DisposableCameraMemoryService disposableCameraMemoryService;


    @PatchMapping("/{albumId}/disposable-camera")
    ResponseEntity<DisposableCameraDtoOut> getDisposableCameraOfAlbum(@PathVariable Long albumId,
                                                                      @RequestBody DisposableCameraPatchDtoIn patchDtoIn,
                                                                      @RequestHeader("X-USER-ID") String requesterId,
                                                                      @RequestHeader("X-USERNAME") String username) {
        DisposableCameraDtoOut dtoOut = disposableCameraService
                .patchDisposableCameraOfAlbum(albumId, patchDtoIn, Long.valueOf(requesterId));
        return ResponseEntity.ok(dtoOut);
    }


    @GetMapping("/{albumId}/disposable-camera/memories")
    ResponseEntity<Page<DisposableCameraMemoryDtoOut>> getDisposableCameraMemoriesOfAlbum(
            @PathVariable Long albumId,
            @RequestParam(required = false) Long uploaderId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {

        if (uploaderId != null) {
            Page<DisposableCameraMemoryDtoOut> pageOfMemories = disposableCameraMemoryService
                    .getDisposableCameraMemoriesByUploaderPaginated(albumId, uploaderId, page, pageSize, Long.valueOf(requesterId));
            return ResponseEntity.ok(pageOfMemories);
        }

        Page<DisposableCameraMemoryDtoOut> pageOfMemories = disposableCameraMemoryService
                .getDisposableCameraMemoriesPaginated(albumId, page, pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(pageOfMemories);
    }

    @GetMapping("/{albumId}/disposable-camera/memories/{memoryId}")
    ResponseEntity<DisposableCameraMemoryDtoOut> getDisposableMemoryOfAlbumById(
            @PathVariable Long albumId,
            @PathVariable(value = "memoryId") Long disposableCameraMemoryId,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        DisposableCameraMemoryDtoOut dtoOut = disposableCameraMemoryService
                .getDisposableCameraMemoryOfAlbumById(albumId, disposableCameraMemoryId, Long.valueOf(requesterId));
        return ResponseEntity.ok(dtoOut);
    }

    @DeleteMapping("/{albumId}/disposable-camera/memories/{memoryId}")
    ResponseEntity<Void> deleteDisposableMemoryById(
            @PathVariable Long albumId,
            @PathVariable(value = "memoryId") Long disposableCameraMemoryId,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        disposableCameraMemoryService
                .deleteDisposableMemoryById(albumId, disposableCameraMemoryId, Long.valueOf(requesterId));
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PostMapping(path = "/{albumId}/disposable-camera/memories", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<DisposableCameraMemoryDtoOut> createMemory(@PathVariable Long albumId,
                                                              @ModelAttribute DisposableCameraMemoryDtoIn memoryDtoIn,
                                                              @RequestHeader("X-USER-ID") String requesterId,
                                                              @RequestHeader("X-USERNAME") String username) {
        DisposableCameraMemoryDtoOut dtoOut = disposableCameraMemoryService
                .createDisposableCameraMemory(albumId, memoryDtoIn, Long.valueOf(requesterId));
        return new ResponseEntity<>(dtoOut, HttpStatus.CREATED);
    }

}
