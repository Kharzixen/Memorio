package com.kharzixen.postservice.webclient;

import com.kharzixen.postservice.dto.ImageCreatedResponseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Objects;

@Component
public class ImageServiceClient {
    @Autowired
    private WebClient.Builder webClientBuilder;

    @Value("${api.upload-key.value}")
    private String mediaServiceApiKeyValue;

    @Value("${api.upload-key.name}")
    private String mediaServiceApiKeyName;

    @Value("${api.upload-secret.value}")
    private String mediaServiceApiSecretValue;
    @Value("${api.upload-secret.name}")
    private String mediaServiceApiSecretName;


    public ImageCreatedResponseDto postImageToMediaService(MultipartFile image, Long userId){
        MultipartBodyBuilder builder = new MultipartBodyBuilder();
        builder.part("image", image.getResource());
        builder.part("userId", userId);
        Mono<ImageCreatedResponseDto> status = webClientBuilder.build().post().uri("http://media-service/post-images")
                .header(mediaServiceApiKeyName, mediaServiceApiKeyValue)
                .header(mediaServiceApiSecretName, mediaServiceApiSecretValue)
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .body(BodyInserters.fromMultipartData(builder.build()))
                .exchangeToMono(clientResponse -> {
                    if(clientResponse.statusCode().equals(HttpStatus.OK)){
                        return clientResponse.bodyToMono(ImageCreatedResponseDto.class);
                    } else {
                        throw new RuntimeException("Error uploading file");
                    }
                });
        return status.block();
    }


}
