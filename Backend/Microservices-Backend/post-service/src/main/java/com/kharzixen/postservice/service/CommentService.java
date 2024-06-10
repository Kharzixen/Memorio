package com.kharzixen.postservice.service;

import com.kharzixen.postservice.dto.incomming.CommentDtoIn;
import com.kharzixen.postservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.postservice.exception.PostLikeDuplicateException;
import com.kharzixen.postservice.exception.PostNotFoundException;
import com.kharzixen.postservice.exception.UnauthorizedRequestException;
import com.kharzixen.postservice.exception.UserNotFoundException;
import com.kharzixen.postservice.mapper.CommentMapper;
import com.kharzixen.postservice.model.Comment;
import com.kharzixen.postservice.model.Post;
import com.kharzixen.postservice.model.User;
import com.kharzixen.postservice.repository.CommentRepository;
import com.kharzixen.postservice.repository.PostRepository;
import com.kharzixen.postservice.repository.UserRepository;
import jakarta.ws.rs.NotFoundException;
import lombok.AllArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class CommentService {

    private final UserRepository userRepository;
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;

    public CommentDtoOut createNewComment(Long postId, CommentDtoIn commentDtoIn, Long requestId) {
        try {
            Post post = postRepository.findById(postId)
                    .orElseThrow(() -> new PostNotFoundException(postId));
            User user = userRepository.findById(requestId)
                    .orElseThrow(() -> new UserNotFoundException(requestId));
            Comment comment = new Comment(null, user, post, commentDtoIn.getMessage(), new Date());
            Comment saved = commentRepository.save(comment);
            return CommentMapper.INSTANCE.modelToDto(saved);
        } catch (DataIntegrityViolationException ex) {

            if (ex.getMessage().contains("Duplicate entry")) {
                throw new PostLikeDuplicateException("User: " + commentDtoIn.getUserId() +
                        " already liked this memory: " + commentDtoIn.getPostId());
            }
            throw new RuntimeException(ex.getMessage());
        }
    }

    public List<CommentDtoOut> getCommentsOfAPost(Long postId) {
        List<Comment> comments = commentRepository.findAllWherePostId(postId);
        return comments.stream().map(CommentMapper.INSTANCE::modelToDto).toList();
    }

    public void deleteComment(Long postId, Long commentId, Long requesterId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("Comment not found"));
        if (Objects.equals(comment.getOwner().getId(), requesterId)) {
            commentRepository.deleteById(commentId);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }
}
