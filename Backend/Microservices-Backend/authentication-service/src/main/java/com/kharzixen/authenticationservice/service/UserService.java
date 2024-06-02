package com.kharzixen.authenticationservice.service;

import com.kharzixen.authenticationservice.dto.RegistrationDtoIn;
import com.kharzixen.authenticationservice.dto.RegistrationDtoOut;
import com.kharzixen.authenticationservice.dto.UserDtoOut;
import com.kharzixen.authenticationservice.dto.UserPatchDtoIn;
import com.kharzixen.authenticationservice.model.User;
import com.kharzixen.authenticationservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class UserService  {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;


    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("username not found"));
    }


    public RegistrationDtoOut registerUser(RegistrationDtoIn dtoIn){
        if(Objects.equals(dtoIn.getPassword(), dtoIn.getConfirmPassword())){
            User user = new User(null, dtoIn.getUsername(), dtoIn.getPassword(), false, true);
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            User saved = userRepository.save(user);
            return new RegistrationDtoOut(saved.getId(), saved.getUsername());
        } else {
            throw new RuntimeException("Passwords don't match");
        }
    }

    public Page<UserDtoOut> getPageOfUsers(int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "username");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Page<User> pageResponse = userRepository.findUsersOfPage(pageRequest);
        List<UserDtoOut> responseContent = pageResponse.getContent().stream().map(user ->
                UserDtoOut.builder()
                        .id(user.getId())
                        .username(user.getUsername())
                        .isAdmin(user.getIsAdmin())
                        .isActive(user.getIsActive())
                        .build())
                .toList();
        return new PageImpl<>(responseContent, pageRequest, pageResponse.getTotalElements());
    }

    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    public UserDtoOut patchUser(Long userId, UserPatchDtoIn userPatchDtoIn) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        user.setIsActive(userPatchDtoIn.getIsActive());
        User saved = userRepository.save(user);
        return UserDtoOut.builder()
                .id(saved.getId())
                .username(saved.getUsername())
                .isActive(saved.getIsActive())
                .isAdmin(saved.getIsAdmin())
                .build();
    }


    public boolean isUserSuspended(String username) {
        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User Not Found"));
        return !user.isEnabled();
    }
}
