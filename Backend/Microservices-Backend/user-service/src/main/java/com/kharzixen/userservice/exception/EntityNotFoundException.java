package com.kharzixen.userservice.exception;

import org.springframework.util.StringUtils;

public class EntityNotFoundException extends RuntimeException{
    public EntityNotFoundException(String entity, String identifierType, String identifierValue, String methodType){
        super(methodType.toUpperCase() + " method error: " + StringUtils.capitalize(entity) + " with " + identifierType
                + ": " + identifierValue + " not found.");
    }
}
