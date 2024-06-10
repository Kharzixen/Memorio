package com.kharzixen.publicalbumservice.service;


import com.kharzixen.publicalbumservice.dto.incomming.UserDtoIn;
import com.kharzixen.publicalbumservice.dto.outgoing.UserDtoOut;
import com.kharzixen.publicalbumservice.exception.DuplicateUserException;
import com.kharzixen.publicalbumservice.exception.NotFoundException;
import com.kharzixen.publicalbumservice.mapper.UserMapper;
import com.kharzixen.publicalbumservice.model.User;
import com.kharzixen.publicalbumservice.repository.AlbumRepository;
import com.kharzixen.publicalbumservice.repository.MemoryRepository;
import com.kharzixen.publicalbumservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final MemoryRepository memoryRepository;
    private final AlbumRepository albumRepository;

    //temporary, the user creation will be event driven
    public UserDtoOut createUser(UserDtoIn userDtoIn) {
        User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
        if(userRepository.findById(userDtoIn.getId()).isEmpty()){
            user.setIsDeleted(false);
           User savedUser = userRepository.save(user);
            return UserMapper.INSTANCE.modelToDto(savedUser);
        };

        throw new DuplicateUserException(user.getId());
    }

    //TODO refactor the findById to only get the data that is needed (no collections, albums, etc)
    public UserDtoOut getUserById(Long id){
        User user = userRepository.findById(id).orElseThrow(() -> new NotFoundException("User", id));
        return UserMapper.INSTANCE.modelToDto(user);
    }


}
