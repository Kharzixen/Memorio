package com.kharzixen.postservice.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserEvent {
    @JsonProperty
    private Long id;

    @JsonProperty("method")
    private String method;

    @JsonProperty("user_id")
    private Long userId;

    @JsonProperty
    private String username;

    @JsonProperty("is_active")
    private Boolean isActive;
    @JsonProperty("is_admin")
    private Boolean isAdmin;
}
