package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.MemoryEventOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemoryEventOutboxRepository extends JpaRepository<MemoryEventOutbox, Long> {
}
