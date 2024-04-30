package com.kharzixen.albumservice.controller;

import com.kharzixen.albumservice.dto.incomming.PatchUserAlbumsDtoIn;
import com.kharzixen.albumservice.dto.incomming.UserDtoIn;
import com.kharzixen.albumservice.dto.outgoing.UserAlbumsPatchedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.albumDto.AlbumPreviewDto;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
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


    //temporary endpoint, user creation will be event driven
    @GetMapping("/api/albums/users/{userId}")
    ResponseEntity<UserDtoOut> getUser(@PathVariable Long userId){
        UserDtoOut userDtoOut = userService.getUserById(userId);
        return new ResponseEntity<>(userDtoOut, HttpStatus.OK);
    }

    @GetMapping("/api/users/{userId}/albums")
    ResponseEntity<Page<AlbumPreviewDto>> getAlbumPreviewsForUser(@PathVariable Long userId,
                                                           @RequestParam(defaultValue = "0") int page,
                                                           @RequestParam(defaultValue = "10") int pageSize) {

        Page<AlbumPreviewDto> previews = albumService.getAlbumPreviews(userId, page, pageSize);
        return new ResponseEntity<>(previews, HttpStatus.OK);
    }
}
