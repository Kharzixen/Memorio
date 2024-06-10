package com.kharzixen.albumservice.controller;

import com.kharzixen.albumservice.dto.incomming.PatchUserAlbumsDtoIn;
import com.kharzixen.albumservice.dto.incomming.UserDtoIn;
import com.kharzixen.albumservice.dto.outgoing.UserAlbumsPatchedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.error.ErrorResponse;
import com.kharzixen.albumservice.exception.CollectionNameDuplicateException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.exception.UnauthorizedRequestException;
import com.kharzixen.albumservice.service.AlbumService;
import com.kharzixen.albumservice.service.UserService;
import lombok.AllArgsConstructor;
import org.apache.http.protocol.HTTP;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
public class UserController {

    private final UserService userService;
    private final AlbumService albumService;


    @GetMapping("/api/users/{userId}/private-albums")
    ResponseEntity<Page<AlbumPreviewDto>> getAlbumPreviewsForUser(@PathVariable Long userId,
                                                                  @RequestParam(defaultValue = "0") int page,
                                                                  @RequestParam(defaultValue = "10") int pageSize,
                                                                  @RequestHeader("X-USER-ID") String requesterId,
                                                                  @RequestHeader("X-USERNAME") String username) {

        Page<AlbumPreviewDto> previews = albumService.getAlbumPreviews(userId, page, pageSize, Long.valueOf(requesterId));
        return new ResponseEntity<>(previews, HttpStatus.OK);
    }

    @ExceptionHandler(NotFoundException.class)
    ResponseEntity<ErrorResponse> handleDuplicateCollectionNameException(NotFoundException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.NOT_FOUND.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(UnauthorizedRequestException.class)
    ResponseEntity<ErrorResponse> handleUnauthorizedException(UnauthorizedRequestException exception) {
        ErrorResponse response = new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), exception.getMessage());
        return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
    }

}
