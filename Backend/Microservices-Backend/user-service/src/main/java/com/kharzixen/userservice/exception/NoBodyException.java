package com.kharzixen.userservice.exception;

public class NoBodyException extends RuntimeException{
    public NoBodyException(String method, String userId){
        super(method.toUpperCase() + " method error: no body in request provided. UserId: " + userId + ".");
    }
}
