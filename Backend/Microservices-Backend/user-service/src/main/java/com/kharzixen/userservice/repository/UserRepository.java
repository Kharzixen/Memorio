package com.kharzixen.userservice.repository;

import com.kharzixen.userservice.model.User;
import com.kharzixen.userservice.projection.SimpleUserProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);

    @Query(value = "SELECT u.followers FROM User u WHERE u.id = :userId")
    Page<SimpleUserProjection> findFollowersOfUserByIdPaginated(Long userId, Pageable pageRequest);

    @Query(value = "SELECT u.following FROM User u WHERE u.id = :userId")
    Page<SimpleUserProjection> findFollowingOfUserByIdPaginated(Long userId, Pageable pageRequest);

    @Query(value = "SELECT count(uf.follower_id) " +
            "FROM user_followers as uf " +
            "WHERE uf.user_id = :userId",
            nativeQuery = true)
    Long getFollowersCount(@Param("userId") Long userId);

    @Query(value = "SELECT count(uf.user_id) FROM user_followers as uf WHERE uf.follower_id = :userId",
            nativeQuery = true)
    Long getFollowingCount(@Param("userId") Long userId);

}
