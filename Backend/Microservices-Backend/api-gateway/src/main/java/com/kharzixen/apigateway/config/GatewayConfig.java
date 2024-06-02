package com.kharzixen.apigateway.config;

import com.kharzixen.apigateway.filter.AuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    @Autowired
    private AuthenticationFilter authenticationFilter;

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("private-album-service-user-route", r -> r.path("/api/users/{userId}/private-albums/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://private-album-service"))

                .route("public-album-service-user-route", r -> r.path("/api/users/{userId}/public-albums/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://public-album-service"))

                .route("post-service-user-route", r -> r.path("/api/users/{userId}/posts/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://post-service"))

                .route("user-service-route", r -> r.path("/api/users/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))

                        .uri("lb://user-service"))


                .route("private-album-image-service-route", r -> r.path("/private-album-images/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://media-service"))

                .route("public-album-image-service-route", r -> r.path("/public-album-images/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://media-service"))

                .route("post-image-service-route", r -> r.path("/post-images/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))

                        .uri("lb://media-service"))

                .route("private-album-service-route", r -> r.path("/api/private-albums/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://private-album-service"))

                .route("public-album-service-route", r -> r.path("/api/public-albums/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))
                        .uri("lb://public-album-service"))

                .route("post-service-route", r -> r.path("/api/posts/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))

                        .uri("lb://post-service"))

                .route("authentication-service-route", r -> r.path("/api/auth/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))

                        .uri("lb://authentication-service"))

                .route("admin-users-route", r -> r.path("/admin/**")
                        .filters(f -> f.filter(authenticationFilter.apply(new AuthenticationFilter.Config())))

                        .uri("lb://authentication-service"))
                .build();


    }
}