package com.kharzixen.postservice.repository;

import com.kharzixen.postservice.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    @Query("SELECT p FROM Post p WHERE p.owner.id = :userId")
    Page<Post> findPostsOfUserPaginated(Long userId, Pageable pageRequest);

    @Query("SELECT CASE WHEN COUNT(l) > 0 THEN true ELSE false END " +
            "FROM Like l WHERE l.post.id = :postId AND l.user.id = :userId")
    Boolean isPostLikedByUser(Long postId, Long userId);
}
