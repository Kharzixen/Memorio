package com.kharzixen.postservice.repository;

import com.kharzixen.postservice.model.PostOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostOutboxRepository extends JpaRepository<PostOutbox, Long> {
}
