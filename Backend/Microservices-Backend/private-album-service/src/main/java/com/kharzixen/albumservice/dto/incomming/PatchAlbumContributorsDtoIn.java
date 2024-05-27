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
public class PatchAlbumContributorsDtoIn {
    private String method;
    private List<Long> userIds;

}
