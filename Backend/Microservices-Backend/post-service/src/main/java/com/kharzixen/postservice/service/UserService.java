package com.kharzixen.postservice.service;

import com.kharzixen.postservice.dto.incomming.UserDtoIn;
import com.kharzixen.postservice.dto.outgoing.UserDtoOut;
import com.kharzixen.postservice.exception.DuplicateUserException;
import com.kharzixen.postservice.mapper.UserMapper;
import com.kharzixen.postservice.model.User;
import com.kharzixen.postservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public UserDtoOut createUser(UserDtoIn userDtoIn) {
        if(userRepository.findById(userDtoIn.getId()).isEmpty()){
            User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            user.setIsDeleted(false);
            User saved = userRepository.save(user);
            return UserMapper.INSTANCE.modelToDto(saved);
        } else {
            throw new DuplicateUserException(userDtoIn.getId());
        }
    }
}
