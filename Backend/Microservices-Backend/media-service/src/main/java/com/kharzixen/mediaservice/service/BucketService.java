package com.kharzixen.mediaservice.service;

import io.minio.BucketExistsArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@Slf4j
public class BucketService {

    private final MinioClient minioClient;

    @EventListener
    public void onApplicationEvent(ContextRefreshedEvent event) {
        createBucket("public-album-bucket");
        createBucket("private-album-bucket");
        createBucket("post-bucket");
        createBucket("profile-bucket");
    }

    public void createBucket(String bucketName) {
        try {
            boolean found =
                    minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
            if (!found) {
                minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
            } else {
                log.info("Bucket {} already exists.", bucketName);
            }
        } catch (Exception e) {
            log.error("Error while creating bucket '{}': {}", bucketName, e.getMessage(), e);
        }
    }
}
