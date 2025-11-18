#!/bin/bash
set -e

echo "Deteniendo contenedores previos..."
docker compose down -v

echo "Compilando el archivo WAR..."
./gradlew clean war

echo "Verificando la generacion del WAR..."
if [ -f "build/libs/turnos_medicos.war" ]; then
    echo "WAR generado correctamente: build/libs/turnos_medicos.war"
else
    echo "Error: no se genero el WAR"
    exit 1
fi

echo "Construyendo imagenes..."
docker compose build --no-cache

echo "Iniciando contenedores..."
docker compose up -d

echo "Despliegue completado."
