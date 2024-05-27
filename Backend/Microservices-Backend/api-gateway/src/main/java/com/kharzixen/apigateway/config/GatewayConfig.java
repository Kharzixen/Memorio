package com.kharzixen.apigateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("private-album-service-user-route", r -> r.path("/api/users/{userId}/private-albums/**")
                        .uri("lb://private-album-service"))

                .route("post-service-user-route", r-> r.path("/api/users/{userId}/posts/**")
                        .uri("lb://post-service"))

                .route("user-service-route", r -> r.path("/api/users/**")
                        .uri("lb://user-service"))


                .route("private-album-image-service-route", r -> r.path("/private-album-images/**")
                        .uri("lb://media-service"))

                .route("post-image-service-route", r -> r.path("/post-images/**")
                        .uri("lb://media-service"))

                .route("private-album-service-route", r -> r.path("/api/private-albums/**")
                        .uri("lb://private-album-service"))

                .route("post-service-route", r -> r.path("/api/posts/**")
                        .uri("lb://post-service"))

                .build();


    }
}
