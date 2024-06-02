package com.kharzixen.apigateway.filter;

import com.kharzixen.apigateway.service.JwtUtil;
import io.jsonwebtoken.Claims;
import org.apache.http.HttpHeaders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Objects;

@Component
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {
    @Autowired
    private RouteValidator validator;

    @Autowired
    private JwtUtil jwtUtil;

    public AuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return ((exchange, chain) -> {
            if (validator.isSecured.test(exchange.getRequest())) {
                //header contains token or not
                if (!exchange.getRequest().getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                    return handleErrorResponse(exchange, HttpStatus.UNAUTHORIZED, "Missing authorization header");
                }

                String authHeader = Objects.requireNonNull(exchange.getRequest().getHeaders().get(HttpHeaders.AUTHORIZATION)).get(0);
                if (authHeader != null && authHeader.startsWith("Bearer ")) {
                    authHeader = authHeader.substring(7);
                }
                try {
                    boolean isValid = jwtUtil.validateToken(authHeader);
                    if(!isValid){
                        throw new RuntimeException("Invalid token");
                    }
                    Claims claims = jwtUtil.extractAllClaims(authHeader);
                    Long userId = Long.parseLong(claims.get("id").toString());
                    String username = jwtUtil.extractUsername(authHeader);

                    ServerHttpRequest mutatedRequest = exchange.getRequest().mutate()
                            .header("X-USER-ID", String.valueOf(userId))
                            .header("X-USERNAME", username)
                            .build();

                    return chain.filter(exchange.mutate().request(mutatedRequest).build());
                } catch (Exception e) {
                    exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
                    DataBuffer buffer = exchange.getResponse().bufferFactory().wrap(e.getMessage().getBytes());
                    return exchange.getResponse().writeWith(Mono.just(buffer));
                }
            }
            return chain.filter(exchange);
        });
    }

    private Mono<Void> handleErrorResponse(ServerWebExchange exchange, HttpStatus status, String message) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        DataBuffer dataBuffer = response.bufferFactory().wrap(("{\"error\": \"" + message + "\"}").getBytes());
        return response.writeWith(Mono.just(dataBuffer));
    }

    public static class Config {

    }
}
