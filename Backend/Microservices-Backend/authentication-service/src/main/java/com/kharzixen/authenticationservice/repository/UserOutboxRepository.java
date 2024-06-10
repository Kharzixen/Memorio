package com.kharzixen.authenticationservice.repository;

import com.kharzixen.authenticationservice.model.UserOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserOutboxRepository extends JpaRepository<UserOutbox, Long> {
}
