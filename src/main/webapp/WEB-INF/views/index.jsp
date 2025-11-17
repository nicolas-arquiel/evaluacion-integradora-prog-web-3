<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Sistema de Turnos Médicos - Inicio</title>

    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <link rel="stylesheet" href="/css/home.css">
</head>

<body>

<!-- SIDEBAR -->
<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<!-- CONTENIDO -->
<div class="content">

    <h1>Bienvenido/a al Sistema de Turnos Médicos</h1>

    <p class="intro-text">
        Desde este panel podés ver un resumen rápido de los turnos próximos.
    </p>

    <h2 class="titulo-seccion">
        Próximos turnos
    </h2>

    <c:choose>

        <c:when test="${empty turnos}">
            <p class="sin-turnos">No hay turnos próximos.</p>
        </c:when>

        <c:otherwise>

            <div class="turnos-container">

                <c:forEach var="t" items="${turnos}">
                    <div class="turno-card">

                        <h3 class="turno-paciente">
                            <i class="fas fa-user"></i> ${t.nombrePaciente}
                        </h3>

                        <p class="turno-detalle">
                            <i class="fas fa-user-md"></i> ${t.nombreMedico}
                        </p>

                        <p class="turno-detalle">
                            <i class="fas fa-calendar-alt"></i> ${t.fecha}
                            &nbsp;&nbsp;
                            <i class="fas fa-clock"></i> ${t.hora}
                        </p>

                        <span class="estado ${t.estadoNombre}">
                            ${t.estadoNombre}
                        </span>

                    </div>
                </c:forEach>

            </div>

        </c:otherwise>

    </c:choose>

</div>

</body>
</html>
