package com.kharzixen.mediaservice.controller;


import com.kharzixen.mediaservice.dto.ImageCreatedResponseDto;
import com.kharzixen.mediaservice.dto.PostImageDtoIn;
import com.kharzixen.mediaservice.dto.ProfileImageDtoIn;
import com.kharzixen.mediaservice.model.User;
import com.kharzixen.mediaservice.repository.UserRepository;
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
@RequestMapping("/profile-images")
@AllArgsConstructor
@Slf4j
public class ProfileImagesController {

    private final MinioClient minioClient;
    private final UserRepository userRepository;

    @GetMapping(path = "/{username}", produces = "image/jpg")
    ResponseEntity<?> getImageById(@PathVariable("username") String username) {
        try {
            String pfpId;
            User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("Not found"));
            if(user.getPfpId() == null){
                pfpId = "default_pfp_id.jpg";
            } else {
                pfpId = user.getPfpId();
            }
            InputStream stream =
                    minioClient.getObject(GetObjectArgs
                            .builder()
                            .bucket("profile-bucket")
                            .object(pfpId)
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
            User user = userRepository.findByUsername(profileImageDtoIn.getUsername()).orElseThrow(() -> new RuntimeException("Not found"));
            if(user.getPfpId() != null && !user.getPfpId().equals("default_pfp_id.jpg")) {
                minioClient.removeObject(
                        RemoveObjectArgs.builder().bucket("profile-bucket").object(user.getPfpId()).build()
                );
            }
            user.setPfpId(resp.object());
            userRepository.save(user);
            return ResponseEntity.ok(new ImageCreatedResponseDto(HttpStatus.OK.value(), resp.object()));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
