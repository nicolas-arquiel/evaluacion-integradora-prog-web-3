<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Sistema de Turnos Medicos - Inicio</title>
            <jsp:include page="/WEB-INF/includes/header.jsp" />
            <link rel="stylesheet" href="/css/inicio.css">
        </head>

        <body>

            <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

            <div class="content">

                <h1>Te damos la bienvenida al sistema de turnos medicos de Salud Total</h1>

                <p class="intro-text">
                    Desde este panel podes ver un resumen rapido de los turnos proximos.
                </p>

                <h2 class="titulo-seccion">Proximos turnos</h2>

                <c:choose>

                    <c:when test="${empty turnos}">
                        <p class="sin-turnos">No hay turnos proximos.</p>
                    </c:when>

                    <c:otherwise>

                        <div class="turnos-container">

                            <c:forEach var="t" items="${turnos}">
                                <div class="turno-card">

                                    <h3 class="turno-paciente">
                                        <i class="fas fa-user"></i>
                                        <strong>Paciente:</strong> ${t.nombrePaciente}
                                    </h3>

                                    <p class="turno-detalle">
                                        <i class="fas fa-user-md"></i>
                                        <strong>Medico:</strong> ${t.nombreMedico}
                                    </p>

                                    <p class="turno-detalle">
                                        <i class="fas fa-calendar-alt"></i> ${t.fecha}
                                        
                                        <i class="fas fa-clock"></i> ${t.hora}
                                    </p>

                                    <p class="turno-notas" title="${t.notas}">
                                        <strong>Nota:</strong> ${t.notas}
                                    </p>

                                    <span class="estado estado-${t.estadoNombre.toLowerCase()}">
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