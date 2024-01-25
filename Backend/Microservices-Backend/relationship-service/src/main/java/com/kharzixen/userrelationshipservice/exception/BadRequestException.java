package com.kharzixen.userrelationshipservice.exception;

public class BadRequestException extends RuntimeException{
    public BadRequestException(String cause){
        super(cause);
    }
}
