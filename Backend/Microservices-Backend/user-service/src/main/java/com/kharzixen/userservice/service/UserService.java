package com.kharzixen.userservice.service;

import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.exception.DatabaseCommunicationException;
import com.kharzixen.userservice.exception.DuplicateFieldException;
import com.kharzixen.userservice.exception.EntityNotFoundException;
import com.kharzixen.userservice.exception.NoBodyException;
import com.kharzixen.userservice.mapper.UserMapper;
import com.kharzixen.userservice.model.User;
import com.kharzixen.userservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public UserDtoOut createUser(UserDtoIn userDtoIn) throws DatabaseCommunicationException, DuplicateFieldException {
        try {
            User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            user.setAccountCreationDate(new Date());
            user.setPfpLink("defaultlink");
            User saved = userRepository.save(user);

            return UserMapper.INSTANCE.modelToDto(saved);
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        } catch (DuplicateKeyException ex) {
            Map<String, String> fields = new HashMap<>();
            Optional<User> optionalUser = userRepository.findByUsername(userDtoIn.getUsername());
            if (optionalUser.isPresent()) {
                fields.put("username", userDtoIn.getUsername());
            }
            optionalUser = userRepository.findByEmail(userDtoIn.getEmail());
            if (optionalUser.isPresent()) {
                fields.put("email", userDtoIn.getEmail());
            }

            throw new DuplicateFieldException(fields);
        }
    }

    public List<UserDtoOut> getUsers(List<String> userIdList)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            if (userIdList == null) {
                return UserMapper.INSTANCE.modelsToDtos(userRepository.findAll());
            } else {
                List<User> users = new ArrayList<>();
                for (String id : userIdList) {
                    User user = userRepository.findById(id)
                            .orElseThrow(() -> new EntityNotFoundException("User", "id", id, "GET"));
                    users.add(user);
                }
                return UserMapper.INSTANCE.modelsToDtos(users);
            }
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }
    }

    public UserDtoOut getUserById(  String userId)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", userId, "GET"));
            return UserMapper.INSTANCE.modelToDto(user);
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }
    }

    public void deleteUserById(String userId)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            userRepository.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", userId, "DELETE"));
            userRepository.deleteById(userId);
            //kafka to the friend service event
        } catch (
                DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }

    }

    public UserDtoOut patchUser(String id, UserPatchDtoIn userPatchDtoIn)
            throws DatabaseCommunicationException, EntityNotFoundException, NoBodyException {
        try {
            User newUser = UserMapper.INSTANCE.dtoPatchToModel(userPatchDtoIn);
            User oldUser = userRepository.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", id, "PATCH"));

            if (newUser == null) {
                throw new NoBodyException("PATCH", id);
            }
            patchUserFunction(oldUser, newUser);
            User saved = userRepository.save(oldUser);
            return UserMapper.INSTANCE.modelToDto(saved);
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        } catch (DuplicateKeyException ex) {
            Map<String, String> fields = new HashMap<>();
            Optional<User> optionalUser = userRepository.findByUsername(userPatchDtoIn.getUsername());
            if (optionalUser.isPresent()) {
                fields.put("username", userPatchDtoIn.getUsername());
            }
            optionalUser = userRepository.findByEmail(userPatchDtoIn.getEmail());
            if (optionalUser.isPresent()) {
                fields.put("email", userPatchDtoIn.getEmail());
            }

            throw new DuplicateFieldException(fields);
        }
    }

    public UserDtoOut putUser(String id, UserDtoIn userDtoIn)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            User newUser = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            User oldUser = userRepository.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", id, "PUT"));
            newUser.setId(oldUser.getId());
            User saved = userRepository.save(newUser);
            return UserMapper.INSTANCE.modelToDto(saved);
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        } catch (DuplicateKeyException ex) {
            Map<String, String> fields = new HashMap<>();
            Optional<User> optionalUser = userRepository.findByUsername(userDtoIn.getUsername());
            if (optionalUser.isPresent()) {
                fields.put("username", userDtoIn.getUsername());
            }
            optionalUser = userRepository.findByEmail(userDtoIn.getEmail());
            if (optionalUser.isPresent()) {
                fields.put("email", userDtoIn.getEmail());
            }
            throw new DuplicateFieldException(fields);
        }
    }

    private static void patchUserFunction(User oldUser, User newUser) {
        if (newUser.getUsername() != null) {
            oldUser.setUsername(newUser.getUsername());
        }
        if (newUser.getName() != null) {
            oldUser.setName(newUser.getName());
        }
        if (newUser.getBio() != null) {
            oldUser.setBio(newUser.getBio());
        }
        if (newUser.getEmail() != null) {
            oldUser.setEmail(newUser.getEmail());
        }
        if (newUser.getPfpLink() != null) {
            oldUser.setPfpLink(newUser.getPfpLink());
        }
        if (newUser.getBirthday() != null) {
            oldUser.setBirthday(newUser.getBirthday());
        }
    }
}
