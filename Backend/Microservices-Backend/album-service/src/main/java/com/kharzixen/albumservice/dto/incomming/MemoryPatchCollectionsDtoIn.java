package com.kharzixen.albumservice.dto.incomming;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class MemoryPatchCollectionsDtoIn {
    private List<Long> collectionIds = new ArrayList<>();
}
