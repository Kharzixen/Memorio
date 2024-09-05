#!/bin/bash

# URL of the Debezium Connect REST API
DEBEZIUM_CONNECT_URL="http://localhost:8083/connectors"

# Function to create or update a connector
create_connector() {
    CONNECTOR_NAME=$1
    CONNECTOR_CONFIG=$2

    echo "Creating or updating connector: $CONNECTOR_NAME"
    curl -X POST -H "Content-Type: application/json" \
         --data "${CONNECTOR_CONFIG}" \
         "${DEBEZIUM_CONNECT_URL}"
}

# Connector configurations
public_album_db_connector_config='{
    "name": "public-album-db-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "database.hostname": "mysql",
        "database.port": "3306",
        "database.user": "connector_user",
        "database.password": "123456",
        "database.server.id": "4",
        "topic.prefix": "memorio",
        "database.useSSL": "false",
        "database.allowPublicKeyRetrieval": "true",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.server.name": "public_album_db",
        "database.history.kafka.topic": "schema-changes.public_album_db",
        "database.whitelist": "publicalbumdb_test",
        "table.whitelist": "publicalbumdb_test.memory_event_outbox",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "schema.history.internal.kafka.topic": "schema-changes",
        "name": "public-album-db-connector"
      }
  }'

private_album_db_connector_config='{
    "name": "private-album-db-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "database.allowPublicKeyRetrieval": "true",
        "database.user": "connector_user",
        "database.server.id": "3",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "schema-changes.albumdb_test",
        "database.server.name": "private_album_db",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "database.port": "3306",
        "table.whitelist": "albumdb_test.memory_event_outbox",
        "topic.prefix": "memorio",
        "database.useSSL": "false",
        "schema.history.internal.kafka.topic": "schema-changes",
        "database.hostname": "mysql",
        "database.password": "123456",
        "name": "private-album-db-connector",
        "database.whitelist": "albumdb_test"
    }
}'

auth_db_connector_config='{
    "name": "auth-db-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "database.allowPublicKeyRetrieval": "true",
        "database.user": "connector_user",
        "database.server.id": "1",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "schema-changes.auth_db",
        "database.server.name": "auth_db",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "database.port": "3306",
        "table.whitelist": "authentication_db.user_outbox",
        "topic.prefix": "memorio",
        "database.useSSL": "false",
        "schema.history.internal.kafka.topic": "schema-changes",
        "database.hostname": "mysql",
        "database.password": "123456",
        "name": "auth-db-connector",
        "database.whitelist": "authentication_db"
    }
}'

post_db_connector_config='{
    "name": "post-db-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "database.allowPublicKeyRetrieval": "true",
        "database.user": "connector_user",
        "database.server.id": "2",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "schema-changes.postdb_test",
        "database.server.name": "memorio_db",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "database.port": "3306",
        "table.whitelist": "postdb_test.post_outbox",
        "topic.prefix": "memorio",
        "database.useSSL": "false",
        "schema.history.internal.kafka.topic": "schema-changes",
        "database.hostname": "mysql",
        "database.password": "123456",
        "name": "post-db-connector",
        "database.whitelist": "postdb_test"
    }
}'

# Loop through the connectors and create/update each one
create_connector "public-album-db-connector" "$public_album_db_connector_config"
create_connector "private-album-db-connector" "$private_album_db_connector_config"
create_connector "auth-db-connector" "$auth_db_connector_config"
create_connector "post-db-connector" "$post_db_connector_config"
