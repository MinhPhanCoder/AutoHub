FROM golang:1.20-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev

# Copy go mod files
COPY go.mod .

# Copy source code
COPY app/ .

# Build the application with security flags
RUN CGO_ENABLED=1 go build -trimpath -ldflags="-w -s" -o main .

# Final stage
FROM alpine:latest

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/main .

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Run the application
EXPOSE 8080
CMD ["./main"]