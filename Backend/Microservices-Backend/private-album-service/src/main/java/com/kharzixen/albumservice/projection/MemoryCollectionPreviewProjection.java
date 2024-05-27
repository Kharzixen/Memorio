package com.kharzixen.albumservice.projection;

import java.util.Date;

public interface MemoryCollectionPreviewProjection {
    Long getId();
    String getCollectionName();

    UserProjection getCreator();

    AlbumPreviewProjection getAlbum();

    String getCollectionDescription();
    Date getCreationDate();
}
