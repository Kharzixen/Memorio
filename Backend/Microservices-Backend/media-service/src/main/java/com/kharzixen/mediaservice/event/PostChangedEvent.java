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
public class PostChangedEvent {
    private Long id;
    private String method;
    @JsonProperty("post_id")
    private Long postId;
    @JsonProperty("image_id")
    private String imageId;
}
