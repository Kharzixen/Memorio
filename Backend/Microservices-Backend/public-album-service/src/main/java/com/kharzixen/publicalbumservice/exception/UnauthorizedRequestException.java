package com.kharzixen.publicalbumservice.exception;


public class UnauthorizedRequestException extends RuntimeException {
    public UnauthorizedRequestException(String message){
        super(message);
    }
}
