package com.kharzixen.authenticationservice.service;

import com.kharzixen.authenticationservice.dto.RegistrationDtoIn;
import com.kharzixen.authenticationservice.dto.RegistrationDtoOut;
import com.kharzixen.authenticationservice.model.User;
import com.kharzixen.authenticationservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public RegistrationDtoOut registerUser(RegistrationDtoIn registrationDtoIn){
        if(Objects.equals(registrationDtoIn.getPassword(), registrationDtoIn.getConfirmPassword())){
            User user = new User(null, registrationDtoIn.getUsername(),
                    passwordEncoder.encode(registrationDtoIn.getPassword()));
            User saved = userRepository.save(user);
            return new RegistrationDtoOut(saved.getId(), saved.getUsername());
        } else {
            throw new RuntimeException("Password don't match");
        }
    }
    public String generateToken(String username) {
        return jwtUtil.generateToken(username);
    }

    public void validateToken(String token) {
        jwtUtil.validateToken(token);
    }

}
