package com.kharzixen.userservice.exception;

public class DatabaseCommunicationException extends RuntimeException{
    public DatabaseCommunicationException(String msg){
        super("Database can't be reached: " + msg);
    }
}
