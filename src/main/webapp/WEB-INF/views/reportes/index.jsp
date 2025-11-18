<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Reportes y Estadísticas - Salud Total</title>
            <jsp:include page="/WEB-INF/includes/header.jsp" />
            <link rel="stylesheet" href="/css/reportes.css">
            <script src="/js/reportes.js"></script>
        </head>

        <body>

            <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

            <div class="content">

                <h2><i class="fas fa-chart-bar"></i> Reportes</h2>
                <p class="reporte-subtitulo">
                    Seleccione un tipo de reporte para ver la información
                </p>

                <div class="report-cards">

                    <div class="report-card" onclick="mostrarReporte('turnos-medico')" id="card-turnos-medico">
                        <div class="icon"><i class="fas fa-user-md"></i></div>
                        <h3>Turnos por Médico</h3>
                        <p>Cantidad de turnos atendidos por médico</p>
                    </div>

                    <div class="report-card" onclick="mostrarReporte('turnos-especialidad')"
                        id="card-turnos-especialidad">
                        <div class="icon"><i class="fas fa-stethoscope"></i></div>
                        <h3>Turnos por Especialidad</h3>
                        <p>Distribución por especialidad médica</p>
                    </div>

                    <div class="report-card" onclick="mostrarReporte('turnos-obra-social')"
                        id="card-turnos-obra-social">
                        <div class="icon"><i class="fas fa-id-card"></i></div>
                        <h3>Turnos por Obra Social</h3>
                        <p>Cantidad de turnos según obra social</p>
                    </div>

                    <div class="report-card" onclick="mostrarReporte('estados-turnos')" id="card-estados-turnos">
                        <div class="icon"><i class="fas fa-list-check"></i></div>
                        <h3>Estados de Turnos</h3>
                        <p>Programados, completados y cancelados</p>
                    </div>

                    <div class="report-card" onclick="mostrarReporte('turnos-mes')" id="card-turnos-mes">
                        <div class="icon"><i class="fas fa-calendar-alt"></i></div>
                        <h3>Turnos por Mes</h3>
                        <p>Evolución mensual</p>
                    </div>

                    <div class="report-card" onclick="mostrarReporte('turnos-vencidos')" id="card-turnos-vencidos">
                        <div class="icon"><i class="fas fa-exclamation-triangle"></i></div>
                        <h3>Turnos Vencidos</h3>
                        <p>Turnos ya pasados pero aún programados</p>
                    </div>


                </div>


                <div class="report-section active" id="report-inicial">
                    <div class="empty-state">
                        <div class="icon"><i class="fas fa-chart-bar"></i></div>
                        <h3>Seleccione un reporte</h3>
                        <p>Haga clic en una tarjeta para ver los datos</p>
                    </div>
                </div>


                <div class="report-section" id="report-turnos-medico">
                    <h2><i class="fas fa-user-md"></i> Turnos por Médico</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Médico</th>
                                <th>Especialidad</th>
                                <th>Programados</th>
                                <th>Completados</th>
                                <th>Cancelados</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reporteTurnosMedico}">
                                <tr>
                                    <td>${r.nombreMedico}</td>
                                    <td>${r.especialidad}</td>
                                    <td>${r.programados}</td>
                                    <td>${r.completados}</td>
                                    <td>${r.cancelados}</td>
                                    <td><strong>${r.total}</strong></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


                <div class="report-section" id="report-turnos-especialidad">
                    <h2><i class="fas fa-stethoscope"></i> Turnos por Especialidad</h2>

                    <table>
                        <thead>
                            <tr>
                                <th>Especialidad</th>
                                <th>Cantidad</th>
                                <th>%</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reporteTurnosEspecialidad}">
                                <tr>
                                    <td>${r.especialidad}</td>
                                    <td><strong>${r.cantidad}</strong></td>
                                    <td>${r.porcentaje}%</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


                <div class="report-section" id="report-turnos-obra-social">
                    <h2><i class="fas fa-id-card"></i> Turnos por Obra Social</h2>

                    <table>
                        <thead>
                            <tr>
                                <th>Obra Social</th>
                                <th>Pacientes</th>
                                <th>Turnos</th>
                                <th>Promedio</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reporteTurnosObraSocial}">
                                <tr>
                                    <td>${r.obraSocial}</td>
                                    <td>${r.cantidadPacientes}</td>
                                    <td><strong>${r.cantidadTurnos}</strong></td>
                                    <td>${r.promedio}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


                <div class="report-section" id="report-estados-turnos">
                    <h2><i class="fas fa-list-check"></i> Estados de Turnos</h2>

                    <table>
                        <thead>
                            <tr>
                                <th>Estado</th>
                                <th>Cantidad</th>
                                <th>%</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reporteEstados}">
                                <tr>
                                    <td>${r.estado}</td>
                                    <td><strong>${r.cantidad}</strong></td>
                                    <td>${r.porcentaje}%</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


                <div class="report-section" id="report-turnos-mes">
                    <h2><i class="fas fa-calendar-alt"></i> Turnos por Mes</h2>

                    <table>
                        <thead>
                            <tr>
                                <th>Mes</th>
                                <th>Año</th>
                                <th>Programados</th>
                                <th>Completados</th>
                                <th>Cancelados</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reporteTurnosMes}">
                                <tr>
                                    <td>${r.mes}</td>
                                    <td>${r.anio}</td>
                                    <td>${r.programados}</td>
                                    <td>${r.completados}</td>
                                    <td>${r.cancelados}</td>
                                    <td><strong>${r.total}</strong></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


                <div class="report-section" id="report-turnos-vencidos">
                    <h2><i class="fas fa-exclamation-triangle"></i> Turnos Vencidos sin Estado</h2>

                    <p>
                        Estos turnos ya pasaron según fecha y hora, pero aún siguen en estado
                        <strong>programado</strong>.
                    </p>

                    <table>
                        <thead>
                            <tr>
                                <th>Paciente</th>
                                <th>Médico</th>
                                <th>Especialidad</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Estado Actual</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reporteTurnosVencidos}">
                                <tr>
                                    <td>${r.paciente}</td>
                                    <td>${r.medico}</td>
                                    <td>${r.especialidad}</td>
                                    <td>${r.fecha}</td>
                                    <td>${r.hora}</td>
                                    <td><strong>${r.estado}</strong></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


            </div>
        </body>

        </html>