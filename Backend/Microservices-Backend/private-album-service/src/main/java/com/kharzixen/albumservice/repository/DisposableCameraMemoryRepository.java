package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.DisposableCamera;
import com.kharzixen.albumservice.model.DisposableCameraMemory;
import com.kharzixen.albumservice.projection.DisposableCameraMemoryProjection;
import com.kharzixen.albumservice.projection.MemoryProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface DisposableCameraMemoryRepository extends JpaRepository<DisposableCameraMemory, Long> {
    //to new repository for new model
    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageId as imageId, m.creationDate as creationDate FROM DisposableCameraMemory as m" +
            " where m.disposableCamera.album.id = :albumId and m.uploader.id = :uploaderId  ")
    Page<DisposableCameraMemoryProjection> findDisposableCameraMemoriesOfAlbumByUploaderPaginated(Long albumId, Long uploaderId, Pageable pageRequest);

    @Query(value = "SELECT m.id as id,  m.uploader as uploader," +
            " m.caption as caption, m.imageId as imageId, m.creationDate as creationDate FROM DisposableCameraMemory as m" +
            " where m.disposableCamera.album.id = :albumId ")
    Page<DisposableCameraMemoryProjection> findDisposableCameraMemoriesOfAlbumPaginated(Long albumId, Pageable pageRequest);
}
