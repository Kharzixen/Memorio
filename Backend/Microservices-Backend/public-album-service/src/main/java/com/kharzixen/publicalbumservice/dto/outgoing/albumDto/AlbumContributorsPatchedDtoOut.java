package com.kharzixen.publicalbumservice.dto.outgoing.albumDto;

import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlbumContributorsPatchedDtoOut {
    private String method;
    private String albumId;
    private List<UserDtoOut> changedContributors;
}
