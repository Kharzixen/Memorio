package com.kharzixen.userrelationshipservice.exception;

public class EntityNotFoundException extends RuntimeException {
    public EntityNotFoundException(String userId){
        super("User with id: " + userId + " not found!");
    }
}
