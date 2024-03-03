package com.kharzixen.albumservice.dto.outgoing.album;

import com.kharzixen.albumservice.dto.outgoing.memorycollection.MemoryCollectionDtoSimplified;
import com.kharzixen.albumservice.dto.outgoing.user.UserDtoSimplified;
import com.kharzixen.albumservice.model.MemoryCollection;
import com.kharzixen.albumservice.model.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlbumDtoOut {
    private Long id;

    private UserDtoSimplified owner;

    private String caption;

    private String albumImageLink;

    private List<UserDtoSimplified> contributors;

    private MemoryCollectionDtoSimplified baseCollection;

    private List<MemoryCollectionDtoSimplified> collections;
}

