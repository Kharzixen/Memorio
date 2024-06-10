package com.kharzixen.userservice.controller;

import com.kharzixen.userservice.dto.incomming.FollowDtoIn;
import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.FollowDtoOut;
import com.kharzixen.userservice.dto.outgoing.SimpleUserDtoOut;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.error.DuplicateKeyErrorResponse;
import com.kharzixen.userservice.error.ErrorResponse;
import com.kharzixen.userservice.exception.DatabaseCommunicationException;
import com.kharzixen.userservice.exception.DuplicateFieldException;
import com.kharzixen.userservice.exception.EntityNotFoundException;
import com.kharzixen.userservice.exception.NoBodyException;
import com.kharzixen.userservice.service.UserService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLTimeoutException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@AllArgsConstructor
@Slf4j
public class UserController {
    private final UserService userService;


    @GetMapping("/api/users")
    public ResponseEntity<List<UserDtoOut>> getUsers(@RequestParam(required = false, name = "ids") List<Long> idList) {
        return new ResponseEntity<>(userService.getUsers(idList), HttpStatus.OK);
    }

    @GetMapping("/api/users/{id}")
    public ResponseEntity<UserDtoOut> getUserById(@PathVariable("id") Long userId) {
        //find user by id and return
        UserDtoOut user = userService.getUserById(userId);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @DeleteMapping("/api/users/{id}")
    public ResponseEntity<Void> deleteUserById(@PathVariable("id") Long userId, @RequestHeader("X-USER-ID") String requesterId,
                                               @RequestHeader("X-USERNAME") String username) {
        userService.deleteUserById(userId, Long.valueOf(requesterId));
        return ResponseEntity.noContent().build();
    }

    @PatchMapping(path = "/api/users/{id}", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<UserDtoOut> pathUserById(@PathVariable("id") Long userId,
                                                   @ModelAttribute @RequestBody UserPatchDtoIn patchDtoIn,
                                                   @RequestHeader("X-USER-ID") String requesterId,
                                                   @RequestHeader("X-USERNAME") String username) {
        UserDtoOut response = userService.patchUser(userId, patchDtoIn, userId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @PostMapping("/api/users/{id}/following")
    public ResponseEntity<FollowDtoOut> addUserToFollowing(@PathVariable("id") Long userId,
                                                           @RequestBody FollowDtoIn followDtoIn,
                                                           @RequestHeader("X-USER-ID") String requesterId,
                                                           @RequestHeader("X-USERNAME") String username) {
        FollowDtoOut followDtoOut = userService.addFollowing(userId, followDtoIn, Long.valueOf(requesterId));

        return new ResponseEntity<>(followDtoOut, HttpStatus.CREATED);
    }

    @DeleteMapping("/api/users/{followerId}/following/{userId}")
    public ResponseEntity<Void> removeUserFromFollowing(@PathVariable("followerId") Long followerId,
                                                        @PathVariable("userId") Long userId,
                                                        @RequestHeader("X-USER-ID") String requesterId,
                                                        @RequestHeader("X-USERNAME") String username) {
        userService.removeUserFromFollowing(followerId, userId, Long.valueOf(requesterId));
        return  ResponseEntity.noContent().build();
    }

    @GetMapping("/api/users/{id}/followers")
    ResponseEntity<Page<SimpleUserDtoOut>> getFollowersOfUser(
            @PathVariable("id") Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        Page<SimpleUserDtoOut> outPage = userService.getFollowersOfUser(userId, page, pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(outPage);
    }


    @GetMapping("/api/users/{id}/suggestions")
    ResponseEntity<Page<SimpleUserDtoOut>> getSuggestionsOfUSer(
            @PathVariable("id") Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        Page<SimpleUserDtoOut> outPage = userService.getSuggestionsOfUser(userId, page, pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(outPage);
    }

    @GetMapping("/api/users/{id}/following")
    ResponseEntity<Page<SimpleUserDtoOut>> getFollowingOfUser(
            @PathVariable("id") Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
        Page<SimpleUserDtoOut> outPage = userService.getFollowingOfUser(userId, page, pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(outPage);
    }

    @GetMapping("/api/users/{id}/following/{followingId}")
    ResponseEntity<SimpleUserDtoOut> getFollowingByIdOfUser(
            @PathVariable("id") Long userId,
            @PathVariable("followingId") Long followingId,
            @RequestHeader("X-USER-ID") String requesterId,
            @RequestHeader("X-USERNAME") String username) {
       SimpleUserDtoOut userDtoOut = userService.getFollowingByIdOfUser(userId, followingId, Long.valueOf(requesterId));
        return ResponseEntity.ok(userDtoOut);
    }
    @GetMapping("/api/users/{userId}/friends")
    ResponseEntity<Page<SimpleUserDtoOut>> getFriendsOfUser(@PathVariable("userId") Long userId, @RequestParam(defaultValue = "0") int page,
                                                            @RequestParam(defaultValue = "10") int pageSize,
                                                            @RequestHeader("X-USER-ID") String requesterId,
                                                            @RequestHeader("X-USERNAME") String username) {
        Page<SimpleUserDtoOut> friendsPage = userService.getFriendsOfUser(userId, page, pageSize, Long.valueOf(requesterId));
        return ResponseEntity.ok(friendsPage);
    }


    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleEntityNotFoundException(EntityNotFoundException ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(DatabaseCommunicationException.class)
    public ResponseEntity<ErrorResponse> handleMongoTimeoutException(SQLTimeoutException ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.SERVICE_UNAVAILABLE.value(), "The application " +
                "is currently unable to connect to the database. " +
                "We are aware of the issue and working on resolving it. Please check back later.");
        return new ResponseEntity<>(errorResponse, HttpStatus.SERVICE_UNAVAILABLE);
    }

    @ExceptionHandler(DuplicateFieldException.class)
    public ResponseEntity<DuplicateKeyErrorResponse> handleDuplicateFieldException(DuplicateFieldException ex) {
        DuplicateKeyErrorResponse errorResponse = new DuplicateKeyErrorResponse(HttpStatus.BAD_REQUEST.value(),
                ex.getFields(),
                "Duplicate field error! The following field already exists in the database: "
                        + ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(NoBodyException.class)
    public ResponseEntity<ErrorResponse> handleNoBodyException(NoBodyException ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(FileUploadException.class)
    public ResponseEntity<ErrorResponse> handleFileUploadException(NoBodyException ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Map<String, String> handleValidationExceptions(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return errors;
    }
}
