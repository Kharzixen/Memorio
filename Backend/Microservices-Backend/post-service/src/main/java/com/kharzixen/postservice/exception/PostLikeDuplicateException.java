package com.kharzixen.postservice.exception;

public class PostLikeDuplicateException extends RuntimeException{
    public PostLikeDuplicateException(String message){
        super(message);
    }
}
