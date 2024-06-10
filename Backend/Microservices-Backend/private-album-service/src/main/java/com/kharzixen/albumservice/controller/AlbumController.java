package com.kharzixen.albumservice.controller;

import com.kharzixen.albumservice.dto.incomming.*;
import com.kharzixen.albumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.albumservice.dto.outgoing.LikeDtoOut;
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
import com.kharzixen.albumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
import com.kharzixen.albumservice.service.*;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/private-albums")
public class AlbumController {

    private final AlbumService albumService;
    private final MemoryCollectionService collectionService;
    private final MemoryService memoryService;
    private final LikeService likeService;
    private final CommentService commentService;

    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<AlbumDtoOut> createAlbum(@ModelAttribute AlbumDtoIn albumDtoIn,
                                            @RequestHeader("X-USER-ID") String requesterId,
                                            @RequestHeader("X-USERNAME") String username) {
        AlbumDtoOut responseBody = albumService.createAlbum(albumDtoIn, Long.valueOf(requesterId));
        return new ResponseEntity<>(responseBody, HttpStatus.OK);
    }

    @PostMapping("/{albumId}/collections")
    ResponseEntity<MemoryCollectionDtoOut> createCollection(@PathVariable Long albumId,
                                                            @RequestBody MemoryCollectionDtoIn collectionDtoIn,
                                                            @RequestHeader("X-USER-ID") String requesterId,
                                                            @RequestHeader("X-USERNAME") String username) {
        MemoryCollectionDtoOut dtoOut = collectionService.createCollection(albumId, collectionDtoIn, Long.valueOf(requesterId));
        return new ResponseEntity<>(dtoOut, HttpStatus.CREATED);
    }

