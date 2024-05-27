package com.kharzixen.albumservice.repository;

import com.kharzixen.albumservice.model.MemoryCollectionRelationship;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MemoryCollectionRelationshipRepository extends JpaRepository<MemoryCollectionRelationship, Long>  {

    @Modifying
    @Query("DELETE FROM MemoryCollectionRelationship m WHERE m.memory.id = :memoryId")
    void deleteAllMemoryCollectionRelationshipWhereMemoryId(@Param("memoryId") Long memoryId);


    @Modifying
    @Query("DELETE FROM MemoryCollectionRelationship m WHERE m.collection.id = :collectionId")
    void deleteAllMemoryCollectionRelationshipWhereCollectionId(@Param("collectionId") Long collectionId);

}
