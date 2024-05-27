package com.kharzixen.postservice.exception;

public class PostNotFoundException extends NotFoundException{
    public PostNotFoundException(Long postId){
        super("Post with id: " + postId + " not found.");
    }
}
