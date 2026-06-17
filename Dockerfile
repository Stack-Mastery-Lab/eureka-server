# Stage 1: Build
FROM maven:3.9.12-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copiar JAR desde la etapa de build
COPY --from=build /app/target/eureka-server-0.0.1-SNAPSHOT.jar app.jar

# Puerto que expone Eureka Server
EXPOSE 8761

# Health check para verificar que el servicio está saludable
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8761/eureka/ || exit 1

# Punto de entrada
ENTRYPOINT ["java", "-jar", "app.jar"]
