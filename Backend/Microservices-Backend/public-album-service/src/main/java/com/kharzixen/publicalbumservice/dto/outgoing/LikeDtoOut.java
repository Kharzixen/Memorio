package com.kharzixen.publicalbumservice.dto.outgoing;

import com.kharzixen.publicalbumservice.dto.outgoing.memoryDto.SimpleMemoryDtoOut;
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

    private SimpleMemoryDtoOut memory;

    private Date likedDate;
}
