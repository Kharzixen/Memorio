package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.CommentDtoIn;
import com.kharzixen.albumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.albumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
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

@Service
@AllArgsConstructor
public class CommentService {

    private final AlbumRepository albumRepository;
    private final MemoryRepository memoryRepository;
    private final CommentRepository commentRepository;
    private final UserRepository userRepository;

    public CommentDtoOut createComment(Long albumId, Long memoryId, CommentDtoIn dtoIn) {

        try{
            Album album = albumRepository.findById(albumId)
                    .orElseThrow(() -> new NotFoundException("Album", albumId));
            Memory memory = memoryRepository.findById(memoryId)
                    .orElseThrow(() -> new NotFoundException("Memory", albumId));
            User user = userRepository.findById(dtoIn.getUserId())
                    .orElseThrow(() -> new NotFoundException("User", dtoIn.getUserId()));
            Comment comment = new Comment(null, user, memory, dtoIn.getMessage(), new Date());
            Comment saved = commentRepository.save(comment);
            return CommentMapper.INSTANCE.modelToDto(saved);
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

    public List<CommentDtoOut> getAllCommentsOfMemory(Long albumId, Long memoryId) {
        return commentRepository.findAllWhereMemoryId(memoryId).stream().map(CommentMapper.INSTANCE::modelToDto).toList();
    }

    public void deleteCommentById(Long albumId, Long memoryId, Long commentId) {
        commentRepository.deleteById(commentId);
    }
}
