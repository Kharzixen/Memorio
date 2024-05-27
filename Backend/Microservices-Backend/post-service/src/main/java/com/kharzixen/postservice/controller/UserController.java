package com.kharzixen.postservice.controller;

import com.kharzixen.postservice.dto.incomming.UserDtoIn;
import com.kharzixen.postservice.dto.outgoing.PostDtoOut;
import com.kharzixen.postservice.dto.outgoing.UserDtoOut;
import com.kharzixen.postservice.error.ErrorMessage;
import com.kharzixen.postservice.exception.UserNotFoundException;
import com.kharzixen.postservice.service.PostService;
import com.kharzixen.postservice.service.UserService;
import lombok.AllArgsConstructor;
import org.apache.http.protocol.HTTP;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor

public class UserController {
    private final UserService userService;
    private final PostService postService;

    @PostMapping("/api/post-users")
    ResponseEntity<UserDtoOut> createUser(@RequestBody UserDtoIn userDtoIn){
        UserDtoOut userDtoOut = userService.createUser(userDtoIn);
        return new ResponseEntity<>(userDtoOut, HttpStatus.CREATED);
    }

    @GetMapping("api/users/{userId}/posts")
    ResponseEntity<Page<PostDtoOut>> getPostsOfUser(@PathVariable Long userId,
                                                    @RequestParam(defaultValue = "0") int page,
                                                    @RequestParam(defaultValue = "10") int pageSize){
        Page<PostDtoOut> posts = postService.getPostsOfUser(userId, page, pageSize);
        return ResponseEntity.ok(posts);
    }

    //------------------------------------------------------------------------------------------------------------

    @ExceptionHandler(UserNotFoundException.class)
    ResponseEntity<ErrorMessage> handleUserNotFoundException(UserNotFoundException ex){
        ErrorMessage errorMessage = new ErrorMessage(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(errorMessage, HttpStatus.NOT_FOUND);
    }
}
