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
#!/bin/bash
set -e

echo "🧹 Limpiando contenedores y volúmenes anteriores..."
docker compose down -v

echo "🧱 Compilando WAR con Gradle..."
./gradlew clean war

echo "📦 Verificando que el WAR se generó correctamente..."
if [ -f "build/libs/turnos_medicos.war" ]; then
    echo "✅ WAR generado: build/libs/turnos_medicos.war"
    ls -lh build/libs/turnos_medicos.war
else
    echo "❌ Error: No se pudo generar el WAR"
    exit 1
fi

echo "🐳 Reconstruyendo imágenes sin caché..."
docker compose build --no-cache

echo "🚀 Levantando contenedores..."
docker compose up -d

echo ""
echo "🎉 ¡Despliegue completado!"
echo ""
echo "📋 URLs disponibles:"
echo "   🏥 Aplicación principal: http://localhost:8080"
echo "   📊 Estado de la app:     http://localhost:8080/app/status"
echo "   🗄️  Adminer (DB):        http://localhost:8088"
echo ""
echo "📝 Para ver logs en tiempo real:"
echo "   docker compose logs -f turnos_medicos_app"
echo ""
echo "🔍 Para verificar el estado:"
echo "   docker compose ps"