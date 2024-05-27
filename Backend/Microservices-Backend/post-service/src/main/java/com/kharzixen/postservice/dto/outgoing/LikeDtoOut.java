package com.kharzixen.postservice.dto.outgoing;

import com.kharzixen.postservice.model.Post;
import com.kharzixen.postservice.model.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LikeDtoOut {

    private Long id;

    private UserDtoOut user;

    private PostDtoOut post;

    private Date likedDate;
}
