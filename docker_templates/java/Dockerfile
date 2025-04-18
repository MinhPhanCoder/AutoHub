FROM eclipse-temurin:17-jdk-jammy as builder

WORKDIR /app

# Copy Maven configuration
COPY pom.xml .
COPY src ./src

# Build application
RUN ./mvnw package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-jammy

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy built artifact from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Set permissions
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

EXPOSE 8080

# Run with security options
CMD ["java", \
     "-Djava.security.egd=file:/dev/./urandom", \
     "-Dserver.port=8080", \
     "-jar", "app.jar"]