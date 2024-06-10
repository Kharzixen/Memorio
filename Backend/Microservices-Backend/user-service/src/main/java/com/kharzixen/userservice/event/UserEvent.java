package com.kharzixen.userservice.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserEvent {
    private Long id;
    private String method;
    @JsonProperty("user_id")
    private Long userId;
    private String username;
    private String name;
    @JsonProperty("email")
    private String email;
    private Long birthday;
    //status
    @JsonProperty("is_admin")
    private Boolean isAdmin;
    @JsonProperty("is_active")
    private Boolean isActive;
}
