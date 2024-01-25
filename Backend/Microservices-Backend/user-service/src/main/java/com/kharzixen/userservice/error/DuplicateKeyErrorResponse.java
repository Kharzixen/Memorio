package com.kharzixen.userservice.error;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DuplicateKeyErrorResponse {
    private int status;
    private Map<String, String> fields;
    private String message;
}
