package com.kharzixen.userservice.exception;

import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
public class DuplicateFieldException extends RuntimeException{
    Map<String, String> fields;
    public DuplicateFieldException(Map<String, String> fields){
        super(fields.toString());
        this.fields = fields;
    }
}
