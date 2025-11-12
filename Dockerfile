# Etapa 1: Compilar el WAR con Gradle
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src
RUN chmod +x gradlew
RUN ./gradlew clean war

# Etapa 2: Ejecutar con Payara Full (Jakarta EE 10 compatible)
FROM payara/server-full:6.2024.4-jdk17

# Argumento y variable de entorno para puerto
ARG APP_PORT=8087
ENV APP_PORT=${APP_PORT}

# Copiar WAR compilado al directorio de despliegue de Payara
COPY --from=build /app/build/libs/*.war $DEPLOY_DIR

# Exponer el puerto definido
EXPOSE ${APP_PORT}

# Ejecutar Payara
CMD ["--deploymentDir", "/opt/payara/deployments"]
