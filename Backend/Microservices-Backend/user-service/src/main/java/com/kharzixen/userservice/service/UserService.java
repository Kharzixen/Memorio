package com.kharzixen.userservice.service;

import com.kharzixen.userservice.dto.ImageCreatedResponseDto;
import com.kharzixen.userservice.dto.incomming.FollowDtoIn;
import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.FollowDtoOut;
import com.kharzixen.userservice.dto.outgoing.SimpleUserDtoOut;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.exception.DatabaseCommunicationException;
import com.kharzixen.userservice.exception.DuplicateFieldException;
import com.kharzixen.userservice.exception.EntityNotFoundException;
import com.kharzixen.userservice.exception.NoBodyException;
import com.kharzixen.userservice.mapper.UserMapper;
import com.kharzixen.userservice.model.User;
import com.kharzixen.userservice.model.UserEventOutbox;
import com.kharzixen.userservice.projection.SimpleUserProjection;
import com.kharzixen.userservice.repository.UserOutboxEventRepository;
import com.kharzixen.userservice.repository.UserRepository;
import com.kharzixen.userservice.webclient.ImageServiceClient;
import jakarta.ws.rs.NotFoundException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@AllArgsConstructor
@Slf4j
public class UserService {
    private final UserRepository userRepository;
    private final UserOutboxEventRepository userOutboxEventRepository;
    private final ImageServiceClient imageServiceClient;

    @Transactional
    public UserDtoOut createUser(UserDtoIn userDtoIn) throws DatabaseCommunicationException, DuplicateFieldException, FileUploadException {
        try {
            User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            user.setAccountCreationDate(new Date());
            if (userDtoIn.getProfileImage() == null || userDtoIn.getProfileImage().isEmpty()) {
                user.setPfpId("default_pfp_id.jpg");
            } else {
                ImageCreatedResponseDto imageDto = imageServiceClient.postImageToMediaService(userDtoIn.getProfileImage());
                user.setPfpId(imageDto.getImageId());
            }
            user.setFollowersCount(0);
            user.setFollowingCount(0);
            User saved = userRepository.save(user);
            UserEventOutbox event = new UserEventOutbox(null, "CREATE", saved.getId(),
                    saved.getUsername(), saved.getPfpId());
            userOutboxEventRepository.save(event);
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

    public List<UserDtoOut> getUsers(List<Long> userIdList)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            if (userIdList == null) {
                return UserMapper.INSTANCE.modelsToDtos(userRepository.findAll());
            } else {
                List<User> users = new ArrayList<>();
                for (Long id : userIdList) {
                    User user = userRepository.findById(id)
                            .orElseThrow(() -> new EntityNotFoundException("User", "id", id.toString(), "GET"));
                    users.add(user);
                }
                return UserMapper.INSTANCE.modelsToDtos(users);
            }
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }
    }

    public Page<SimpleUserDtoOut> getFriendsOfUser(Long userId, int page, int pageSize) {
        Sort sort = Sort.by(Sort.Direction.DESC, "username");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        User user = userRepository.findById(userId).orElseThrow(() -> new EntityNotFoundException("User", "id", userId.toString(), "GET"));
        Page<User> friends = userRepository.findFriendsOfUser(userId, pageRequest);
        List<SimpleUserDtoOut> friendsDtoOut = friends.getContent().stream().map(UserMapper.INSTANCE::modelToSimplifiedDto).toList();
        return new PageImpl<>(friendsDtoOut, pageRequest, friends.getTotalElements());
    }

