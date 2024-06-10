package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.CommentDtoIn;
import com.kharzixen.albumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.albumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
import com.kharzixen.albumservice.mapper.CommentMapper;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.Comment;
import com.kharzixen.albumservice.model.Memory;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.repository.*;
import lombok.AllArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class CommentService {

    private final AlbumRepository albumRepository;
    private final MemoryRepository memoryRepository;
    private final CommentRepository commentRepository;
    private final UserRepository userRepository;

    public CommentDtoOut createComment(Long albumId, Long memoryId, CommentDtoIn dtoIn, Long requesterId) {

        try{
            if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
                Album album = albumRepository.findById(albumId)
                        .orElseThrow(() -> new NotFoundException("Album", albumId));
                Memory memory = memoryRepository.findById(memoryId)
                        .orElseThrow(() -> new NotFoundException("Memory", albumId));
                User user = userRepository.findById(requesterId)
                        .orElseThrow(() -> new NotFoundException("User",requesterId));
                Comment comment = new Comment(null, user, memory, dtoIn.getMessage(), new Date());
                Comment saved = commentRepository.save(comment);
                return CommentMapper.INSTANCE.modelToDto(saved);
            } else {
                throw new UnauthorizedRequestException("Unauthorized");
            }
        } catch (DataIntegrityViolationException ex) {

            if (ex.getMessage().contains("Duplicate entry")) {
                throw new MemoryLikeDuplicateException("User: " + dtoIn.getUserId() +
                        " already liked this memory: " + dtoIn.getMemoryId());
            }
            if (ex.getMessage().contains("album")) {
                throw new NotFoundException("Album", albumId);
            }
            if (ex.getMessage().contains("user")) {
                throw new NotFoundException("User", dtoIn.getUserId());
            }

            throw new RuntimeException(ex.getMessage());

        }
    }

    public List<CommentDtoOut> getAllCommentsOfMemory(Long albumId, Long memoryId, Long requesterId) {
        if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
            return commentRepository.findAllWhereMemoryId(memoryId).stream().map(CommentMapper.INSTANCE::modelToDto).toList();
        } else {
            throw  new UnauthorizedRequestException("Unauthorized");
        }
    }

    public void deleteCommentById(Long albumId, Long memoryId, Long commentId, Long requesterId) {

        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new NotFoundException("Comment", commentId));
        if(Objects.equals(comment.getOwner().getId(), requesterId)
                || Objects.equals(comment.getMemory().getUploader().getId(), requesterId)){
            commentRepository.deleteById(commentId);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }
}
