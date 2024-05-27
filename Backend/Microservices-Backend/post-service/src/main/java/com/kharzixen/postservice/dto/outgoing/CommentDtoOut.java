package com.kharzixen.postservice.dto.outgoing;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CommentDtoOut {
    private Long id;

    private UserDtoOut owner;

    private PostDtoOut post;

    private String message;

    private Date dateWhenMade;
}
