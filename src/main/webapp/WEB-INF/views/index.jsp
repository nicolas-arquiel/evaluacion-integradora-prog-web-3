<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Sistema de Turnos Médicos - Salud Total</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/home.css">

    <style>
        /* === ESTILOS ESPECÍFICOS DEL INDEX === */
        .turnos-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .turno-card {
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.15);
        }

        .turno-card h3 {
            margin: 0 0 8px 0;
            font-size: 18px;
        }

        .turno-card small {
            color: #555;
        }

        /* ESTADOS */
        .estado {
            padding: 5px 8px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: bold;
            display: inline-block;
        }

        .estado-programado {
            background: #2e8bff;
            color: white;
        }

        .estado-completado {
            background: #4caf50;
            color: white;
        }

        .estado-cancelado {
            background: #d32f2f;
            color: white;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Salud Total</h2>
    <a class="active" href="/app/">🏠 Inicio</a>
    <a href="/app/medicos">👨‍⚕️ Médicos</a>
    <a href="/app/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="/app/obras-sociales">🏥 Obras Sociales</a>
    <a href="/app/turnos">📅 Turnos</a>
    <a href="/app/reportes">📊 Reportes</a>
</div>

<!-- CONTENIDO PRINCIPAL -->
<div class="content">

    <h1>Bienvenido al Sistema de Turnos Médicos</h1>
    <p>Seleccione una opción del menú para comenzar.</p>

    <h2>Próximos Turnos</h2>

    <c:choose>
        <c:when test="${empty turnos}">
            <div class="empty-state">
                <div class="icon">📅</div>
                <h3>No hay turnos programados</h3>
                <p>Comience creando un nuevo turno desde el módulo de Turnos</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="turnos-container">
                <c:forEach var="t" items="${turnos}">
                    <div class="turno-card">
                        <h3>${t.nombrePaciente}</h3>
                        <small>👨‍⚕️ ${t.nombreMedico}</small><br>
                        <small>📅 ${t.fecha} — 🕒 ${t.hora}</small>

                        <br><br>

                        <!-- BADGE DEL ESTADO -->
                        <c:choose>
                            <c:when test="${t.estadoNombre == 'programado'}">
                                <span class="estado estado-programado">Programado</span>
                            </c:when>
                            <c:when test="${t.estadoNombre == 'completado'}">
                                <span class="estado estado-completado">Completado</span>
                            </c:when>
                            <c:when test="${t.estadoNombre == 'cancelado'}">
                                <span class="estado estado-cancelado">Cancelado</span>
                            </c:when>
                            <c:otherwise>
                                <span class="estado estado-programado">${t.estadoNombre}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>