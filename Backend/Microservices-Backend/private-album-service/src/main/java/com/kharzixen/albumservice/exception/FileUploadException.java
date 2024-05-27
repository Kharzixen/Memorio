package com.kharzixen.albumservice.exception;

public class FileUploadException extends RuntimeException{
    public FileUploadException(String message){
        super("Error uploading a file: " + message);
    }
}
