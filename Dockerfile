FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src

RUN chmod +x gradlew
RUN ./gradlew clean war

FROM payara/server-full:6.2024.4-jdk17

ENV DEPLOY_DIR=/opt/payara/deployments

# 🔥 BORRAR todo el deployment previo
RUN rm -rf /opt/payara/appserver/glassfish/domains/domain1/applications/ROOT*

# Copiar nuevo WAR
COPY --from=build /app/build/libs/*.war /opt/payara/deployments/ROOT.war

EXPOSE 8080
