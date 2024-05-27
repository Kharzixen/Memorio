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
public class MemoryEvent {
    @JsonProperty
    private Long id;

    @JsonProperty("event_type")
    private String eventType;

    @JsonProperty("image_id")
    private String imageId;
}