    @PostMapping(path = "/{albumId}/memories", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<MemoryPreviewDtoOut> createMemory(@PathVariable Long albumId,
                                                     @ModelAttribute MemoryDtoIn memoryDtoIn,
                                                     @RequestHeader("X-USER-ID") String requesterId,
                                                     @RequestHeader("X-USERNAME") String username) {
        MemoryPreviewDtoOut dtoOut = memoryService.createMemory(albumId, memoryDtoIn, Long.valueOf(requesterId));
        return new ResponseEntity<>(dtoOut, HttpStatus.CREATED);
    }

    @GetMapping("/{albumId}")
    ResponseEntity<AlbumDtoOut> getAlbumInfo(@PathVariable Long albumId,
                                             @RequestHeader("X-USER-ID") String requesterId,
                                             @RequestHeader("X-USERNAME") String username) {
        AlbumDtoOut albumDtoOut = albumService.getAlbumById(albumId, Long.valueOf(requesterId));
        return ResponseEntity.ok(albumDtoOut);
    }

    @GetMapping("/{albumId}/contributors")
    ResponseEntity<List<UserDtoOut>> getContributorsOfAlbum(@PathVariable Long albumId,
                                                            @RequestHeader("X-USER-ID") String requesterId,
                                                            @RequestHeader("X-USERNAME") String username) {
        List<UserDtoOut> contributors = albumService.getContributorsOfAlbum(albumId, Long.valueOf(requesterId));
        return ResponseEntity.ok(contributors);
    }

    @GetMapping("/{albumId}/contributors/{contributorId}")
    ResponseEntity<UserDtoOut> getContributorOfAlbumById(@PathVariable Long albumId,
                                                         @PathVariable Long contributorId,
                                                         @RequestHeader("X-USER-ID") String requesterId,
                                                         @RequestHeader("X-USERNAME") String username) {
        UserDtoOut contributor = albumService.getContributorByIdOfAlbum(albumId, contributorId, Long.valueOf(requesterId));
        return ResponseEntity.ok(contributor);
    }

    @PatchMapping("/{albumId}/contributors")
    ResponseEntity<AlbumContributorsPatchedDtoOut> patchContributorsOfAlbum(@PathVariable Long albumId,
                                                                            @RequestBody PatchAlbumContributorsDtoIn patchDto,
                                                                            @RequestHeader("X-USER-ID") String requesterId,
                                                                            @RequestHeader("X-USERNAME") String username) {
        switch (patchDto.getMethod()) {
            case "ADD":
                AlbumContributorsPatchedDtoOut response = albumService
                        .addContributors(albumId, patchDto, Long.valueOf(requesterId));
                return new ResponseEntity<>(response, HttpStatus.OK);
            default:
                throw new RuntimeException("Unknown method");
        }
    }

    @GetMapping("/{albumId}/collections")
    ResponseEntity<Page<MemoryCollectionPreviewDtoOut>> getCollectionPreviewsOfAlbum(
            @PathVariable Long albumId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        Page<MemoryCollectionPreviewDtoOut> pageOfCollections = collectionService
                .getCollectionPreviewsPaginated(albumId, page, pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(pageOfCollections);
    }

    @GetMapping("/{albumId}/collections/{collectionId}")
    ResponseEntity<MemoryCollectionPreviewDtoOut> getCollectionPreviewById(@PathVariable Long albumId,
                                                                           @PathVariable Long collectionId,
                                                                           @RequestHeader("X-USER-ID") String requesterId,
                                                                           @RequestHeader("X-USERNAME") String username) {
        MemoryCollectionPreviewDtoOut responseObject = collectionService
                .getCollectionPreviewById(albumId, collectionId, Long.valueOf(requesterId));
        return ResponseEntity.ok(responseObject);
    }

    @GetMapping("/{albumId}/collections/{collectionId}/memories")
    ResponseEntity<Page<MemoryPreviewOfCollectionDtoOut>> getMemoriesOfCollection(
            @PathVariable Long albumId,
            @PathVariable Long collectionId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        Page<MemoryPreviewOfCollectionDtoOut> pageOfMemories =
                memoryService.getMemoriesOfCollectionPaginated(albumId, collectionId, page,
                        pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(pageOfMemories);

    }

//    @PatchMapping("/{albumId}/memories/{memoryId}/collections")
//    ResponseEntity<DetailedMemoryDtoOut> getMemoriesOfCollection(
//            @PathVariable Long albumId,
//            @PathVariable Long memoryId,
//            @Valid @RequestBody PatchMemoryCollectionsDtoIn dtoIn) {
//        DetailedMemoryDtoOut memoryDtoOut = memoryService.patchCollectionsOfMemory(albumId, memoryId, dtoIn);
//        return ResponseEntity.ok(memoryDtoOut);
//    }


    @GetMapping("/{albumId}/memories")
    ResponseEntity<Page<MemoryPreviewDtoOut>> getMemoriesOfAlbum(
            @PathVariable Long albumId,
            @RequestParam(required = false) Long uploaderId,
            @RequestParam(required = false, name = "notIncludedInCollectionId") Long collectionId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        if (uploaderId != null && collectionId != null) {
            Page<MemoryPreviewDtoOut> pageOfMemories =
                    memoryService.getMemoriesOfAlbumByUploaderWhichNotIncludedInCollectionPaginated(albumId,
                            uploaderId, collectionId, page, pageSize, Long.valueOf(requesterId));
            return ResponseEntity.ok(pageOfMemories);
        }

        if (uploaderId != null) {
            Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumByUploaderPaginated(albumId,
                    uploaderId, page, pageSize, Long.valueOf(requesterId));
            return ResponseEntity.ok(pageOfMemories);
        }

        Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumPaginated(albumId, page, pageSize,
                Long.valueOf(requesterId));
        return ResponseEntity.ok(pageOfMemories);
    }

    @GetMapping("/{albumId}/memories/{memoryId}")
    ResponseEntity<DetailedMemoryDtoOut> getMemoryById(
            @PathVariable Long albumId,
            @PathVariable Long memoryId,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        DetailedMemoryDtoOut responseDto = memoryService
                .getMemoryById(albumId, memoryId, Long.valueOf(requesterId));
        return ResponseEntity.ok(responseDto);
    }

    @DeleteMapping("/{albumId}/memories/{memoryId}")
    ResponseEntity<Void> deleteMemoryById(@PathVariable Long albumId,
                                          @PathVariable Long memoryId,
                                          @RequestHeader("X-USER-ID") String requesterId,
                                          @RequestHeader("X-USERNAME") String username) {
        memoryService.deleteMemory(albumId, memoryId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{albumId}")
    ResponseEntity<Void> deleteAlbumWithEverything(@PathVariable Long albumId,
                                                   @RequestHeader("X-USER-ID") String requesterId,
                                                   @RequestHeader("X-USERNAME") String username) {
        albumService.removeAlbum(albumId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{albumId}/collections/{collectionId}/memories")
    ResponseEntity<MemoryCollectionPatchedDtoOut> patchMemoriesOfCollection(
            @PathVariable Long albumId,
            @PathVariable Long collectionId,
            @RequestBody PatchCollectionMemoriesDtoIn patchCollectionMemoriesDtoIn,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        switch (patchCollectionMemoriesDtoIn.getMethod()) {
            case "ADD":
                MemoryCollectionPatchedDtoOut resp = collectionService
                        .addMemoriesToCollection(albumId, collectionId,
                                patchCollectionMemoriesDtoIn, Long.valueOf(requesterId));
                return new ResponseEntity<>(resp, HttpStatus.OK);
            default:
                throw new RuntimeException("Unknown method");
        }
    }

    @DeleteMapping("/{albumId}/collections/{collectionId}")
    ResponseEntity<Void> deleteCollection(@PathVariable Long albumId,
                                          @PathVariable Long collectionId,
                                          @RequestHeader("X-USER-ID") String requesterId,
                                          @RequestHeader("X-USERNAME") String username) {
        collectionService.deleteCollection(albumId, collectionId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{albumId}/contributors/{userId}")
    ResponseEntity<Void> patchUserAlbums(@PathVariable Long userId,
                                         @PathVariable Long albumId,
                                         @RequestHeader("X-USER-ID") String requesterId,
                                         @RequestHeader("X-USERNAME") String username) {
        albumService.removeUserFromAlbum(userId, albumId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{albumId}/memories/{memoryId}/likes")
    ResponseEntity<LikeDtoOut> createLike(@PathVariable Long albumId,
                                          @PathVariable Long memoryId,
                                          @RequestBody LikeDtoIn dtoIn,
                                          @RequestHeader("X-USER-ID") String requesterId,
                                          @RequestHeader("X-USERNAME") String username) {
        LikeDtoOut likeDtoOut = likeService.createLike(albumId, memoryId, dtoIn, Long.valueOf(requesterId));
        return ResponseEntity.ok(likeDtoOut);
    }

    @GetMapping("/{albumId}/memories/{memoryId}/likes")
    ResponseEntity<List<LikeDtoOut>> getAllLikesOfMemory(@PathVariable Long albumId,
                                                         @PathVariable Long memoryId,
                                                         @RequestHeader("X-USER-ID") String requesterId,
                                                         @RequestHeader("X-USERNAME") String username) {
        List<LikeDtoOut> likes = likeService.getAllLikesOfMemory(albumId, memoryId, Long.valueOf(requesterId));
        return ResponseEntity.ok(likes);
    }


    @PostMapping("/{albumId}/memories/{memoryId}/comments")
    ResponseEntity<CommentDtoOut> createComment(@PathVariable Long albumId,
                                                @PathVariable Long memoryId,
                                                @RequestBody CommentDtoIn dtoIn,
                                                @RequestHeader("X-USER-ID") String requesterId,
                                                @RequestHeader("X-USERNAME") String username) {
        CommentDtoOut commentDtoOut = commentService.createComment(albumId, memoryId, dtoIn, Long.valueOf(requesterId));
        return ResponseEntity.ok(commentDtoOut);
    }

    @GetMapping("/{albumId}/memories/{memoryId}/comments")
    ResponseEntity<List<CommentDtoOut>> getAllCommentsOfMemory(@PathVariable Long albumId,
                                                               @PathVariable Long memoryId,
                                                               @RequestHeader("X-USER-ID") String requesterId,
                                                               @RequestHeader("X-USERNAME") String username) {
        List<CommentDtoOut> comments = commentService.getAllCommentsOfMemory(albumId, memoryId, Long.valueOf(requesterId));
        return ResponseEntity.ok(comments);
    }

    @DeleteMapping("/{albumId}/memories/{memoryId}/comments/{commentId}")
    ResponseEntity<Void> deleteCommentById(@PathVariable Long albumId,
                                           @PathVariable Long memoryId,
                                           @PathVariable Long commentId,
                                           @RequestHeader("X-USER-ID") String requesterId,
                                           @RequestHeader("X-USERNAME") String username) {

        commentService.deleteCommentById(albumId, memoryId, commentId, Long.valueOf(requesterId));
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @DeleteMapping("/{albumId}/memories/{memoryId}/likes")
    ResponseEntity<Void> deleteLikeById(@PathVariable Long albumId,
                                        @PathVariable Long memoryId,
                                        @RequestParam Long userId,
                                        @RequestHeader("X-USER-ID") String requesterId,
                                        @RequestHeader("X-USERNAME") String username) {

        likeService.deleteLikeById(albumId, memoryId, userId, Long.valueOf(requesterId));
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @ExceptionHandler(CollectionNameDuplicateException.class)
    ResponseEntity<ErrorResponse> handleDuplicateCollectionNameException(CollectionNameDuplicateException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.CONFLICT.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(MemoryLikeDuplicateException.class)
    ResponseEntity<ErrorResponse> handleDuplicateCollectionNameException(MemoryLikeDuplicateException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.CONFLICT.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(NotFoundException.class)
    ResponseEntity<ErrorResponse> handleDuplicateCollectionNameException(NotFoundException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.NOT_FOUND.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(UnauthorizedRequestException.class)
    ResponseEntity<ErrorResponse> handleUnauthorizedException(UnauthorizedRequestException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
    }

}
