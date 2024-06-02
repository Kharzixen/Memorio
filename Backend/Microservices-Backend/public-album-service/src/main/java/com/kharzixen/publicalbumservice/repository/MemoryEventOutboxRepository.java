package com.kharzixen.publicalbumservice.repository;

import com.kharzixen.publicalbumservice.model.MemoryEventOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemoryEventOutboxRepository extends JpaRepository<MemoryEventOutbox, Long> {
}
