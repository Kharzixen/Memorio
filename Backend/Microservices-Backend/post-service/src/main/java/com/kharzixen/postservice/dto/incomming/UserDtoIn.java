package com.kharzixen.postservice.dto.incomming;

import lombok.Data;

@Data
public class UserDtoIn {
    private Long id;
    private String username;
    private String pfpId;
}
