package com.kharzixen.mediaservice.repository;

import com.kharzixen.mediaservice.model.Album;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AlbumRepository extends JpaRepository<Album, Long> {
    @Query("SELECT a FROM Album a JOIN FETCH a.contributors WHERE a.id = :albumId")
    Optional<Album> findAlbumWithContributors(@Param("albumId") Long albumId);
}
