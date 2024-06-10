package com.kharzixen.mediaservice.repository;

import com.kharzixen.mediaservice.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.albums WHERE u.userId = :userId")
    Optional<User> findUserWithAlbums(@Param("userId") Long userId);

    @Query("SELECT u FROM User u WHERE u.username = :username")
     Optional<User> findByUsername(String username);
}
