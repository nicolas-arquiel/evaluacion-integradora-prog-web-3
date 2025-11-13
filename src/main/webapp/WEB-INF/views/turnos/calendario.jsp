<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Calendario Semanal</title>

    <style>
        body {
            margin: 0;
            display: flex;
            font-family: Arial;
            background: #f5f5f5;
        }

        .sidebar {
            width: 220px;
            background: #2d3e50;
            color: white;
            padding: 15px;
            min-height: 100vh;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            padding: 10px;
            display: block;
            border-radius: 4px;
        }

        .sidebar a:hover {
            background: #f1cc31;
            color: black;
        }

        .content {
            flex: 1;
            padding: 20px;
        }

        h1 { margin-top: 0; }

        /* === CALENDARIO === */
        .calendar {
            display: grid;
            grid-template-columns: 80px repeat(7, 1fr);
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,.1);
        }

        .hour {
            padding: 10px;
            background: #e9ecef;
            border-bottom: 1px solid #ddd;
        }

        .cell {
            min-height: 60px;
            border-bottom: 1px solid #eee;
            border-right: 1px solid #eee;
            position: relative;
        }

        .turno {
            position: absolute;
            left: 5px;
            right: 5px;
            padding: 6px 10px;
            border-radius: 6px;
            color: white;
            font-size: 13px;
            overflow: hidden;
        }

        .activo { background: #2e8bff; }
        .reprogramado { background: #ff9800; }
        .cancelado { background: #d32f2f; }
        .completado { background: #4caf50; }

        .day-header {
            text-align: center;
            padding: 10px;
            background: #2d3e50;
            color: white;
            border-right: 1px solid #222;
        }
    </style>

</head>
<body>

<div class="sidebar">
    <h2>Salud Total</h2>

    <a href="${pageContext.request.contextPath}/">🏠 Inicio</a>
    <a href="${pageContext.request.contextPath}/medicos">👨‍⚕️ Médicos</a>
    <a href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>
    <a href="${pageContext.request.contextPath}/turnos" >📅 Listado Turnos</a>
    <a href="${pageContext.request.contextPath}/turnos/calendario" class="active">🗓 Calendario</a>
</div>


<div class="content">
    <h1>Calendario Semanal de Turnos</h1>

    <!-- CABECERA DÍAS -->
    <div class="calendar">

        <div></div> <!-- celda vacía -->

        <c:forEach var="d" items="${dias}">
            <div class="day-header">${d}</div>
        </c:forEach>

        <!-- HORAS -->
        <c:forEach var="h" items="${horas}">
            <div class="hour">${h}</div>

            <!-- columnas de cada día -->
            <c:forEach var="d" items="${dias}">
                <div class="cell">

                    <c:forEach var="t" items="${turnos}">
                        <c:if test="${t.fecha == mapFechas[d] && t.hora == mapHoras[h]}">
                            <div class="turno ${t.estado}">
                                ${t.nombrePaciente}<br>
                                <small>${t.nombreMedico}</small>
                            </div>
                        </c:if>
                    </c:forEach>

                </div>
            </c:forEach>

        </c:forEach>

    </div>
</div>

</body>
</html>
