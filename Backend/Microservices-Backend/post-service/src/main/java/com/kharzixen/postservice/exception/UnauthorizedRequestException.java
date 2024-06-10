package com.kharzixen.postservice.exception;

public class UnauthorizedRequestException extends RuntimeException{
    public UnauthorizedRequestException(String message){
        super(message);
    }
}
