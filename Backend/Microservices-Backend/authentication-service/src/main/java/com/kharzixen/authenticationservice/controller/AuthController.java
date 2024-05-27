package com.kharzixen.authenticationservice.controller;

import com.kharzixen.authenticationservice.dto.AuthRequest;
import com.kharzixen.authenticationservice.dto.RegistrationDtoIn;
import com.kharzixen.authenticationservice.dto.RegistrationDtoOut;
import com.kharzixen.authenticationservice.service.JwtUtil;
import com.kharzixen.authenticationservice.service.UserService;
import lombok.AllArgsConstructor;
import org.apache.coyote.Response;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class AuthController {

    private final UserService userService;
    private AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    @PostMapping("/register")
    ResponseEntity<RegistrationDtoOut> registerUser(@RequestBody RegistrationDtoIn registrationDtoIn){
        RegistrationDtoOut dtoOut = userService.registerUser(registrationDtoIn);
        return  ResponseEntity.ok(dtoOut);
    }

    @PostMapping("/token")
    public String getToken(@RequestBody AuthRequest authRequest) {
        Authentication authenticate = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword()));
        if (authenticate.isAuthenticated()) {
            return jwtUtil.generateToken(authRequest.getUsername());
        } else {
            throw new RuntimeException("invalid access");
        }
    }

    @GetMapping("/validate")
    public String validateToken(@RequestParam("token") String token) {
        jwtUtil.validateToken(token);
        return "Token is valid";
    }

    @GetMapping("/users")
    public String printUser(@RequestParam("token") String token) {
        return "Hello User";
    }


}
