package com.kharzixen.postservice.repository;

import com.kharzixen.postservice.model.Like;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LikeRepository extends JpaRepository<Like, Long> {
    @Query("SELECT l FROM Like l WHERE l.post.id = :postId")
    List<Like> findAllWherePostId(Long postId);

    @Modifying
    @Query("DELETE FROM Like l WHERE l.post.id = :postId AND l.user.id = :userId")
    void deleteLikeOfPost(Long postId, String userId);

}
