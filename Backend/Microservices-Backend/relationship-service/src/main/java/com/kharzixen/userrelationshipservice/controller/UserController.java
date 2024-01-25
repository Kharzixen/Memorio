package com.kharzixen.userrelationshipservice.controller;


import com.kharzixen.userrelationshipservice.dto.FollowerConnectionDto;
import com.kharzixen.userrelationshipservice.dto.outgoing.*;
import com.kharzixen.userrelationshipservice.error.ErrorResponse;
import com.kharzixen.userrelationshipservice.error.ValidationErrorResponse;
import com.kharzixen.userrelationshipservice.exception.BadRequestException;
import com.kharzixen.userrelationshipservice.exception.EntityNotFoundException;
import com.kharzixen.userrelationshipservice.service.UserService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.apache.catalina.connector.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/relationships/users")
@AllArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/{userId}")
    public ResponseEntity<UserDtoOut> getUserById(@PathVariable String userId) {
        UserDtoOut optionalUser = userService.getUserById(userId);
        return new ResponseEntity<>(optionalUser, HttpStatus.OK);
    }

    @GetMapping("/{userId}/followers")
    public ResponseEntity<List<UserDtoOutSimplified>> getFollowers(@PathVariable String userId) {
        return new ResponseEntity<>(userService.getFollowers(userId), HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<UserDtoOut>> getAllUsers(){
        return new ResponseEntity<>(userService.getAllUsers(), HttpStatus.OK);
    }

    @GetMapping("/{userId}/following")
    public ResponseEntity<List<UserDtoOutSimplified>> getFollowing(@PathVariable String userId) {
        return new ResponseEntity<>(userService.getFollowings(userId), HttpStatus.OK);
    }


    //to remove after kafka integration
//    @PostMapping
//    public ResponseEntity<UserDtoOut> createUser(@RequestBody User user) {
//        UserDtoOut createdUser = userService.createUser(user);
//        return new ResponseEntity<>(createdUser, HttpStatus.CREATED);
//    }

    @PostMapping("/{userId}/following")
    public ResponseEntity<?>
    addToFollowers(@PathVariable String userId,
                   @RequestBody @NotNull @Valid FollowerConnectionDto followerConnection) {
        userService.addToFollowing(followerConnection.getUserId(), followerConnection.getFollowerId());
        return new ResponseEntity<>(new FollowerConnectionDto(followerConnection.getUserId(),
                followerConnection.getFollowerId()), HttpStatus.CREATED);
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleEntityNotFoundException(EntityNotFoundException ex) {
        ErrorResponse response = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<ErrorResponse> handleBadRequestException(BadRequestException ex) {
        ErrorResponse response = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<ValidationErrorResponse> handleValidationException(MethodArgumentNotValidException ex){
        BindingResult bindingResult = ex.getBindingResult();

        Map<String, String> errors = new HashMap<>();
        for (FieldError error : bindingResult.getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        ValidationErrorResponse validationErrorResponse = new ValidationErrorResponse(HttpStatus.BAD_REQUEST.value(),
                "Validation Error!", errors);
        return new ResponseEntity<>(validationErrorResponse, HttpStatus.BAD_REQUEST);
    }
}
