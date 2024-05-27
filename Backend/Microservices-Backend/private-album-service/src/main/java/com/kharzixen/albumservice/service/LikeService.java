package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.LikeDtoIn;
import com.kharzixen.albumservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.albumservice.exception.CollectionNameDuplicateException;
import com.kharzixen.albumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.mapper.LikeMapper;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.Like;
import com.kharzixen.albumservice.model.Memory;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.LikeRepository;
import com.kharzixen.albumservice.repository.MemoryRepository;
import com.kharzixen.albumservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

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

    public void deleteLikeById(Long albumId, Long memoryId, Long likeId) {
        likeRepository.deleteById(likeId);
    }
}
