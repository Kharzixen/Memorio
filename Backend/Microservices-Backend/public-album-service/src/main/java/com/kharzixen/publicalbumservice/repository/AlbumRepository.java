package com.kharzixen.publicalbumservice.repository;

import com.kharzixen.publicalbumservice.model.Album;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.projection.AlbumPreviewProjection;
import com.kharzixen.publicalbumservice.projection.UserProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlbumRepository extends JpaRepository<Album, Long>, PagingAndSortingRepository<Album, Long> {

    @Query(value = "SELECT a.id as id, a.albumName as albumName, a.caption as caption , " +
            "a.albumImageLink as albumImageLink, a.owner as owner " +
            "FROM Album as a " +
            "JOIN a.contributors c on c.id = :userId")
    Page<AlbumPreviewProjection> findAllWhereUserIsContributor(@Param("userId") Long userId, Pageable pageable);

    @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END " +
            "FROM Album a JOIN a.contributors c  " +
            "WHERE a.id = :albumId AND c.id = :userId")
    boolean isUserContributorOfAlbum(Long userId, Long albumId);

    @Query("SELECT a.contributors FROM Album a WHERE a.id = :albumId")
    Page<UserProjection> getContributorsOfAlbumByIdPaginated(Long albumId, Pageable pageable);

    @Query("SELECT DISTINCT u FROM User u JOIN u.albums a WHERE a.id = :albumId")
    List<User> findAllContributorsOfAlbum(Long albumId);
}


