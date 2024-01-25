package com.kharzixen.userrelationshipservice.repository;


import com.kharzixen.userrelationshipservice.model.User;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends Neo4jRepository<User, String> {


    Optional<User> findByUserId(@Param("userId") String userId);

}
