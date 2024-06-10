package com.kharzixen.publicalbumservice.service;


import com.kharzixen.publicalbumservice.dto.incomming.CommentDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.CommentDtoOut;
import com.kharzixen.publicalbumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.publicalbumservice.exception.NotFoundException;
import com.kharzixen.publicalbumservice.exception.UnauthorizedRequestException;
import com.kharzixen.publicalbumservice.mapper.CommentMapper;
import com.kharzixen.publicalbumservice.model.Album;
import com.kharzixen.publicalbumservice.model.Comment;
import com.kharzixen.publicalbumservice.model.Memory;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.repository.AlbumRepository;
import com.kharzixen.publicalbumservice.repository.CommentRepository;
import com.kharzixen.publicalbumservice.repository.MemoryRepository;
import com.kharzixen.publicalbumservice.repository.UserRepository;
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

    public void deleteCommentById(Long albumId, Long memoryId, Long commentId, Long requesterId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new NotFoundException("Comment", commentId));
        if(Objects.equals(comment.getOwner().getId(), requesterId)){
            commentRepository.deleteById(commentId);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }
}
