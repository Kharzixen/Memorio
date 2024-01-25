package com.kharzixen.userservice.repository;

import com.kharzixen.userservice.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String>{
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);


}
