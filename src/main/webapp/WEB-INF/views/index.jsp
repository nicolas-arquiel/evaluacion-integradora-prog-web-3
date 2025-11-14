<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Sistema de Turnos Médicos</title>

            <style>
                body {
                    margin: 0;
                    display: flex;
                    font-family: Arial, sans-serif;
                    background: #f5f5f5;
                }

                /* === SIDEBAR === */
                body {
                    margin: 0;
                    display: flex;
                    font-family: Arial;
                    background: #f4f4f4;
                }

                .sidebar {
                    width: 220px;
                    background: #2d3e50;
                    color: white;
                    padding: 15px;
                    height: 100vh;
                }

                .sidebar a {
                    color: white;
                    padding: 10px;
                    display: block;
                    text-decoration: none;
                    border-radius: 4px;
                }

                .sidebar a:hover,
                .active {
                    background: #f1cc31;
                    color: black !important;
                    font-weight: bold;
                }

                .content {
                    flex: 1;
                    padding: 25px;
                }

                h1 {
                    margin-top: 0;
                }

                /* === TARJETAS DE TURNOS === */
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

                .estado-activo {
                    background: #2e8bff;
                    color: white;
                }

                .estado-reprogramado {
                    background: #ff9800;
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

            <!-- ==============================
     SIDEBAR
================================= -->
            <div class="sidebar">
                <h2>Salud Total</h2>

                <a class="active" href="${pageContext.request.contextPath}/">🏠 Inicio</a>
                <a href="${pageContext.request.contextPath}/medicos">👨‍⚕️ Médicos</a>
                <a href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>
                <a href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>
                <a href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
                <a href="${pageContext.request.contextPath}/reportes">📊 Reportes</a>

            </div>


            <!-- ==============================
     CONTENIDO PRINCIPAL
================================= -->
            <div class="content">

                <h1>Bienvenido al Sistema de Turnos Médicos</h1>
                <p>Seleccione una opción del menú para comenzar.</p>

                <h2>Próximos Turnos</h2>

                <!-- Si no mandaste turnos al index aún, evitamos error -->
                <c:if test="${empty turnos}">
                    <p>No hay turnos cargados aún.</p>
                </c:if>

                <div class="turnos-container">
                    <c:forEach var="t" items="${turnos}">
                        <div class="turno-card">

                            <h3>${t.nombrePaciente}</h3>
                            <small>👨‍⚕️ ${t.nombreMedico}</small><br>
                            <small>📅 ${t.fecha} — 🕒 ${t.hora}</small>

                            <br><br>

                            <!-- BADGE DEL ESTADO -->
                            <c:choose>
                                <c:when test="${t.estadoNombre == 'activo'}">
                                    <span class="estado estado-activo">🟦 Activo</span>
                                </c:when>
                                <c:when test="${t.estadoNombre == 'reprogramado'}">
                                    <span class="estado estado-reprogramado">🟧 Reprogramado</span>
                                </c:when>
                                <c:when test="${t.estadoNombre == 'completado'}">
                                    <span class="estado estado-completado">🟩 Completado</span>
                                </c:when>
                                <c:when test="${t.estadoNombre == 'cancelado'}">
                                    <span class="estado estado-cancelado">🟥 Cancelado</span>
                                </c:when>
                            </c:choose>



                        </div>
                    </c:forEach>
                </div>

            </div>

        </body>

        </html>