package com.kharzixen.mediaservice.controller;

import com.kharzixen.mediaservice.dto.ImageCreatedResponseDto;
import io.minio.*;
import jakarta.ws.rs.PathParam;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;


@RestController
@RequestMapping("/images")
@AllArgsConstructor
@Slf4j
public class ImageController {
    MinioClient minioClient;
    @GetMapping(path = "/{id}", produces = "image/jpg")
    ResponseEntity<?> getImageById(@PathVariable("id") String imageId) {
        log.info(imageId + " fetched");
        try {
            InputStream stream =
                    minioClient.getObject(GetObjectArgs
                            .builder()
                            .bucket("default")
                            .object(imageId)
                            .build());
            byte[] imageData = IOUtils.toByteArray(stream);
            return ResponseEntity.status(HttpStatus.OK).contentType(MediaType.IMAGE_PNG).body(imageData);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping
    ResponseEntity<ImageCreatedResponseDto> createImage(@RequestParam("image") MultipartFile image) {
        try {
            if(image.isEmpty()){
                return ResponseEntity.ok(new ImageCreatedResponseDto(HttpStatus.OK.value(), "default_album_image.jpg"));
            }
            String fileName = image.getOriginalFilename();
            InputStream inputStream = image.getInputStream();
            String imageName = UUID.randomUUID().toString().replace("-", "");
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket("default")
                    .object(imageName + ".jpg")
                    .stream(inputStream, image.getSize(), -1)
                    .contentType("image/jpeg")
                    .build();
            ObjectWriteResponse resp = minioClient.putObject(args);
            return ResponseEntity.ok(new ImageCreatedResponseDto(HttpStatus.OK.value(), resp.object()));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @DeleteMapping(path = "/{id}")
    ResponseEntity<Void> deleteImage(@PathVariable("id") String imageId ){
        try {
            minioClient.removeObject(RemoveObjectArgs.builder().bucket("default").object(imageId).build());
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
