package com.kharzixen.postservice.service;

import com.kharzixen.postservice.dto.incomming.UserDtoIn;
import com.kharzixen.postservice.dto.outgoing.UserDtoOut;
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
        User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
        user.setDeleted(false);
        User saved = userRepository.save(user);
        return UserMapper.INSTANCE.modelToDto(saved);
    }
}
