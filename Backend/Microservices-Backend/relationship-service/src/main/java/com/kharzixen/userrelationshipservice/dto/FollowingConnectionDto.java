package com.kharzixen.userrelationshipservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FollowingConnectionDto {
    private String userId;
    private String followingId;
}
