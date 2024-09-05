# Step 1: Use an official JDK runtime as a parent image
FROM openjdk:17-jdk-alpine

# Step 2: Set the working directory inside the container
ARG JAR_FILE=target/*.jar
# Step 3: Copy the JAR file from the target directory to the container
# Assuming the jar file will be named service-a.jar after the build
COPY ./target/api-gateway-1.0-SNAPSHOT.jar app.jar

# Step 5: Command to run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]