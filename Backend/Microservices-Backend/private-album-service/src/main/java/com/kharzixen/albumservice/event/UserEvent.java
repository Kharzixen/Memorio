package com.kharzixen.albumservice.event;

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

    @JsonProperty("event_type")
    private String eventType;

    @JsonProperty("user_id")
    private Long userId;

    @JsonProperty
    private String username;

    @JsonProperty("pfp_id")
    private String pfpId;
}