    public UserDtoOut getUserById(Long userId)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", userId.toString(), "GET"));
            return UserMapper.INSTANCE.modelToDto(user);
        } catch (DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }
    }

    @Transactional
    public void deleteUserById(Long userId)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", userId.toString(), "DELETE"));
            userRepository.deleteById(userId);
            //save event to outbox in the same transaction;
            userOutboxEventRepository.save(new UserEventOutbox(null, "DELETE", user.getId(),
                    user.getUsername(), user.getPfpId()));
        } catch (
                DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }

    }

    public UserDtoOut patchUser(Long id, UserPatchDtoIn userPatchDtoIn)
            throws DatabaseCommunicationException, EntityNotFoundException, NoBodyException {
        try {
            User newUser = UserMapper.INSTANCE.dtoPatchToModel(userPatchDtoIn);
            User oldUser = userRepository.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", id.toString(), "PATCH"));

            if (newUser == null) {
                throw new NoBodyException("PATCH", id.toString());
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

    public UserDtoOut putUser(Long id, UserDtoIn userDtoIn)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            User newUser = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            User oldUser = userRepository.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", id.toString(), "PUT"));
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
        if (newUser.getPfpId() != null) {
            oldUser.setPfpId(newUser.getPfpId());
        }
        if (newUser.getBirthday() != null) {
            oldUser.setBirthday(newUser.getBirthday());
        }
    }

    @Transactional
    public FollowDtoOut addFollowing(Long userId, FollowDtoIn followDtoIn) {
        try {
            if (!Objects.equals(userId, followDtoIn.getFromId()) || Objects.equals(followDtoIn.getToId(), followDtoIn.getFromId())) {
                throw new RuntimeException();
            }
            User fromUser = userRepository.findById(followDtoIn.getFromId())
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", followDtoIn.getFromId().toString(), "ADD FOLLOWING"));
            User toUser = userRepository.findById(followDtoIn.getToId())
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", followDtoIn.getToId().toString(), "ADD FOLLOWING"));

            fromUser.getFollowing().add(toUser);
            fromUser.setFollowingCount(fromUser.getFollowingCount() + 1);
            toUser.getFollowers().add(fromUser);
            toUser.setFollowersCount(toUser.getFollowersCount() + 1);
            userRepository.save(fromUser);
            userRepository.save(toUser);
            return new FollowDtoOut(followDtoIn.getFromId(), followDtoIn.getToId());
        } catch (
                DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }

    }

    public Page<SimpleUserDtoOut> getFollowersOfUser(Long userId, int page, int pageSize) {
        if (userRepository.findById(userId).isEmpty()) {
            throw new EntityNotFoundException("user", "id", userId.toString(), "GET FOLLOWERS");
        }
        Sort sort = Sort.by(Sort.Direction.DESC, "username");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Page<SimpleUserProjection> pageResponse = userRepository.findFollowersOfUserByIdPaginated(userId, pageRequest);
        List<SimpleUserDtoOut> responseContent = pageResponse.getContent().stream().map(UserMapper.INSTANCE::projectionToDto).toList();
        return new PageImpl<>(responseContent, pageRequest, userRepository.getFollowersCount(userId));

    }

    public Page<SimpleUserDtoOut> getFollowingOfUser(Long userId, int page, int pageSize) {
        if (userRepository.findById(userId).isEmpty()) {
            throw new EntityNotFoundException("user", "id", userId.toString(), "GET FOLLOWING");
        }
        Sort sort = Sort.by(Sort.Direction.DESC, "username");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Page<SimpleUserProjection> pageResponse = userRepository.findFollowingOfUserByIdPaginated(userId, pageRequest);
        ;
        List<SimpleUserDtoOut> responseContent = pageResponse.getContent().stream().map(UserMapper.INSTANCE::projectionToDto).toList();
        return new PageImpl<>(responseContent, pageRequest, userRepository.getFollowingCount(userId));

    }

    public Page<SimpleUserDtoOut> getSuggestionsOfUser(Long userId, int page, int pageSize) {
        if (userRepository.findById(userId).isEmpty()) {
            throw new EntityNotFoundException("user", "id", userId.toString(), "GET FOLLOWING");
        }
        Sort sort = Sort.by(Sort.Direction.DESC, "username");
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        Page<SimpleUserProjection> pageResponse = userRepository.findUsersUserNotFollowing(userId, pageRequest);
        ;
        List<SimpleUserDtoOut> responseContent = pageResponse.getContent().stream().map(UserMapper.INSTANCE::projectionToDto).toList();
        return new PageImpl<>(responseContent, pageRequest, userRepository.getFollowingCount(userId));
    }

    @Transactional
    public void removeUserFromFollowing(Long followerId, Long userId) {
        User follower = userRepository.findById(followerId)
                .orElseThrow(() -> new EntityNotFoundException("USER", "ID", userId.toString(), "DELETE"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("USER", "ID", followerId.toString(), "DELETE"));

        int rowsAffected = userRepository.removeUserFromFollowing(followerId, userId);
        if (rowsAffected > 0) {
            follower.setFollowingCount(follower.getFollowingCount() - 1);
            user.setFollowersCount(user.getFollowersCount() - 1);
            userRepository.saveAll(List.of(user, follower));
        }
        log.info("${} number of rows affected.", rowsAffected);
    }

    public SimpleUserDtoOut getFollowingByIdOfUser(Long userId, Long followingId) {
        User following = userRepository.findById(followingId)
                .orElseThrow(() -> new EntityNotFoundException("USER", "ID", followingId.toString(), "DELETE"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("USER", "ID", userId.toString(), "DELETE"));

        int numberOfRow = userRepository.isFollowing(followingId, userId);
        if (numberOfRow > 0) {
            return UserMapper.INSTANCE.modelToSimplifiedDto(following);
        } else {
            throw new EntityNotFoundException("USER", "ID", followingId.toString(), "GET FOLLOWING");
        }
    }
}
