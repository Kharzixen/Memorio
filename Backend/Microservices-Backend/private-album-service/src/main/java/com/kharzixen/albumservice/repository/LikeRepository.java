package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.Like;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LikeRepository extends JpaRepository<Like, Long> {
    @Query("SELECT l FROM Like l WHERE l.memory.id = :memoryId")
    List<Like> findAllWhereMemoryId(Long memoryId);
}
