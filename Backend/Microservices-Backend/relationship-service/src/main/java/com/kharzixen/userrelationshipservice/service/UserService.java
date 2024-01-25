package com.kharzixen.userrelationshipservice.service;

import com.kharzixen.userrelationshipservice.dto.outgoing.UserDtoOut;
import com.kharzixen.userrelationshipservice.dto.outgoing.UserDtoOutSimplified;
import com.kharzixen.userrelationshipservice.exception.BadRequestException;
import com.kharzixen.userrelationshipservice.exception.EntityNotFoundException;
import com.kharzixen.userrelationshipservice.mapper.UserMapper;
import com.kharzixen.userrelationshipservice.model.User;
import com.kharzixen.userrelationshipservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserDtoOut getUserById(String userId) throws EntityNotFoundException {
        return userRepository.findById(userId).map(userMapper::modelToDto)
                .orElseThrow(() -> new EntityNotFoundException(userId));
    }

    public List<UserDtoOutSimplified> getFollowers(String userId) throws EntityNotFoundException {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException(userId));

        return user.getFollowers().stream().map(userMapper::modelToSimplifiedDto).toList();
    }

    public List<UserDtoOutSimplified> getFollowings(String userId) throws EntityNotFoundException{
        User user =  userRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException(userId));

        return user.getFollowing().stream().map(userMapper::modelToSimplifiedDto).toList();
    }

    public List<UserDtoOut> getAllUsers(){
        return userRepository.findAll().stream().map(userMapper::modelToDto).toList();
    }

    public User createUser(User user) {
        return userRepository.save(user);
    }

    public void deleteUser(String userId){
        userRepository.deleteById(userId);
    }

    public User updateUser(String userId, String pfpLink){
        User oldUser = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException(userId));
        oldUser.setPfpLink(pfpLink);
        return userRepository.save(oldUser);
    }

    @Transactional
    public void addToFollowing(String userId, String receiverId) throws EntityNotFoundException, BadRequestException {
        if(Objects.equals(userId, receiverId)){
            String cause = "No self-loop (self-following relationship) allowed! UserId: " + userId;
            throw new BadRequestException(cause);
        }
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException(userId));
        User receiver = userRepository.findByUserId(receiverId)
                .orElseThrow(() -> new EntityNotFoundException(receiverId));
        user.getFollowing().add(receiver);
        user.setFollowingCount(user.getFollowingCount() + 1);
        receiver.getFollowers().add(user);
        receiver.setFollowersCount(receiver.getFollowersCount() + 1 );
        userRepository.save(user);
        userRepository.save(receiver);
    }

}
