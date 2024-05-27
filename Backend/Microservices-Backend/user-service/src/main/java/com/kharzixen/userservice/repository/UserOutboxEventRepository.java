package com.kharzixen.userservice.repository;

import com.kharzixen.userservice.model.UserEventOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserOutboxEventRepository extends JpaRepository<UserEventOutbox, Long> {
}
