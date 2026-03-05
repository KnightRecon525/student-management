# ── Stage 1: Build ──────────────────────────────────────────
# Use an official Maven image that already has Java 21 inside
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Set a working directory inside the container
WORKDIR /app

# Copy the pom.xml first (so Docker can cache dependencies)
COPY pom.xml .

# Download all dependencies (this layer gets cached if pom.xml didn't change)
RUN mvn dependency:go-offline -B

# Now copy the rest of your source code
COPY src ./src

# Build the project and produce the JAR file (skip tests to go faster)
RUN mvn clean package -DskipTests

# ── Stage 2: Run ────────────────────────────────────────────
# Use a lightweight Java 21 image just for running (no Maven needed)
FROM eclipse-temurin:21-jre-alpine

# Set working directory
WORKDIR /app

# Copy ONLY the built JAR from Stage 1 into this smaller image
COPY --from=builder /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Tell Docker your app listens on port 8089 (matches your application.properties)
EXPOSE 8089

# The command to run when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]