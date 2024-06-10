package com.kharzixen.userservice.service;

import com.kharzixen.userservice.dto.ImageCreatedResponseDto;
import com.kharzixen.userservice.dto.incomming.FollowDtoIn;
import com.kharzixen.userservice.dto.incomming.UserDtoIn;
import com.kharzixen.userservice.dto.incomming.UserPatchDtoIn;
import com.kharzixen.userservice.dto.outgoing.FollowDtoOut;
import com.kharzixen.userservice.dto.outgoing.SimpleUserDtoOut;
import com.kharzixen.userservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userservice.exception.*;
import com.kharzixen.userservice.mapper.UserMapper;
import com.kharzixen.userservice.model.User;
import com.kharzixen.userservice.projection.SimpleUserProjection;
import com.kharzixen.userservice.repository.UserRepository;
import com.kharzixen.userservice.webclient.ImageServiceClient;
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
    private final ImageServiceClient imageServiceClient;

    @Transactional
    public UserDtoOut createUser(UserDtoIn userDtoIn) throws DatabaseCommunicationException, DuplicateFieldException, FileUploadException {
        try {
            User user = UserMapper.INSTANCE.dtoToModel(userDtoIn);
            user.setAccountCreationDate(new Date());

            user.setPfpId("default_pfp_id.jpg");

            user.setFollowersCount(0);
            user.setFollowingCount(0);
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

    public Page<SimpleUserDtoOut> getFriendsOfUser(Long userId, int page, int pageSize, Long requesterId) {
        if(Objects.equals(userId, requesterId)){
            Sort sort = Sort.by(Sort.Direction.DESC, "username");
            Pageable pageRequest = PageRequest.of(page, pageSize, sort);
            User user = userRepository.findById(userId).orElseThrow(() -> new EntityNotFoundException("User", "id", userId.toString(), "GET"));
            Page<User> friends = userRepository.findFriendsOfUser(userId, pageRequest);
            List<SimpleUserDtoOut> friendsDtoOut = friends.getContent().stream().map(UserMapper.INSTANCE::modelToSimplifiedDto).toList();
            return new PageImpl<>(friendsDtoOut, pageRequest, friends.getTotalElements());
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }
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
    public void deleteUserById(Long userId, Long requesterId)
            throws DatabaseCommunicationException, EntityNotFoundException {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("user", "id", userId.toString(), "DELETE"));
            if(userId.equals(requesterId)){
                userRepository.deleteById(userId);
            } else {
                User requester = userRepository.findById(requesterId)
                        .orElseThrow(() -> new EntityNotFoundException("user", "id", userId.toString(), "DELETE"));
                if(requester.getIsAdmin()){
                    userRepository.deleteById(userId);
                } else {
                    throw new UnauthorizedRequestException("Unauthorized");
                }
            }
        } catch (
                DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }

    }

    public UserDtoOut patchUser(Long id, UserPatchDtoIn userPatchDtoIn, Long requesterId)
            throws DatabaseCommunicationException, EntityNotFoundException, NoBodyException {
        try {
            User requesterUser = userRepository.findById(requesterId)
                    .orElseThrow(() -> new EntityNotFoundException("User", "ID", id.toString(), "PATCH"));
            if(Objects.equals(requesterId, id) || requesterUser.getIsAdmin()) {
                User user = userRepository.findById(id)
                        .orElseThrow(() -> new EntityNotFoundException("User", "ID", id.toString(), "PATCH"));
                if (userPatchDtoIn.getBio() != null) {
                    user.setBio(userPatchDtoIn.getBio());
                }

                if (userPatchDtoIn.getImage() != null && !userPatchDtoIn.getImage().isEmpty()) {
                    ImageCreatedResponseDto imageResponse = imageServiceClient
                            .postImageToMediaService(userPatchDtoIn.getImage(), user.getUsername());
                    user.setPfpId(imageResponse.getImageId());
                }
                User saved = userRepository.save(user);
                return UserMapper.INSTANCE.modelToDto(saved);
            } else {
                throw new UnauthorizedRequestException("Unauthorized");
            }
        } catch (DataAccessResourceFailureException | DuplicateKeyException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }
    }

//    public UserDtoOut putUser(Long id, UserDtoIn userDtoIn)
//            throws DatabaseCommunicationException, EntityNotFoundException {
//
//        try {
//            User newUser = UserMapper.INSTANCE.dtoToModel(userDtoIn);
//            User oldUser = userRepository.findById(id)
//                    .orElseThrow(() -> new EntityNotFoundException("user", "id", id.toString(), "PUT"));
//            newUser.setId(oldUser.getId());
//            User saved = userRepository.save(newUser);
//            return UserMapper.INSTANCE.modelToDto(saved);
//        } catch (DataAccessResourceFailureException ex) {
//            throw new DatabaseCommunicationException(ex.getMessage());
//        } catch (DuplicateKeyException ex) {
//            Map<String, String> fields = new HashMap<>();
//            Optional<User> optionalUser = userRepository.findByUsername(userDtoIn.getUsername());
//            if (optionalUser.isPresent()) {
//                fields.put("username", userDtoIn.getUsername());
//            }
//            optionalUser = userRepository.findByEmail(userDtoIn.getEmail());
//            if (optionalUser.isPresent()) {
//                fields.put("email", userDtoIn.getEmail());
//            }
//            throw new DuplicateFieldException(fields);
//        }
//    }



    @Transactional
    public FollowDtoOut addFollowing(Long userId, FollowDtoIn followDtoIn, Long requesterId) {
        try {
            if(Objects.equals(userId, requesterId) && Objects.equals(requesterId, followDtoIn.getFromId())){
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
            } else {
                throw new UnauthorizedRequestException("Unauthorized");
            }
        } catch (
                DataAccessResourceFailureException ex) {
            throw new DatabaseCommunicationException(ex.getMessage());
        }

    }

    public Page<SimpleUserDtoOut> getFollowersOfUser(Long userId, int page, int pageSize, Long requesterId) {
        try{
            if(Objects.equals(userId, requesterId)){
                if (userRepository.findById(userId).isEmpty()) {
                    throw new EntityNotFoundException("user", "id", userId.toString(), "GET FOLLOWERS");
                }
                Sort sort = Sort.by(Sort.Direction.DESC, "username");
                Pageable pageRequest = PageRequest.of(page, pageSize, sort);
                Page<SimpleUserProjection> pageResponse = userRepository.findFollowersOfUserByIdPaginated(userId, pageRequest);
                List<SimpleUserDtoOut> responseContent = pageResponse.getContent().stream().map(UserMapper.INSTANCE::projectionToDto).toList();
                return new PageImpl<>(responseContent, pageRequest, userRepository.getFollowersCount(userId));
            } else {
                throw new UnauthorizedRequestException("Unauthorized");
            }
        } catch (DataAccessResourceFailureException ex){
            throw new DatabaseCommunicationException(ex.getMessage());
        }

    }

    public Page<SimpleUserDtoOut> getFollowingOfUser(Long userId, int page, int pageSize, Long requesterId) {
       if(Objects.equals(userId, requesterId)){
           if (userRepository.findById(userId).isEmpty()) {
               throw new EntityNotFoundException("user", "id", userId.toString(), "GET FOLLOWING");
           }
           Sort sort = Sort.by(Sort.Direction.ASC, "username");
           Pageable pageRequest = PageRequest.of(page, pageSize, sort);
           Page<SimpleUserProjection> pageResponse = userRepository.findFollowingOfUserByIdPaginated(userId, pageRequest);
           ;
           List<SimpleUserDtoOut> responseContent = pageResponse.getContent().stream().map(UserMapper.INSTANCE::projectionToDto).toList();
           return new PageImpl<>(responseContent, pageRequest, userRepository.getFollowingCount(userId));
       } else {
           throw new UnauthorizedRequestException("Unauthorized");
       }

    }

    public Page<SimpleUserDtoOut> getSuggestionsOfUser(Long userId, int page, int pageSize, Long requesterId) {

        if(Objects.equals(userId, requesterId)){
            if (userRepository.findById(userId).isEmpty()) {
                throw new EntityNotFoundException("user", "id", userId.toString(), "GET FOLLOWING");
            }
            Sort sort = Sort.by(Sort.Direction.DESC, "username");
            Pageable pageRequest = PageRequest.of(page, pageSize, sort);
            Page<SimpleUserProjection> pageResponse = userRepository.findUsersUserNotFollowing(userId, pageRequest);
            ;
            List<SimpleUserDtoOut> responseContent = pageResponse.getContent().stream().map(UserMapper.INSTANCE::projectionToDto).toList();
            return new PageImpl<>(responseContent, pageRequest, userRepository.getFollowingCount(userId));
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }

    }

    @Transactional
    public void removeUserFromFollowing(Long followerId, Long userId, Long requesterId) {

        if(Objects.equals(followerId, requesterId)){
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
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }


    }

    public SimpleUserDtoOut getFollowingByIdOfUser(Long userId, Long followingId, Long requesterId) {
        if(Objects.equals(userId, requesterId)){
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
        } else {
            throw new UnauthorizedRequestException("Unauthorized");
        }

    }
}
