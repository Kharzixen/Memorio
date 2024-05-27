package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.DisposableCamera;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DisposableCameraRepository  extends JpaRepository<DisposableCamera, Long> {
}
