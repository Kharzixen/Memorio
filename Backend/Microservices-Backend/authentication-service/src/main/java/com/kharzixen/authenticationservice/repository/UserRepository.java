package com.kharzixen.authenticationservice.repository;

import com.kharzixen.authenticationservice.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    @Query("SELECT u FROM User u")
    Page<User> findUsersOfPage(Pageable pageRequest);

    @Query("SELECT COUNT(u) FROM User u")
    long getUsersCount();
}
