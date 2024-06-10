package com.kharzixen.postservice.exception;

public class DuplicateUserException extends RuntimeException{
    public DuplicateUserException(Long id){
        super("User with id: " + id +" already included in database");
    }
}
