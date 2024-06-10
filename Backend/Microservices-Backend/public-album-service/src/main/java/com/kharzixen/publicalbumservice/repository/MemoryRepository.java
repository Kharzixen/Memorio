package com.kharzixen.publicalbumservice.repository;

import com.kharzixen.publicalbumservice.model.Memory;
import com.kharzixen.publicalbumservice.projection.MemoryProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

//TODO: refactor this repository, reuse the Pageable queries for previews
@Repository
public interface MemoryRepository extends JpaRepository<Memory, Long> {

    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageId as imageId, m.creationDate as creationDate FROM Memory as m " +
            "where m.album.id = :albumId  ")
    Page<MemoryProjection> findMemoriesOfAlbumPaginated(Long albumId, Pageable pageRequest);


    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageId as imageId, m.creationDate as creationDate FROM Memory as m " +
            "where m.album.id = :albumId and m.uploader.id = :uploaderId ")
    Page<MemoryProjection> findMemoriesOfAlbumByUploaderPaginated(Long albumId, Long uploaderId, Pageable pageRequest);


    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageId as imageId, m.creationDate as creationDate FROM Memory as m " +
            "where m.album.id = :albumId and m.isHighlighted = true  ")
    Page<MemoryProjection> findHighlightedMemoriesOfAlbumPaginated(Long albumId, Pageable pageRequest);
}
