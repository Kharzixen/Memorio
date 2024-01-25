package com.kharzixen.userservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.MongoDatabaseFactory;
import org.springframework.data.mongodb.MongoTransactionManager;
import org.springframework.data.mongodb.SessionSynchronization;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;
import org.springframework.data.mongodb.core.MongoTemplate;

@Configuration
public class MongoConfig  {

    @Bean
    MongoTransactionManager transactionManager(MongoDatabaseFactory dbFactory){
        return new MongoTransactionManager(dbFactory);
    }

}
