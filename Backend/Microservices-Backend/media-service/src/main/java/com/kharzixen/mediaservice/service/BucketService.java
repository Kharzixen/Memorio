package com.kharzixen.mediaservice.service;

import io.minio.*;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.util.Objects;

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
                if(Objects.equals(bucketName, "public-album-bucket") || Objects.equals(bucketName, "private-album-bucket")){
                    InputStream image1Stream;
                    image1Stream = getClass().getResourceAsStream("/default_album_image.jpg");
                    assert image1Stream != null;
                    PutObjectArgs args = PutObjectArgs.builder()
                            .bucket(bucketName)
                            .object("default_album_image.jpg")
                            .stream(image1Stream, image1Stream.available(), -1)
                            .contentType("image/jpeg")
                            .build();
                    ObjectWriteResponse resp = minioClient.putObject(args);;
                    log.info("Image {} uploaded to {}", resp.object(), bucketName);
                }

                if(Objects.equals(bucketName, "profile-bucket")){
                    InputStream image1Stream;
                    image1Stream = getClass().getResourceAsStream("/default_pfp_id.jpg");
                    assert image1Stream != null;
                    PutObjectArgs args = PutObjectArgs.builder()
                            .bucket(bucketName)
                            .object("default_pfp_id.jpg")
                            .stream(image1Stream, image1Stream.available(), -1)
                            .contentType("image/jpeg")
                            .build();
                    ObjectWriteResponse resp = minioClient.putObject(args);;
                    log.info("Image {} uploaded to {}", resp.object(), bucketName);
                }
            } else {
                log.info("Bucket {} already exists.", bucketName);
            }

        } catch (Exception e) {
            log.error("Error while creating bucket '{}': {}", bucketName, e.getMessage(), e);
        }
    }
}
