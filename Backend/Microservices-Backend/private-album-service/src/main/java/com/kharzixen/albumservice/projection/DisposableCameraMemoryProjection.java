package com.kharzixen.albumservice.projection;

import java.util.Date;

public interface DisposableCameraMemoryProjection {
    Long getId();

    UserProjection getUploader();

    String getCaption();

    String getImageId();

    Date getCreationDate();
}
