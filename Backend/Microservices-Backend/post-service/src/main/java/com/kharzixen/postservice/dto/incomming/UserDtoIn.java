package com.kharzixen.postservice.dto.incomming;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserDtoIn {
    private Long id;
    private String username;
    private Boolean isAdmin;
    private Boolean isActive;
}
