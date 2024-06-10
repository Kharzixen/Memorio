package com.kharzixen.postservice.controller;

import com.kharzixen.postservice.dto.incomming.CommentDtoIn;
import com.kharzixen.postservice.dto.incomming.LikeDtoIn;
import com.kharzixen.postservice.dto.incomming.PostDtoIn;
import com.kharzixen.postservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.postservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.postservice.dto.outgoing.PostDtoOut;
import com.kharzixen.postservice.error.ErrorMessage;
import com.kharzixen.postservice.exception.PostLikeDuplicateException;
import com.kharzixen.postservice.exception.PostNotFoundException;
import com.kharzixen.postservice.exception.UserNotFoundException;
import com.kharzixen.postservice.service.CommentService;
import com.kharzixen.postservice.service.LikeService;
import com.kharzixen.postservice.service.PostService;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/posts")
public class PostController {
    private final PostService postService;
    private final LikeService likeService;
    private final CommentService commentService;

    @GetMapping("/{postId}")
    ResponseEntity<PostDtoOut> getPostById(@PathVariable("postId") Long postId,
                                           @RequestHeader("X-USER-ID") String requesterId,
                                           @RequestHeader("X-USERNAME") String username) {
        PostDtoOut postDtoOut = postService.getPostById(postId, Long.valueOf(requesterId));
        return ResponseEntity.ok(postDtoOut);
    }

    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<PostDtoOut> createPost(@ModelAttribute PostDtoIn postDtoIn,
                                          @RequestHeader("X-USER-ID") String requesterId,
                                          @RequestHeader("X-USERNAME") String username) {
        PostDtoOut responseDto = postService.createPost(postDtoIn, Long.valueOf(requesterId));
        return new ResponseEntity<>(responseDto, HttpStatus.CREATED);
    }

    @DeleteMapping("/{postId}")
    ResponseEntity<Void> deletePostById(@PathVariable("postId") Long postId,
                                        @RequestHeader("X-USER-ID") String requesterId,
                                        @RequestHeader("X-USERNAME") String username) {
        postService.deletePostById(postId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{postId}/likes")
    ResponseEntity<LikeDtoOut> createLikeOnThePost(@PathVariable("postId") Long postId,
                                                   @RequestBody LikeDtoIn likeDtoIn,
                                                   @RequestHeader("X-USER-ID") String requesterId,
                                                   @RequestHeader("X-USERNAME") String username) {
        LikeDtoOut likeDtoOut = likeService.createNewLike(postId, likeDtoIn, Long.valueOf(requesterId));
        return ResponseEntity.ok(likeDtoOut);
    }

    @GetMapping("/{postId}/likes")
    ResponseEntity<List<LikeDtoOut>> getLikesOfAPost(@PathVariable("postId") Long postId) {
        List<LikeDtoOut> likeDtoOut = likeService.getLikesOfAPost(postId);
        return ResponseEntity.ok(likeDtoOut);
    }

    @DeleteMapping("/{postId}/likes")
    ResponseEntity<Void> getLikesOfAPost(@PathVariable("postId") Long postId,
                                         @RequestParam("userId") String userId,
                                         @RequestHeader("X-USER-ID") String requesterId,
                                         @RequestHeader("X-USERNAME") String username) {
        likeService.deleteLike(postId, userId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{postId}/comments")
    ResponseEntity<CommentDtoOut> createCommentOnPost(@PathVariable("postId") Long postId,
                                                      @RequestBody CommentDtoIn commentDtoIn,
                                                      @RequestHeader("X-USER-ID") String requesterId,
                                                      @RequestHeader("X-USERNAME") String username) {
        CommentDtoOut commentDtoOut = commentService.createNewComment(postId, commentDtoIn, Long.valueOf(requesterId));
        return ResponseEntity.ok(commentDtoOut);
    }

    @GetMapping("/{postId}/comments")
    ResponseEntity<List<CommentDtoOut>> getCommentsOfAPost(@PathVariable("postId") Long postId) {
        List<CommentDtoOut> commentDtoOuts = commentService.getCommentsOfAPost(postId);
        return ResponseEntity.ok(commentDtoOuts);
    }

    @DeleteMapping("/{postId}/comments/{commentId}")
    ResponseEntity<Void> deleteCommentOfAPost(@PathVariable Long postId,
                                              @PathVariable Long commentId,
                                              @RequestHeader("X-USER-ID") String requesterId,
                                              @RequestHeader("X-USERNAME") String username) {
        commentService.deleteComment(postId, commentId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    //--------------------------------------------------------------------------------------------------------

    @ExceptionHandler(PostNotFoundException.class)
    ResponseEntity<ErrorMessage> handlePostNotFoundException(@NotNull PostNotFoundException ex) {
        ErrorMessage errorMessage = new ErrorMessage(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(errorMessage, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(UserNotFoundException.class)
    ResponseEntity<ErrorMessage> handleUserNotFoundException(UserNotFoundException ex) {
        ErrorMessage errorMessage = new ErrorMessage(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(errorMessage, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(PostLikeDuplicateException.class)
    ResponseEntity<ErrorMessage> handlePostLikeDuplicateException(PostLikeDuplicateException ex) {
        ErrorMessage errorMessage = new ErrorMessage(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return new ResponseEntity<>(errorMessage, HttpStatus.BAD_REQUEST);
    }
}
