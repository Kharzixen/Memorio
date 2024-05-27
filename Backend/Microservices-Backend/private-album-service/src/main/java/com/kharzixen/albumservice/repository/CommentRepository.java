package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.Comment;
import com.kharzixen.albumservice.model.Like;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    @Query("SELECT c FROM Comment c WHERE c.memory.id = :memoryId ORDER BY c.dateWhenMade DESC")
    List<Comment> findAllWhereMemoryId(Long memoryId);
}
