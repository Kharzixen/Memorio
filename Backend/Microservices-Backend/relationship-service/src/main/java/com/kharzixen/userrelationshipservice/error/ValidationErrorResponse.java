package com.kharzixen.userrelationshipservice.error;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ValidationErrorResponse {
    private int status;
    private String message;
    private Map<String,String> errors;
}
