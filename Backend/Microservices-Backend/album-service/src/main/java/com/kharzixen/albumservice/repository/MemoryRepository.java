package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.Memory;
import com.kharzixen.albumservice.projection.MemoryProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

//TODO: refactor this repository, reuse the Pageable queries for previews
@Repository
public interface MemoryRepository extends JpaRepository<Memory, Long> {

    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageLink as imageLink, m.creationDate as creationDate FROM Memory as m where m.album.id = :albumId")
    Page<MemoryProjection> findMemoriesOfAlbumPaginated(Long albumId, Pageable pageRequest);

    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageLink as imageLink, m.creationDate as creationDate FROM Memory as m " +
            "join m.collections as c where c.id=:collectionId")
    Page<MemoryProjection> findMemoriesOfCollectionPaginated(Long collectionId, Pageable pageRequest);


    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageLink as imageLink, m.creationDate as creationDate FROM Memory as m where m.album.id = :albumId and m.uploader.id = :uploaderId")
    Page<MemoryProjection> findMemoriesOfAlbumByUploaderPaginated(Long albumId, Long uploaderId, Pageable pageRequest);

    @Query(value = "SELECT m.id as id,  m.uploader as uploader, " +
            "m.caption as caption, m.imageLink as imageLink, m.creationDate as creationDate " +
            "from Memory as m where m.album.id = :albumId and m.uploader.id = :uploaderId and " +
            " not exists (SELECT 1 FROM m.collections c WHERE c.id = :collectionId)")
    Page<MemoryProjection> findMemoriesOfAlbumByUploaderWhichNotIncludedInCollectionPaginated(Long albumId, Long collectionId, Long uploaderId, Pageable pageRequest);
}
