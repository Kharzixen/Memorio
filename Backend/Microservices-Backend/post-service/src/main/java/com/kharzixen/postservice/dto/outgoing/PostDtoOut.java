package com.kharzixen.postservice.dto.outgoing;

import com.kharzixen.postservice.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostDtoOut {

    private Long id;

    private UserDtoOut owner;

    private String caption;

    private String imageId;

    private Date creationDate;
}
