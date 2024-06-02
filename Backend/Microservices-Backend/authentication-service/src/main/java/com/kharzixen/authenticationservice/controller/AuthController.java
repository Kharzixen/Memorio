package com.kharzixen.authenticationservice.controller;

import com.kharzixen.authenticationservice.dto.*;
import com.kharzixen.authenticationservice.model.User;
import com.kharzixen.authenticationservice.service.JwtUtil;
import com.kharzixen.authenticationservice.service.UserService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api/auth")
@Slf4j
public class AuthController {

    private final UserService userService;
    private AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    @PostMapping("/register")
    ResponseEntity<RegistrationDtoOut> registerUser(@RequestBody RegistrationDtoIn registrationDtoIn){
        RegistrationDtoOut dtoOut = userService.registerUser(registrationDtoIn);
        return  ResponseEntity.ok(dtoOut);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDto> getToken(@RequestBody AuthRequest authRequest) {
        try {
            Authentication authenticate = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword()));
            if (authenticate.isAuthenticated()) {
                String accessToken = jwtUtil.generateAccessToken(authRequest.getUsername());
                String refreshToken = jwtUtil.generateRefreshToken(authRequest.getUsername());
                return ResponseEntity.ok(new AuthResponseDto(accessToken, refreshToken));
            } else {
                throw new RuntimeException("invalid access");
            }
        } catch (BadCredentialsException e){
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }
    }

    @PostMapping("/refresh")
    public ResponseEntity<RefreshResponseDto> refreshToken(@RequestBody RefreshRequestDto refreshRequestDto) {
        String token = "";
        if (refreshRequestDto.getRefreshToken() != null) {
            token = refreshRequestDto.getRefreshToken();
        }

        if (jwtUtil.validateRefreshToken(token)) {
            String username = jwtUtil.extractUsername(token);
            if(userService.isUserSuspended(username)){
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);
            }
            String newAccessToken = jwtUtil.generateAccessToken(username);
            String newRefreshToken = jwtUtil.generateRefreshToken(username);

            RefreshResponseDto responseDto = new RefreshResponseDto(newAccessToken, newRefreshToken);
            log.info("New access token issued for {}", username);
            return ResponseEntity.ok(responseDto);

        } else {
            return ResponseEntity.status(401).body(null);
        }
    }

}
