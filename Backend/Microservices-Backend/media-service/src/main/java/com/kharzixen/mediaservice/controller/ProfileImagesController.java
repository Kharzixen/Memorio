package com.kharzixen.mediaservice.controller;


import com.kharzixen.mediaservice.dto.ImageCreatedResponseDto;
import com.kharzixen.mediaservice.dto.PostImageDtoIn;
import com.kharzixen.mediaservice.dto.ProfileImageDtoIn;
import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import io.minio.ObjectWriteResponse;
import io.minio.PutObjectArgs;
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
@RequestMapping("/profile-images")
@AllArgsConstructor
@Slf4j
public class ProfileImagesController {

    private final MinioClient minioClient;
    @GetMapping(path = "/{id}", produces = "image/jpg")
    ResponseEntity<?> getImageById(@PathVariable("id") String pathImageId) {
        try {
            InputStream stream =
                    minioClient.getObject(GetObjectArgs
                            .builder()
                            .bucket("profile-bucket")
                            .object(pathImageId)
                            .build());
            byte[] imageData = IOUtils.toByteArray(stream);
            return ResponseEntity.status(HttpStatus.OK).contentType(MediaType.IMAGE_PNG).body(imageData);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping
    ResponseEntity<ImageCreatedResponseDto> createImage(@ModelAttribute ProfileImageDtoIn profileImageDtoIn) {
        try {
            String fileName = profileImageDtoIn.getImage().getOriginalFilename();
            InputStream inputStream = profileImageDtoIn.getImage().getInputStream();
            String imageName = UUID.randomUUID().toString().replace("-", "");
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket("profile-bucket")
                    .object(  imageName + ".jpg")
                    .stream(inputStream, profileImageDtoIn.getImage().getSize(), -1)
                    .contentType("image/jpeg")
                    .build();
            ObjectWriteResponse resp = minioClient.putObject(args);
            return ResponseEntity.ok(new ImageCreatedResponseDto(HttpStatus.OK.value(), resp.object()));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
