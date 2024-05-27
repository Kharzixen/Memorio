package com.kharzixen.albumservice.projection;

import com.kharzixen.albumservice.model.Memory;

import java.util.Date;

public interface MemoryOfCollectionProjection {
    Memory getMemory();

    Date getAddedDate();
}
