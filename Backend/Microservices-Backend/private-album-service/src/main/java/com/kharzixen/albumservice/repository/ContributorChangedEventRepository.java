package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.ContributorChangedEventOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContributorChangedEventRepository extends JpaRepository<ContributorChangedEventOutbox, Long> { }
