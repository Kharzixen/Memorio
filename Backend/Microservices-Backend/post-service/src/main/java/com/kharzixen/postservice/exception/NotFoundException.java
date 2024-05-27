package com.kharzixen.postservice.exception;

abstract class NotFoundException extends RuntimeException{
    public NotFoundException(String message){
        super(message);
    }
}
