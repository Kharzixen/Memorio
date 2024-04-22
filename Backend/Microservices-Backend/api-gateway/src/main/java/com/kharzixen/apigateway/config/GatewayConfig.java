package com.kharzixen.apigateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder){
        return builder.routes()
                .route("user-service-route", r-> r.path("/api/users/**")
                        .uri("lb://user-service"))
                .route("relationship-service-route", r-> r
                        .path("/api/relationships/**")
                        .uri("lb://relationship-service"))

                .route("image-service-route", r -> r.path("/images/**")
                        .uri("lb://media-service"))

                .route("album-service-route", r -> r.path("/api/albums/**")
                        .uri("lb://album-service"))
                .build();
    }
}
