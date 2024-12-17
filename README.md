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
mentalarts-docker-assignment/
|-- src/main.go                     # Go web service code
|-- Dockerfile                  # Basic Dockerfile
|-- Dockerfile.multi-stage            # Optimized multi-stage Dockerfile
|-- docker-compose.yml          # Docker Compose configuration
|-- README.md                   # Documentation
```

### Build and Run the Service

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd mentalarts-docker-assignment-root
   ```

2. **Build and Run with Docker Compose**:
   ```bash
   docker-compose up -d --build
   ```

3. **Verify the Service**:
   - Health Check: `http://localhost:8080/ping`
   - Greeting: `http://localhost:8080/greet`
   - Translation: `http://localhost:8080/translate/elma`

4. **Stop the Service**:
   ```bash
   docker-compose down
   ```

---

## Deliverables

1. **Two Dockerfile Implementations**:
   - **Dockerfile (Normal Build):**
     ```dockerfile
      FROM golang:1.23.4
      WORKDIR /app
      COPY src/ .
      
      RUN go mod init example.com/translate && \
          go mod tidy
      RUN go build -o main .
      
      CMD ["./main"]
     ```

   - **Dockerfile.multi (Multi-Stage Build):**
     ```dockerfile
     # Stage 1: Build the application
      FROM golang:1.23.4 AS builder
      WORKDIR /app
      COPY ./src /app
      
      RUN go mod init example.com/translate && \
          go mod tidy && \
          go build -o main . && \
          chmod +x main && \
          ls -la /app
      
      FROM alpine:latest
      
      WORKDIR /root/
      COPY --from=builder /app/main .
      RUN ls -la /root/ && chmod +x /root/main
      
      EXPOSE 8080
      
      CMD ["/root/main"]
     ```

2. **Docker Compose Configuration**:
   ```yml
   version: '3.8'
   
   services:
     translate-service:
       build:
         context: .
       image: multi-stage-translate-service
       ports:
         - "8080:8080"
       networks:
         - app_network
       environment:
         - APP_ENV=production
         - APP_PORT=8080
       restart: always
       healthcheck:
         test: ["CMD", "curl", "-f", "http://localhost:8080/ping"]
         interval: 30s
         timeout: 10s
         retries: 5
       volumes:
         - app_data:/app/data
       depends_on:
         - redis
       logging:
         driver: "json-file"
         options:
           max-size: "10m"
           max-file: "3"
   
     redis:
       image: redis:latest
       restart: always
       ports:
         - "6379:6379"
       networks:
         - app_network
     volumes:
       app_data:
   
     networks:
       app_network:
          driver: bridge
   ```

3. **Image Size Comparison**:
   - **Normal Build Image**: ~1.2 GB
   - **Multi-Stage Build Image**: ~32 MB

4. **Test Results**:
   - All endpoints verified:
     - `/ping`: Health check ✅
     - `/greet`: Greeting message ✅
     - `/translate/:word`: Translation ✅



## Bonus Challenge

-The system works with Turkish vowels such as ö ç i ş ğ ü İ Ö Ğ Ü Ö Ş Ç.

## API Endpoints

1. **Endpoint**: `http://192.168.1.125:8080/hello`  
   ![Ekran görüntüsü 2024-12-17 215252](https://github.com/user-attachments/assets/ac002300-3003-4684-9258-987c7136ce4e)

2. **Endpoint**: `http://192.168.1.125:8080/hello`  
   ![Ekran görüntüsü 2024-12-17 215312](https://github.com/user-attachments/assets/c939461c-a733-4583-980a-d70656e1feaf)

3. **Endpoint**: `http://192.168.1.125:8080/translate/çarşamba`  
   ![Ekran görüntüsü 2024-12-17 215339](https://github.com/user-attachments/assets/5bc33b60-d1da-421d-a631-a65524ccaa43)

## Results and Comparisons
| **Implementation**       | **Image Size** |
|--------------------------|---------------|
| Normal Build             | 1.22 GB       |
| Multi-Stage Build        | 31.9 MB       |

![Ekran görüntüsü 2024-12-17 210646](https://github.com/user-attachments/assets/a9dde113-0059-44dd-baec-f488712cff2c)


### Key Takeaways:
- Multi-stage builds significantly reduce image size by eliminating unnecessary dependencies.
- Optimized images improve performance and resource utilization, which is crucial for modern deployments.

---

## Conclusion
This project demonstrates the practical use of Docker to containerize and optimize a Go web service. By implementing multi-stage builds and exploring advanced enhancements like bidirectional translation, the project highlights industry best practices for efficient software deployment.
