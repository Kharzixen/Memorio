package com.kharzixen.mediaservice.controller;

import com.kharzixen.mediaservice.dto.ImageCreatedResponseDto;
import com.kharzixen.mediaservice.dto.AlbumImageDtoIn;
import com.kharzixen.mediaservice.exception.UnauthorizedRequestException;
import com.kharzixen.mediaservice.model.Album;
import com.kharzixen.mediaservice.model.User;
import com.kharzixen.mediaservice.repository.AlbumRepository;
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
import java.util.Objects;
import java.util.UUID;


@RestController
@RequestMapping("/private-album-images")
@AllArgsConstructor
@Slf4j
public class PrivateAlbumImageController {
    private final MinioClient minioClient;
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;

    @GetMapping(path = "/{id}", produces = "image/jpg")
    ResponseEntity<?> getImageById(@PathVariable("id") String pathImageId, @RequestHeader("X-USER-ID") String requesterId,
                                   @RequestHeader("X-USERNAME") String username) {
        try {
            String imageId;
            if(Objects.equals(pathImageId, "default_album_image.jpg")){
                imageId = pathImageId;
            } else {
                imageId = pathImageId.replace("-", "/");
                String[] parts = pathImageId.split("-");
                String albumId = parts[0].split("_")[1];
                Album album = albumRepository.findAlbumWithContributors(Long.valueOf(albumId))
                        .orElseThrow(() -> new RuntimeException("Album not found"));
                User requester = userRepository.findById(Long.valueOf(requesterId))
                        .orElseThrow(() -> new RuntimeException("Album not found"));
                if (!album.getContributors().contains(requester)){
                    throw new UnauthorizedRequestException("Unauthorized");
                }
            }
                InputStream stream =
                        minioClient.getObject(GetObjectArgs
                                .builder()
                                .bucket("private-album-bucket")
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
                    .bucket("private-album-bucket")
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
