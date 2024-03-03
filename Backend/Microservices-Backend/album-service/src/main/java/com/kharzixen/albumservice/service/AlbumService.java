package com.kharzixen.albumservice.service;

import com.kharzixen.albumservice.dto.incomming.AlbumDtoIn;
import com.kharzixen.albumservice.dto.outgoing.album.AlbumDtoOut;
import com.kharzixen.albumservice.mapper.AlbumMapper;
import com.kharzixen.albumservice.model.Album;
import com.kharzixen.albumservice.model.MemoryCollection;
import com.kharzixen.albumservice.model.User;
import com.kharzixen.albumservice.repository.AlbumRepository;
import com.kharzixen.albumservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Service
@AllArgsConstructor
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final UserRepository userRepository;

    @Transactional
    private AlbumDtoOut createAlbum(AlbumDtoIn albumDtoIn) {
        Album album = AlbumMapper.INSTANCE.dtoToModel(albumDtoIn);
        User owner = userRepository.findById(albumDtoIn.getOwnerId())
                .orElseThrow(() -> new RuntimeException("user does not exists with id: " + albumDtoIn.getOwnerId()));
        List<User> contributors = albumDtoIn.getInvitedUserIds().stream().
                map(userId -> userRepository.findById(userId).
                        orElseThrow(() -> new RuntimeException("user does not exists with id: " + userId)))
                .toList();

        album.setOwner(owner);
        album.setContributors(contributors);

        MemoryCollection baseCollection = new MemoryCollection();
        baseCollection.setCollectionName("All photos");
        baseCollection.setCreator(owner);
        baseCollection.setAlbum(album);
        baseCollection.setMemories(Collections.emptyList());
        album.setBaseCollection(baseCollection);
        album.getCollections().add(baseCollection);
        albumRepository.save(album);
        return AlbumMapper.INSTANCE.modelToDto(album);
    }

}
