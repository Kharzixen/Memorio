package com.kharzixen.mediaservice.service;

import com.kharzixen.mediaservice.event.PostChangedEvent;
import io.minio.MinioClient;
import io.minio.RemoveObjectArgs;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
@AllArgsConstructor
public class PostService {
    private final MinioClient minioClient;

    public void handlePostChange(PostChangedEvent contributorChangedEvent) {
        if(Objects.equals(contributorChangedEvent.getMethod(), "DELETE")){
            try {
                String imageId = contributorChangedEvent.getImageId().replace("-", "/");

                minioClient.removeObject(RemoveObjectArgs.builder().bucket("post-bucket")
                        .object(imageId).build());
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
}
