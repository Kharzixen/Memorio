package com.kharzixen.userservice.exception;

public class UnauthorizedRequestException extends RuntimeException{
    public UnauthorizedRequestException(String message){
        super(message);
    }
}
