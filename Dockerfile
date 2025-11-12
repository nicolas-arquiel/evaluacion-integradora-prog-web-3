# Etapa 1: Compilar el WAR con Gradle
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src
RUN chmod +x gradlew
RUN ./gradlew clean war

# Etapa 2: Ejecutar con Tomcat 10
FROM tomcat:10.1-jdk17
ARG APP_PORT=8087
ENV APP_PORT=${APP_PORT}
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/build/libs/app-base.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE ${APP_PORT}
CMD ["catalina.sh", "run"]
