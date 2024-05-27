package com.kharzixen.albumservice.exception;

public class NotFoundException extends RuntimeException{
    public NotFoundException(String entityType, Long id){
        super("Entity type: " + entityType + " with id: " + id + " not found.");
    }
}
