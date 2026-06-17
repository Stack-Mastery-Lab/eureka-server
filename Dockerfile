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

# Punto de entrada
ENTRYPOINT ["java", "-jar", "app.jar"]
