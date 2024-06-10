package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.PatchUserAlbumsDtoIn;
import com.kharzixen.albumservice.dto.incomming.UserDtoIn;
import com.kharzixen.albumservice.dto.outgoing.UserAlbumsPatchedDtoOut;
import com.kharzixen.albumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.albumservice.exception.DuplicateUserException;
import com.kharzixen.albumservice.exception.NotFoundException;
import com.kharzixen.albumservice.mapper.UserMapper;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.MemoryRepository;
import com.kharzixen.albumservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final MemoryRepository memoryRepository;
    private final AlbumRepository albumRepository;

    public UserDtoOut createUser(UserDtoIn userDtoIn) throws DuplicateUserException{
        if(userRepository.findById(userDtoIn.getId()).isEmpty()){
            User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            user.setIsDeleted(false);
            User savedUser = userRepository.save(user);
            return UserMapper.INSTANCE.modelToDto(savedUser);
        } else {
            throw new DuplicateUserException(userDtoIn.getId());
        }
    }

    //TODO refactor the findById to only get the data that is needed (no collections, albums, etc)
    public UserDtoOut getUserById(Long id){
        User user = userRepository.findById(id).orElseThrow(() -> new NotFoundException("User", id));
        return UserMapper.INSTANCE.modelToDto(user);
    }


}
