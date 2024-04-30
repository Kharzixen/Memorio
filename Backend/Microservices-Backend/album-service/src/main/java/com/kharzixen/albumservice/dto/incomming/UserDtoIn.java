package com.kharzixen.albumservice.dto.incomming;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDtoIn {
    @JsonProperty
    private Long id;
    @JsonProperty
    private String username;
    @JsonProperty("pfp_id")
    private String pfpId;
}
