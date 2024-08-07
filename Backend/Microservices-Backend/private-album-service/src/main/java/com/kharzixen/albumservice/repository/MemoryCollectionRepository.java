package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.MemoryCollection;
import com.kharzixen.albumservice.projection.MemoryCollectionPreviewProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MemoryCollectionRepository extends JpaRepository<MemoryCollection, Long> {


    @Query(value = "SELECT c.id as id,  c.collectionName as collectionName," +
            " c.creationDate as creationDate, c.creator as creator, c.album as album, c.collectionDescription as collectionDescription " +
            "FROM MemoryCollection as c JOIN c.album as a on a.id = :albumId")
    Page<MemoryCollectionPreviewProjection> findAllCollectionsOfAlbumPaginated(@Param("albumId") Long albumId, Pageable pageable);

}
