package com.kharzixen.mediaservice.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ContributorChangedEvent {
    private Long id;
    private String method;

    @JsonProperty("album_id")
    private Long albumId;

    @JsonProperty("user_id")
    private Long userId;
    private String username;
}
