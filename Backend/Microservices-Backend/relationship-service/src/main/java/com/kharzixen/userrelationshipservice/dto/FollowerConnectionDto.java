package com.kharzixen.userrelationshipservice.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class FollowerConnectionDto {
    @NotNull
    private String userId;
    @NotNull
    private String followerId;
}
