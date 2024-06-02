package com.kharzixen.publicalbumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CommentDtoIn {
    private Long memoryId;
    private Long userId;
    private String message;
}
