package com.kharzixen.albumservice.projection;

import com.kharzixen.albumservice.model.User;
import jakarta.persistence.*;

import java.util.Date;

public interface MemoryProjection {

    Long getId();

    UserProjection getUploader();

    String getCaption();

    String getImageLink();

    Date getCreationDate();
}
