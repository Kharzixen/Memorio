package com.kharzixen.postservice.service;

import com.kharzixen.postservice.dto.ImageCreatedResponseDto;
import com.kharzixen.postservice.dto.incomming.PostDtoIn;
import com.kharzixen.postservice.dto.incomming.UserDtoIn;
import com.kharzixen.postservice.dto.outgoing.PostDtoOut;
import com.kharzixen.postservice.exception.PostNotFoundException;
import com.kharzixen.postservice.exception.UserNotFoundException;
import com.kharzixen.postservice.mapper.PostMapper;
import com.kharzixen.postservice.model.Post;
import com.kharzixen.postservice.model.User;
import com.kharzixen.postservice.repository.PostRepository;
import com.kharzixen.postservice.repository.UserRepository;
import com.kharzixen.postservice.webclient.ImageServiceClient;
import jakarta.ws.rs.NotFoundException;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
@AllArgsConstructor
public class PostService {
    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final ImageServiceClient imageServiceClient;

    public PostDtoOut getPostById(Long postId, Long requesterId) throws PostNotFoundException {
        Post post = postRepository.findById(postId).orElseThrow(() -> new PostNotFoundException(postId));
        PostDtoOut postDtoOut = PostMapper.INSTANCE.modelToDto(post);
        postDtoOut.setIsLikedByRequester(postRepository.isPostLikedByUser(postId, requesterId));
        return postDtoOut;
    }

    public PostDtoOut createPost(PostDtoIn postDtoIn) {
        User owner = userRepository.findById(postDtoIn.getUploaderId())
                .orElseThrow(() -> new UserNotFoundException(postDtoIn.getUploaderId()));

        ImageCreatedResponseDto imageResponseDto = imageServiceClient
                .postImageToMediaService(postDtoIn.getImage(), postDtoIn.getUploaderId());
        Post post = Post.builder()
                .caption(postDtoIn.getCaption())
                .creationDate(new Date())
                .owner(owner)
                .imageId(imageResponseDto.getImageId())
                .build();
        Post saved = postRepository.save(post);
        return PostMapper.INSTANCE.modelToDto(saved);
    }

    public Page<PostDtoOut> getPostsOfUser(Long userId, int page, int pageSize) {
        User owner = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(userId));
        Sort sort = Sort.by(Sort.Direction.DESC, "creationDate");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);

        Page<Post> posts = postRepository.findPostsOfUserPaginated(owner.getId(), pageRequest);
        return new PageImpl<>(posts.getContent().stream().map(PostMapper.INSTANCE::modelToDto).toList(),
                pageRequest,
                posts.getTotalElements());
    }

    public void deletePostById(Long postId) {
        // add outbox delete for media service
        Post post = postRepository.findById(postId).orElseThrow(() -> new PostNotFoundException(postId));
        postRepository.delete(post);
    }
}
