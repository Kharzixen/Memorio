package com.kharzixen.postservice.service;

import com.kharzixen.postservice.dto.incomming.LikeDtoIn;
import com.kharzixen.postservice.dto.outgoing.LikeDtoOut;
import com.kharzixen.postservice.exception.PostLikeDuplicateException;
import com.kharzixen.postservice.exception.PostNotFoundException;
import com.kharzixen.postservice.exception.UserNotFoundException;
import com.kharzixen.postservice.mapper.LikeMapper;
import com.kharzixen.postservice.model.Like;
import com.kharzixen.postservice.model.Post;
import com.kharzixen.postservice.model.User;
import com.kharzixen.postservice.repository.LikeRepository;
import com.kharzixen.postservice.repository.PostRepository;
import com.kharzixen.postservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@AllArgsConstructor
public class LikeService {

    private final LikeRepository likeRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Transactional
    public LikeDtoOut createNewLike(Long postId, LikeDtoIn likeDtoIn, Long requesterId) {
        try{
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException(postId));
        User user = userRepository.findById(requesterId)
                .orElseThrow(() -> new UserNotFoundException(requesterId));
        Like like = new Like(null, user, post, new Date());
        Like saved = likeRepository.save(like);
        return LikeMapper.INSTANCE.modelToDto(saved);
    }catch (DataIntegrityViolationException ex) {

            if (ex.getMessage().contains("Duplicate entry")) {
                throw new PostLikeDuplicateException("User: " + likeDtoIn.getUserId() +
                        " already liked this memory: " + likeDtoIn.getPostId());
            }
            throw new RuntimeException(ex.getMessage());
        }

    }

    public List<LikeDtoOut> getLikesOfAPost(Long postId) {
        List<Like> likes = likeRepository.findAllWherePostId(postId);
        return likes.stream().map(LikeMapper.INSTANCE::modelToDto).toList();
    }

    @Transactional
    public void deleteLike(Long postId, String userId, Long requesterId) {
        likeRepository.deleteLikeOfPost(postId, String.valueOf(requesterId));

    }
}
