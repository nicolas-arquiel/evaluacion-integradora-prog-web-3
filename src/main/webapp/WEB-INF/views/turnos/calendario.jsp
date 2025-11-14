<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Salud Total - Sistema de Gestión de Turnos</title>

    <style>
        body {
            margin: 0;
            display: flex;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        /* === SIDEBAR === */
        .sidebar {
            width: 220px;
            background: #2d3e50;
            color: white;
            padding: 15px;
            min-height: 100vh;
        }

        .sidebar h2 {
            margin-top: 0;
            font-size: 22px;
        }

        .sidebar a {
            color: white;
            padding: 10px;
            display: block;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 5px;
        }

        .sidebar a:hover,
        .sidebar .active {
            background: #f1cc31;
            color: black !important;
            font-weight: bold;
        }

        /* === CONTENIDO === */
        .content {
            flex: 1;
            padding: 25px;
        }

        h1 {
            margin-top: 0;
            color: #2d3e50;
        }

        .intro {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* === ESTADÍSTICAS === */
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-card h3 {
            margin: 0 0 10px 0;
            font-size: 36px;
            color: #2e8bff;
        }

        .stat-card p {
            margin: 0;
            color: #666;
        }

        /* === CALENDARIO SEMANAL === */
        .calendar-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .calendar-section h2 {
            margin-top: 0;
            color: #2d3e50;
        }

        .calendar {
            display: grid;
            grid-template-columns: 80px repeat(7, 1fr);
            background: white;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #ddd;
        }

        .hour {
            padding: 10px;
            background: #e9ecef;
            border-bottom: 1px solid #ddd;
            border-right: 1px solid #ddd;
            font-weight: bold;
            text-align: center;
        }

        .day-header {
            text-align: center;
            padding: 12px;
            background: #2d3e50;
            color: white;
            border-right: 1px solid #222;
            font-weight: bold;
        }

        .cell {
            min-height: 60px;
            border-bottom: 1px solid #eee;
            border-right: 1px solid #eee;
            position: relative;
            padding: 5px;
        }

        .turno {
            position: absolute;
            left: 5px;
            right: 5px;
            top: 5px;
            padding: 6px 8px;
            border-radius: 6px;
            color: white;
            font-size: 12px;
            overflow: hidden;
            cursor: pointer;
        }

        .turno:hover {
            opacity: 0.9;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* ESTADOS DE TURNO */
        .estado-programado { background: #2e8bff; }
        .estado-cancelado { background: #d32f2f; }
        .estado-completado { background: #4caf50; }

        .empty-calendar {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>

<!-- ==============================
     SIDEBAR
================================= -->
<div class="sidebar">
    <h2>🏥 Salud Total</h2>
    <a class="active" href="${pageContext.request.contextPath}/turnos-medicos">🏠 Inicio</a>
    <a href="${pageContext.request.contextPath}/turnos-medicos/medicos">👨‍⚕️ Médicos</a>
    <a href="${pageContext.request.contextPath}/turnos-medicos/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="${pageContext.request.contextPath}/turnos-medicos/obras-sociales">🏥 Obras Sociales</a>
    <a href="${pageContext.request.contextPath}/turnos-medicos/turnos">📅 Turnos</a>
</div>

<!-- ==============================
     CONTENIDO PRINCIPAL
================================= -->
<div class="content">

    <h1>Sistema de Gestión de Turnos Médicos</h1>

    <div class="intro">
        <p><strong>Clínica Salud Total</strong> - Bienvenido al sistema de gestión de turnos médicos.</p>
        <p>Utilice el menú lateral para gestionar médicos, pacientes, obras sociales y turnos.</p>
    </div>

    <!-- ESTADÍSTICAS -->
    <div class="stats">
        <div class="stat-card">
            <h3>${totalMedicos}</h3>
            <p>Médicos Activos</p>
        </div>
        <div class="stat-card">
            <h3>${totalPacientes}</h3>
            <p>Pacientes Registrados</p>
        </div>
        <div class="stat-card">
            <h3>${turnosHoy}</h3>
            <p>Turnos Hoy</p>
        </div>
        <div class="stat-card">
            <h3>${proximosTurnos}</h3>
            <p>Próximos 7 días</p>
        </div>
    </div>

    <!-- CALENDARIO SEMANAL -->
    <div class="calendar-section">
        <h2>📅 Calendario Semanal de Turnos</h2>

        <c:choose>
            <c:when test="${empty turnos}">
                <div class="empty-calendar">
                    <p>No hay turnos programados para esta semana.</p>
                    <p><a href="${pageContext.request.contextPath}/turnos-medicos/turnos">Crear nuevo turno</a></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="calendar">
                    <!-- Celda vacía superior izquierda -->
                    <div class="hour"></div>

                    <!-- CABECERA DE DÍAS -->
                    <c:forEach var="dia" items="${dias}">
                        <div class="day-header">
                            ${dia}<br>
                            <small style="font-weight:normal; font-size:11px;">${mapFechas[dia]}</small>
                        </div>
                    </c:forEach>

                    <!-- FILAS DE HORAS -->
                    <c:forEach var="hora" items="${horas}">
                        <div class="hour">${hora}</div>

                        <!-- CELDAS DE CADA DÍA -->
                        <c:forEach var="dia" items="${dias}">
                            <div class="cell">
                                <c:forEach var="t" items="${turnos}">
                                    <c:if test="${t.fecha == mapFechas[dia] && t.hora == mapHoras[hora]}">
                                        <div class="turno estado-${t.estadoNombre}" 
                                             title="Paciente: ${t.nombrePaciente} - Médico: ${t.nombreMedico}">
                                            <strong>${t.nombrePaciente}</strong><br>
                                            <small>${t.nombreMedico}</small>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:forEach>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>