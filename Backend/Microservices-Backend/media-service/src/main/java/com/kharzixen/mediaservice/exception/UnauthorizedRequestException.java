package com.kharzixen.mediaservice.exception;

public class UnauthorizedRequestException extends RuntimeException{
    public UnauthorizedRequestException(String message){
        super(message);
    }
}
