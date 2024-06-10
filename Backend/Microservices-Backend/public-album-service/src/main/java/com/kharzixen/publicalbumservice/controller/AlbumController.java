package com.kharzixen.publicalbumservice.controller;

;
import com.kharzixen.publicalbumservice.dto.incomming.*;
import com.kharzixen.publicalbumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumContributorsPatchedDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.DetailedMemoryDtoOut;
import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.publicalbumservice.error.ErrorResponse;
import com.kharzixen.publicalbumservice.exception.CollectionNameDuplicateException;
import com.kharzixen.publicalbumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.publicalbumservice.exception.NotFoundException;
import com.kharzixen.publicalbumservice.exception.UnauthorizedRequestException;
import com.kharzixen.publicalbumservice.service.AlbumService;
import com.kharzixen.publicalbumservice.service.CommentService;
import com.kharzixen.publicalbumservice.service.LikeService;
import com.kharzixen.publicalbumservice.service.MemoryService;
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


    @PostMapping(path = "/{albumId}/memories", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<MemoryPreviewDtoOut> createMemory(@PathVariable Long albumId,
                                                     @ModelAttribute MemoryDtoIn memoryDtoIn,
                                                     @RequestHeader("X-USER-ID") String requesterId,
                                                     @RequestHeader("X-USERNAME") String username) {
        MemoryPreviewDtoOut dtoOut = memoryService.createMemory(albumId, memoryDtoIn, Long.valueOf(requesterId));
        return new ResponseEntity<>(dtoOut, HttpStatus.CREATED);
    }

    @GetMapping
    ResponseEntity<Page<AlbumPreviewDto>> getAlbumPreviewsForUser(
                                                                  @RequestParam(defaultValue = "0") int page,
                                                                  @RequestParam(defaultValue = "10") int pageSize,
                                                                  @RequestHeader("X-USER-ID") String requesterId,
                                                                  @RequestHeader("X-USERNAME") String username) {

        Page<AlbumPreviewDto> previews = albumService.getAllAlbumPreviews(page, pageSize);
        return new ResponseEntity<>(previews, HttpStatus.OK);
    }

    @GetMapping("/{albumId}")
    ResponseEntity<AlbumDtoOut> getAlbumInfo(@PathVariable Long albumId,
                                             @RequestHeader("X-USER-ID") String requesterId,
                                             @RequestHeader("X-USERNAME") String username) {
        AlbumDtoOut albumDtoOut = albumService.getAlbumById(albumId);
        return ResponseEntity.ok(albumDtoOut);
    }

    @GetMapping("/{albumId}/contributors")
    ResponseEntity<List<UserDtoOut>> getContributorsOfAlbum(@PathVariable Long albumId) {
        List<UserDtoOut> contributors = albumService.getContributorsOfAlbum(albumId);
        return ResponseEntity.ok(contributors);
    }

    @GetMapping("/{albumId}/contributors/{contributorId}")
    ResponseEntity<UserDtoOut> getContributorOfAlbumById(@PathVariable Long albumId, @PathVariable Long contributorId) {
        UserDtoOut contributor = albumService.getContributorByIdOfAlbum(albumId, contributorId);
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



    @PatchMapping("/{albumId}/memories/{memoryId}")
    ResponseEntity<DetailedMemoryDtoOut> patchMemoryById(
            @PathVariable Long albumId,
            @PathVariable Long memoryId,
            @RequestBody PatchMemoryDtoIn dtoIn,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        DetailedMemoryDtoOut responseDto = memoryService.patchMemoryDtoIn(albumId, memoryId, dtoIn, Long.valueOf(requesterId));
        return ResponseEntity.ok(responseDto);
    }


    @GetMapping("/{albumId}/memories")
    ResponseEntity<Page<MemoryPreviewDtoOut>> getMemoriesOfAlbum(
            @PathVariable Long albumId,
            @RequestParam(required = false) Long uploaderId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize) {


        if (uploaderId != null) {
            Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumByUploaderPaginated(albumId, uploaderId, page, pageSize);
            return ResponseEntity.ok(pageOfMemories);
        }

        Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getMemoriesOfAlbumPaginated(albumId, page, pageSize);
        return ResponseEntity.ok(pageOfMemories);
    }

    @GetMapping("/{albumId}/highlighted-memories")
    ResponseEntity<Page<MemoryPreviewDtoOut>> getHighlightedMemories(
            @PathVariable Long albumId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize) {


        Page<MemoryPreviewDtoOut> pageOfMemories = memoryService.getHighlightedMemoriesOfAlbumPaginated(albumId, page, pageSize);
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




    @DeleteMapping("/{albumId}/contributors/{userId}")
    ResponseEntity<Void> patchUserAlbums(@PathVariable Long userId, @PathVariable Long albumId,
                                         @RequestHeader("X-USER-ID") String requesterId,
                                         @RequestHeader("X-USERNAME") String username) {
        albumService.removeUserFromAlbum(userId, albumId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{albumId}/memories/{memoryId}/likes")
    ResponseEntity<LikeDtoOut> createLike(@PathVariable Long albumId,
                                          @PathVariable Long memoryId,
                                          @RequestBody LikeDtoIn dtoIn) {
        LikeDtoOut likeDtoOut = likeService.createLike(albumId, memoryId, dtoIn);
        return ResponseEntity.ok(likeDtoOut);
    }

    @GetMapping("/{albumId}/memories/{memoryId}/likes")
    ResponseEntity<List<LikeDtoOut>> getAllLikesOfMemory(@PathVariable Long albumId,
                                                         @PathVariable Long memoryId
    ) {
        List<LikeDtoOut> likes = likeService.getAllLikesOfMemory(albumId, memoryId);
        return ResponseEntity.ok(likes);
    }


    @PostMapping("/{albumId}/memories/{memoryId}/comments")
    ResponseEntity<CommentDtoOut> createComment(@PathVariable Long albumId,
                                                @PathVariable Long memoryId,
                                                @RequestBody CommentDtoIn dtoIn) {
        CommentDtoOut commentDtoOut = commentService.createComment(albumId, memoryId, dtoIn);
        return ResponseEntity.ok(commentDtoOut);
    }

    @GetMapping("/{albumId}/memories/{memoryId}/comments")
    ResponseEntity<List<CommentDtoOut>> getAllCommentsOfMemory(@PathVariable Long albumId,
                                                               @PathVariable Long memoryId
    ) {
        List<CommentDtoOut> comments = commentService.getAllCommentsOfMemory(albumId, memoryId);
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

    @DeleteMapping("/{albumId}/memories/{memoryId}/likes/{likeId}")
    ResponseEntity<Void> deleteLikeById(@PathVariable Long albumId,
                                        @PathVariable Long memoryId,
                                        @PathVariable Long likeId,
                                        @RequestHeader("X-USER-ID") String requesterId,
                                        @RequestHeader("X-USERNAME") String username) {

        likeService.deleteLikeById(albumId, memoryId, likeId, Long.valueOf(requesterId));
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
    ResponseEntity<ErrorResponse> handleUnauthorizedRequestException(UnauthorizedRequestException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
    }

}
