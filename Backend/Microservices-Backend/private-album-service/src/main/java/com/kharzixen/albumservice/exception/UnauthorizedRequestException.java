package com.kharzixen.albumservice.exception;

public class UnauthorizedRequestException extends RuntimeException {
    public UnauthorizedRequestException(String message){
        super(message);
    }
}
