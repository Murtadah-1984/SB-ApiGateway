# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17-slim AS build

# Copy source code to the container
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app

# Set the working directory
WORKDIR /usr/src/app

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime container
FROM openjdk:17-slim

# Copy the JAR file from the build stage
COPY --from=build /usr/src/app/target/*.jar /usr/app/app.jar

# Set the working directory in the container
WORKDIR /usr/app

# Expose the port the app runs on
EXPOSE 8080

# Default application name as an environment variable
ENV APP_NAME="gateway"

# Configuration for a production-ready JVM
ENV JVM_OPTS="-Xmx512m -Xms256m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC -XX:ParallelGCThreads=2"

# Command to run the application
CMD ["java", "$JVM_OPTS", "-jar", "app.jar"]
