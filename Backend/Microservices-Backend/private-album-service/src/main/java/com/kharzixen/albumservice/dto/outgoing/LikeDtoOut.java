package com.kharzixen.albumservice.dto.outgoing;

import com.kharzixen.albumservice.dto.outgoing.memoryDto.MemoryPreviewDtoOut;
import com.kharzixen.albumservice.dto.outgoing.memoryDto.SimpleMemoryDtoOut;
import com.kharzixen.albumservice.model.User;
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
