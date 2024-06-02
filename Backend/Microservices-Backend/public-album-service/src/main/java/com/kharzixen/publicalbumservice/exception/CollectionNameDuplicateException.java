package com.kharzixen.publicalbumservice.exception;

public class CollectionNameDuplicateException extends RuntimeException{
    public CollectionNameDuplicateException(String message){
        super(message);
    }
}
