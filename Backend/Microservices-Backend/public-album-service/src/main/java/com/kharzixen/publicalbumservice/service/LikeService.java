package com.kharzixen.publicalbumservice.service;


import com.kharzixen.publicalbumservice.dto.incomming.LikeDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.publicalbumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.publicalbumservice.exception.NotFoundException;
import com.kharzixen.publicalbumservice.exception.UnauthorizedRequestException;
import com.kharzixen.publicalbumservice.mapper.LikeMapper;
import com.kharzixen.publicalbumservice.model.Album;
import com.kharzixen.publicalbumservice.model.Like;
import com.kharzixen.publicalbumservice.model.Memory;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.repository.AlbumRepository;
import com.kharzixen.publicalbumservice.repository.LikeRepository;
import com.kharzixen.publicalbumservice.repository.MemoryRepository;
import com.kharzixen.publicalbumservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
@Slf4j
public class LikeService {

    private final AlbumRepository albumRepository;
    private final MemoryRepository memoryRepository;
    private final LikeRepository likeRepository;
    private final UserRepository userRepository;

    public LikeDtoOut createLike(Long albumId, Long memoryId, LikeDtoIn dtoIn) {

        try{
            Album album = albumRepository.findById(albumId)
                    .orElseThrow(() -> new NotFoundException("Album", albumId));
            Memory memory = memoryRepository.findById(memoryId)
                    .orElseThrow(() -> new NotFoundException("Memory", albumId));
            User user = userRepository.findById(dtoIn.getUserId())
                    .orElseThrow(() -> new NotFoundException("User", dtoIn.getUserId()));
            Like like = new Like(null, user, memory, new Date());
            Like saved = likeRepository.save(like);
            return LikeMapper.INSTANCE.modelToDto(saved);
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

    public List<LikeDtoOut> getAllLikesOfMemory(Long albumId, Long memoryId) {
        return likeRepository.findAllWhereMemoryId(memoryId).stream().map(LikeMapper.INSTANCE::modelToDto).toList();
    }

    public void deleteLikeById(Long albumId, Long memoryId, Long likeId, Long requesterId) {
        Like like = likeRepository.findById(likeId).orElseThrow(() -> new NotFoundException("Like", likeId));
        if(Objects.equals(like.getUser().getId(), requesterId)){
            likeRepository.deleteById(likeId);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }
}
