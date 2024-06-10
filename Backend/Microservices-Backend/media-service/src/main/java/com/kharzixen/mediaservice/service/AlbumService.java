package com.kharzixen.mediaservice.service;

import com.kharzixen.mediaservice.event.ContributorChangedEvent;
import com.kharzixen.mediaservice.model.Album;
import com.kharzixen.mediaservice.model.User;
import com.kharzixen.mediaservice.repository.AlbumRepository;
import com.kharzixen.mediaservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Set;

@Service
@AllArgsConstructor
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;

    public void updateContributors(ContributorChangedEvent event){
        Album  album =  albumRepository.findAlbumWithContributors(event.getAlbumId())
                .orElseGet(() -> albumRepository.save(new Album(event.getAlbumId(), Set.of())));

        User user =  userRepository.findUserWithAlbums(event.getUserId())
                .orElseGet(() -> userRepository.save(new User(event.getUserId(), event.getUsername(), Set.of())));
        Set<User> contributors = album.getContributors();

        switch( event.getMethod()) {
            case "ADD":
                contributors.add(user);
                break;
            case "REMOVE":
                contributors.remove(user);
                break;
            default:
        }
        album.setContributors(contributors);
        albumRepository.save(album);
    }
}
