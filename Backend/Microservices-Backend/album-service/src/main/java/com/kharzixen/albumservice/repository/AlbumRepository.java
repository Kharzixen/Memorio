package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.projection.AlbumPreviewProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AlbumRepository extends JpaRepository<Album, Long>, PagingAndSortingRepository<Album, Long> {

    @Query(value = "SELECT a.id as id, a.albumName as albumName, a.caption as caption , " +
            "a.albumImageLink as albumImageLink, a.owner as owner " +
            "FROM Album as a " +
            "JOIN a.contributors c on c.id = :userId")
    Page<AlbumPreviewProjection> findAllWhereUserIsContributor(@Param("userId") Long userId, Pageable pageable);

    @Query("SELECT COUNT(a) > 0 FROM Album a JOIN a.contributors c WHERE a.id = :albumId AND c.id = :userId")
    boolean isUserContributorOfAlbum(Long userId, Long albumId);
}


