# Etapa 1: Compilar el WAR con Gradle
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src

RUN chmod +x gradlew
RUN ./gradlew clean war

# Etapa 2: Payara Full Server
FROM payara/server-full:6.2024.4-jdk17

ENV DEPLOY_DIR=/opt/payara/deployments

# Copiar el WAR al directorio de despliegue
# (puedes dejar el nombre original o ROOT.war, ahora lo vemos)
COPY --from=build /app/build/libs/*.war /opt/payara/deployments/ROOT.war

EXPOSE 8080

# ❌ NO sobreescribas el CMD, usa el de la imagen
# (opcionalmente, si quisieras, podrías hacer:)
# CMD ["start-domain", "--verbose"]
