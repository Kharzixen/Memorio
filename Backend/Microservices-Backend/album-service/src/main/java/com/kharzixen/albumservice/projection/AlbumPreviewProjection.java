package com.kharzixen.albumservice.projection;

import com.kharzixen.albumservice.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

public interface AlbumPreviewProjection {
    Long getId();

    String getAlbumName();
    String getCaption();
    String getAlbumImageLink();


}
