package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.User;
import com.netflix.discovery.converters.Auto;
import lombok.AllArgsConstructor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.List;

@DataJpaTest
public class RepositoryTest {

    @Autowired
    public AlbumRepository albumRepository;

    @Autowired
    public UserRepository userRepository;

    @Test
    void testRepositoryBehaviour(){
        userRepository.findAll();

    }
}
