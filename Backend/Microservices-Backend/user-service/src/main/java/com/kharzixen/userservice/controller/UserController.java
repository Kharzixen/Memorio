package com.kharzixen.userservice.controller;
import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.error.DuplicateKeyErrorResponse;
import com.kharzixen.userservice.error.ErrorResponse;
import com.kharzixen.userservice.exception.DatabaseCommunicationException;
import com.kharzixen.userservice.exception.DuplicateFieldException;
import com.kharzixen.userservice.exception.EntityNotFoundException;
import com.kharzixen.userservice.exception.NoBodyException;
import com.kharzixen.userservice.service.UserService;
import com.mongodb.MongoTimeoutException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@AllArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping("/api/users")
    public ResponseEntity<UserDtoOut> createUser(@RequestBody @Valid @NotNull UserDtoIn userDtoIn) {
        UserDtoOut response = userService.createUser(userDtoIn);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping("/api/users")
    public ResponseEntity<List<UserDtoOut>> getUsers(@RequestParam(required = false, name = "ids") List<String> idList) {
        return new ResponseEntity<>(userService.getUsers(idList), HttpStatus.OK);
    }

    @GetMapping("/api/users/{id}")
    public ResponseEntity<UserDtoOut> getUserById(@PathVariable("id") String userId) {
        UserDtoOut user = userService.getUserById(userId);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @DeleteMapping("/api/users/{id}")
    public ResponseEntity<Void> deleteUserById(@PathVariable("id") String userId) {
        userService.deleteUserById(userId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/api/users/{id}")
    public ResponseEntity<UserDtoOut> pathUserById(@PathVariable("id") String userId,
                                                   @RequestBody UserPatchDtoIn patchDtoIn) {
        UserDtoOut response = userService.patchUser(userId, patchDtoIn);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PutMapping("/api/users/{id}")
    public ResponseEntity<UserDtoOut> putUserById(@PathVariable("id") String userId,
                                                  @RequestBody UserDtoIn userDtoIn) {
        UserDtoOut response = userService.putUser(userId, userDtoIn);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleEntityNotFoundException(EntityNotFoundException ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(DatabaseCommunicationException.class)
    public ResponseEntity<ErrorResponse> handleMongoTimeoutException(MongoTimeoutException ex) {
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
    public ResponseEntity<ErrorResponse> handleNoBodyException(NoBodyException ex){
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
