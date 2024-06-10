package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.LikeDtoIn;
import com.kharzixen.albumservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.albumservice.exception.MemoryLikeDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
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
import org.springframework.transaction.annotation.Transactional;

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

    public LikeDtoOut createLike(Long albumId, Long memoryId, LikeDtoIn dtoIn, Long requesterId) {

        try{
           if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
               Album album = albumRepository.findById(albumId)
                       .orElseThrow(() -> new NotFoundException("Album", albumId));
               Memory memory = memoryRepository.findById(memoryId)
                       .orElseThrow(() -> new NotFoundException("Memory", albumId));
               User user = userRepository.findById(requesterId)
                       .orElseThrow(() -> new NotFoundException("User", requesterId));
               Like like = new Like(null, user, memory, new Date());
               Like saved = likeRepository.save(like);
               return LikeMapper.INSTANCE.modelToDto(saved);
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

    public List<LikeDtoOut> getAllLikesOfMemory(Long albumId, Long memoryId, Long requesterId) {
        if(albumRepository.isUserContributorOfAlbum(requesterId, albumId)){
            return likeRepository.findAllWhereMemoryId(memoryId).stream().map(LikeMapper.INSTANCE::modelToDto).toList();
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }

    @Transactional
    public void deleteLikeById(Long albumId, Long memoryId, Long userId, Long requesterId) {
        if(Objects.equals(userId, requesterId)) {
            likeRepository.deleteLikeOfMemory(memoryId, requesterId);
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
    }
}
