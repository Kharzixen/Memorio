package com.kharzixen.authenticationservice.controller;

import com.kharzixen.authenticationservice.dto.UserDtoOut;
import com.kharzixen.authenticationservice.dto.UserPatchDtoIn;
import com.kharzixen.authenticationservice.model.User;
import com.kharzixen.authenticationservice.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
public class AdminController {

    private final UserService userService;

    @GetMapping("/admin/users")
    public ResponseEntity<Page<UserDtoOut>> getUsersOfApplicationPaginated
            (@RequestParam(defaultValue = "0") int page,
             @RequestParam(defaultValue = "10") int pageSize) {
        String username;
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = (User) authentication.getPrincipal();
        if(!user.getIsAdmin()){
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        Page<UserDtoOut> userDtoOutList = userService.getPageOfUsers(page, pageSize);
        return  ResponseEntity.ok(userDtoOutList);
    }

    @DeleteMapping("/admin/users/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long userId){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = (User) authentication.getPrincipal();
        if(!user.getIsAdmin()){
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        userService.deleteUser(userId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/admin/users/{userId}")
    public ResponseEntity<UserDtoOut> changeUser(
            @PathVariable Long userId,
            @RequestBody UserPatchDtoIn userPatchDtoIn){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = (User) authentication.getPrincipal();
        if(!user.getIsAdmin()){
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        UserDtoOut dtoOut = userService.patchUser(userId, userPatchDtoIn);
        return ResponseEntity.ok(dtoOut);
    }
}
