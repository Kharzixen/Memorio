package com.kharzixen.mediaservice.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class ApiKetAuthFilter extends OncePerRequestFilter {
    @Value("${api.upload-key.name}")
    private String apiKeyName;
    @Value("${api.upload-key.value}")
    private String apiKeyValue;

    @Value("${api.upload-secret.name}")
    private String apiSecretName;

    @Value("${api.upload-secret.value}")
    private String apiSecretValue;


    @Override
    protected void doFilterInternal(HttpServletRequest request, @NotNull HttpServletResponse response, @NotNull FilterChain filterChain) throws ServletException, IOException {

        if ("/images".equals(request.getRequestURI()) && HttpMethod.POST.matches(request.getMethod())) {
            // Get the API key and secret from request headers
            String requestApiKey = request.getHeader(apiKeyName);
            String requestApiSecret = request.getHeader(apiSecretName);

            // Validate the key and secret
            if (apiKeyValue.equals(requestApiKey) && apiSecretValue.equals(requestApiSecret)) {
                // Continue processing the request
                filterChain.doFilter(request, response);
            } else {
                // Reject the request and send an unauthorized error
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                response.getWriter().write("Unauthorized");
            }
            return;
        }

        // For other endpoints, continue processing the request without API key authentication
        filterChain.doFilter(request, response);
    }
}

