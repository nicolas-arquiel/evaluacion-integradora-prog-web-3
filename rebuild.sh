#!/bin/bash
set -e

echo "🧹 Limpiando contenedores y volúmenes anteriores..."
docker compose down -v

echo "🧱 Compilando WAR con Gradle..."
./gradlew clean war

echo "🐳 Reconstruyendo imágenes sin caché..."
docker compose build --no-cache

echo "🚀 Levantando contenedores..."
docker compose up
