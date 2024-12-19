# Use an OpenJDK base image for the backend
FROM openjdk:17-jdk-slim AS build

# Install Maven (you could also use a separate image that has Maven installed)
RUN apt-get update && apt-get install -y maven

# Set the working directory
WORKDIR /app

# Copy the Maven project files into the container
COPY pom.xml .
COPY src ./src

# Build the project with Maven
RUN mvn clean package -DskipTests

# Now create the final image based on the compiled JAR file
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/roundtable-0.0.1-SNAPSHOT.jar /app/roundtable-0.0.1-SNAPSHOT.jar

# Expose the port the app runs on
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/roundtable-0.0.1-SNAPSHOT.jar"]
