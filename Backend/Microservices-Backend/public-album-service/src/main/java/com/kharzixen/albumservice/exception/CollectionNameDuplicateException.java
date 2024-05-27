package com.kharzixen.albumservice.exception;

public class CollectionNameDuplicateException extends RuntimeException{
    public CollectionNameDuplicateException(String message){
        super(message);
    }
}
