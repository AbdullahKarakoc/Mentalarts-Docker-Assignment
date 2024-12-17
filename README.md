# Go Translation Service - Docker Containerization

This project focuses on containerizing and optimizing a Go web service built with the **Gin-Gonic** framework. The web service provides a translation API to convert Turkish words to English, with additional endpoints for basic health checks and greetings.

The primary goal of the project is to explore **Docker containerization principles**, compare image sizes, and optimize container images using **multi-stage builds**. Furthermore, a bonus challenge enhances the translation service with bidirectional translation and intelligent language detection.

---

## Table of Contents
- [Features](#features)
- [Project Overview](#project-overview)
- [Setup Instructions](#setup-instructions)
- [Deliverables](#deliverables)
- [Evaluation Criteria](#evaluation-criteria)
- [Bonus Challenge](#bonus-challenge)
- [Results and Comparisons](#results-and-comparisons)

---

## Features
1. **Translation Service**: Translates Turkish words to English.
2. **Health Check Endpoint**: Provides service health status.
3. **Greeting Endpoint**: Returns a simple greeting message.
4. **Optimized Docker Images**:
   - Normal Dockerfile implementation.
   - Multi-stage Dockerfile implementation for reduced image size.
5. **Bonus**: Bidirectional translation with language detection.

---

## Project Overview
The project includes the following steps:
1. **Analyze**: Understand the Go web service requirements and dependencies.
2. **Basic Dockerization**: Containerize the service using a single-stage Dockerfile.
3. **Optimization**: Implement a multi-stage Dockerfile to reduce image size.
4. **Comparison**: Compare the image sizes of both versions.
5. **Testing**: Deploy the service using `docker-compose` and verify its functionality.
6. **Bonus Challenge**: Add intelligent bidirectional translation support.

---

## Setup Instructions

### Prerequisites
Ensure the following tools are installed:
- **Go** (latest version)
- **Docker** & **Docker Compose**

### Project Structure
```plaintext
project-root/
|-- main.go                     # Go web service code
|-- Dockerfile                  # Basic Dockerfile
|-- Dockerfile.multi            # Optimized multi-stage Dockerfile
|-- docker-compose.yml          # Docker Compose configuration
|-- README.md                   # Documentation
```

### Build and Run the Service

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd project-root
   ```

2. **Build and Run with Docker Compose**:
   ```bash
   docker-compose up -d --build
   ```

3. **Verify the Service**:
   - Health Check: `http://localhost:8080/ping`
   - Greeting: `http://localhost:8080/greet`
   - Translation: `http://localhost:8080/translate/:word`

4. **Stop the Service**:
   ```bash
   docker-compose down
   ```

---

## Deliverables

1. **Two Dockerfile Implementations**:
   - **Dockerfile (Normal Build):**
     ```dockerfile
     FROM golang:latest
     WORKDIR /app
     COPY . .
     RUN go build -o main .
     CMD ["./main"]
     ```

   - **Dockerfile.multi (Multi-Stage Build):**
     ```dockerfile
     # Stage 1: Build the application
     FROM golang:latest AS builder
     WORKDIR /app
     COPY . .
     RUN go build -o main .
     
     # Stage 2: Run the application
     FROM alpine:latest
     WORKDIR /root/
     COPY --from=builder /app/main .
     CMD ["./main"]
     ```

2. **Docker Compose Configuration**:
   ```yaml
   services:
     translate-service:
       build:
         context: .
         dockerfile: Dockerfile.multi
       image: multi-stage-translate-service
       ports:
         - "8080:8080"
       restart: always
       healthcheck:
         test: ["CMD", "curl", "-f", "http://localhost:8080/ping"]
         interval: 30s
         timeout: 10s
         retries: 5
   ```

3. **Image Size Comparison**:
   - **Normal Build Image**: ~1.2 GB
   - **Multi-Stage Build Image**: ~32 MB

4. **Test Results**:
   - All endpoints verified:
     - `/ping`: Health check ✅
     - `/greet`: Greeting message ✅
     - `/translate/:word`: Translation ✅

---

## Evaluation Criteria
1. **Correct Configuration of Dockerfiles and docker-compose.yml** (40 points)
2. **Optimization Achieved Through Multi-Stage Builds** (30 points)
3. **Proper Functioning of the Service** (20 points)
4. **Documentation and Explanations** (10 points)

---

## Bonus Challenge

### Bidirectional Translation with Language Detection
The translation service has been enhanced to support **bidirectional translation** (Turkish ↔ English) using the same endpoint.

### Endpoint: `/translate/:word`
**Example Requests and Responses**:

1. **Input**: `http://localhost:8080/translate/merhaba`
   **Response**:
   ```json
   {
     "translated": "hello",
     "source_language": "tr"
   }
   ```

2. **Input**: `http://localhost:8080/translate/hello`
   **Response**:
   ```json
   {
     "translated": "merhaba",
     "source_language": "en"
   }
   ```

### Features:
- **Intelligent Language Detection**: Automatically determines the source language.
- **Dynamic Translation**: Translates words in both directions.
- **Edge Case Handling**: Ensures proper handling of unknown words.

---

## Results and Comparisons
| **Implementation**       | **Image Size** |
|--------------------------|---------------|
| Normal Build             | 1.22 GB       |
| Multi-Stage Build        | 31.9 MB       |

### Key Takeaways:
- Multi-stage builds significantly reduce image size by eliminating unnecessary dependencies.
- Optimized images improve performance and resource utilization, which is crucial for modern deployments.

---

## Conclusion
This project demonstrates the practical use of Docker to containerize and optimize a Go web service. By implementing multi-stage builds and exploring advanced enhancements like bidirectional translation, the project highlights industry best practices for efficient software deployment.
