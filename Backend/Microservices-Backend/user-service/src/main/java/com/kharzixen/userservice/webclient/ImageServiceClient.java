package com.kharzixen.userservice.webclient;

import com.kharzixen.userservice.dto.ImageCreatedResponseDto;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@AllArgsConstructor
@Component
public class ImageServiceClient {
    private final WebClient.Builder webClientBuilder;

    public ImageCreatedResponseDto postImageToMediaService(MultipartFile image){
        MultipartBodyBuilder builder = new MultipartBodyBuilder();
        builder.part("image", image.getResource());
        Mono<ImageCreatedResponseDto> status = webClientBuilder.build().post().uri("http://media-service/images")
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .body(BodyInserters.fromMultipartData(builder.build())).exchangeToMono(clientResponse -> {
                    if(clientResponse.statusCode().equals(HttpStatus.OK)){
                        return clientResponse.bodyToMono(ImageCreatedResponseDto.class);
                    } else {
                        throw new RuntimeException("Error uploading file");
                    }
                });
        return status.block();
    }

}
