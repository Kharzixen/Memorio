package com.kharzixen.postservice.repository;

import com.kharzixen.postservice.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
