package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.projection.AlbumPreviewProjection;
import com.kharzixen.albumservice.projection.UserProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {

    @Query("SELECT a.contributors FROM Album a WHERE a.id = :albumId")
    Page<UserProjection> getContributorsOfAlbumByIdPaginated(Long albumId, Pageable pageable);
}
