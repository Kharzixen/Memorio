package com.kharzixen.albumservice.dto.incomming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlbumDtoIn {
    private Long ownerId;
    private String caption;
    private String albumImageLink;
    private List<Long> invitedUserIds;
}
