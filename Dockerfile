# --- Stage 1: Build the JAR ---
# We use a Maven image to build your app from source code
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
# This command compiles your code and packages it into a JAR file
RUN mvn clean package -DskipTests

# --- Stage 2: Create the Final Image ---
# We use a lightweight Java Runtime (JRE) for the actual app
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# We copy only the JAR file from Stage 1 to Stage 2
COPY --from=build /app/target/*.jar app.jar

# This is the port your app runs on inside the container
EXPOSE 8080

# The command to start your app
ENTRYPOINT ["java", "-jar", "app.jar"]