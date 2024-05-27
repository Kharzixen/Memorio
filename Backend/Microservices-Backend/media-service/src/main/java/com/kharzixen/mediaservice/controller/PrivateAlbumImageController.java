package com.kharzixen.mediaservice.controller;

import com.kharzixen.mediaservice.dto.ImageCreatedResponseDto;
import com.kharzixen.mediaservice.dto.AlbumImageDtoIn;
import io.minio.*;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.InputStream;
import java.util.UUID;


@RestController
@RequestMapping("/private-album-images")
@AllArgsConstructor
@Slf4j
public class PrivateAlbumImageController {
    private final MinioClient minioClient;
    @GetMapping(path = "/{id}", produces = "image/jpg")
    ResponseEntity<?> getImageById(@PathVariable("id") String pathImageId) {
        String imageId = pathImageId.replace("-", "/");
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
    ResponseEntity<ImageCreatedResponseDto> createImage(@ModelAttribute AlbumImageDtoIn albumImageDtoIn) {
        try {
            String fileName = albumImageDtoIn.getImage().getOriginalFilename();
            InputStream inputStream = albumImageDtoIn.getImage().getInputStream();
            String imageName = UUID.randomUUID().toString().replace("-", "");
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket("default")
                    .object("album_" + albumImageDtoIn.getAlbumId() + "/" + imageName + ".jpg")
                    .stream(inputStream, albumImageDtoIn.getImage().getSize(), -1)
                    .contentType("image/jpeg")
                    .build();
            ObjectWriteResponse resp = minioClient.putObject(args);
            String imageId = resp.object().replace("/", "-");
            return ResponseEntity.ok(new ImageCreatedResponseDto(HttpStatus.OK.value(), imageId));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
