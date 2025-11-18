<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <html>

            <head>
                <title>Gestión de Turnos - Salud Total</title>

                <jsp:include page="/WEB-INF/includes/header.jsp" />
                <link rel="stylesheet" href="/css/turnos.css">
                <script src="/js/turnos.js"></script>
            </head>

            <body>

                <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

                <div class="content" data-medicos='[
        <c:forEach var="m" items="${medicos}" varStatus="status">
            {"id":${m.id},"nombre":"${m.nombre}","especialidad":"${m.especialidadDescripcion}","obras":[${m.obrasSocialesIdsCsv}]}
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ]' data-pacientes='[
        <c:forEach var="p" items="${pacientes}" varStatus="status">
            {"id":${p.id},"nombre":"${p.nombre}","obraSocialId":${p.obraSocialId},"obraSocialNombre":"${p.obraSocialNombre}"}
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ]'>


                    <h2><i class="fas fa-calendar-alt"></i> Gestión de Turnos</h2>

                    <div class="info-box">
                        <p>
                            <i class="fas fa-info-circle"></i>
                            <strong>Horarios de atención:</strong> Lunes a Viernes de 8:00 a 17:45 hs.
                            La clínica no atiende fines de semana.
                        </p>
                    </div>

                    <button class="btn btn-primary" onclick="abrirNuevo()">
                        <i class="fas fa-plus"></i> Agendar Nuevo Turno
                    </button>

                    <br><br>

                    <form id="formFiltros" method="get" class="filtros">

                        <div class="fila-filtros">

                            <select name="idMedico">
                                <option value="">-- Todos los médicos --</option>
                                <c:forEach var="m" items="${medicos}">
                                    <option value="${m.id}">
                                        ${m.nombre} (${m.especialidadDescripcion})
                                    </option>
                                </c:forEach>
                            </select>

                            <input type="date" name="desde">
                            <input type="date" name="hasta">

                            <label class="chk"><input type="checkbox" name="estado" value="1"> Programado</label>
                            <label class="chk"><input type="checkbox" name="estado" value="2"> Cancelado</label>
                            <label class="chk"><input type="checkbox" name="estado" value="3"> Completado</label>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> Filtrar Agenda
                            </button>

                            <button type="button" id="btnLimpiarFiltros" class="btn btn-secondary"
                                style="display:none;">
                                <i class="fas fa-undo"></i> Limpiar Filtros
                            </button>

                        </div>
                    </form>




                    <table class="turnos-table">
                        <tr>
                            <th>ID</th>
                            <th>Paciente</th>
                            <th>Médico</th>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>

                        <c:forEach var="t" items="${turnos}">
                            <tr>
                                <td>${t.id}</td>
                                <td>${t.nombrePaciente}</td>
                                <td>${t.nombreMedico}</td>
                                <td>${t.fecha}</td>
                                <td>${t.hora}</td>

                                <td>
                                    <span class="estado estado-${t.estadoNombre.toLowerCase()}">
                                        <i class="fas 
                        <c:choose>
                            <c:when test=" ${t.estadoNombre.toLowerCase()=='programado' }">fa-clock</c:when>
                                            <c:when test="${t.estadoNombre.toLowerCase()=='cancelado'}">fa-times-circle
                                            </c:when>
                                            <c:when test="${t.estadoNombre.toLowerCase()=='completado'}">fa-check-circle
                                            </c:when>
                                            <c:otherwise>fa-question-circle</c:otherwise>
                                            </c:choose>">
                                        </i>
                                        ${t.estadoNombre}
                                    </span>
                                </td>

                                <td>
                                    <c:if test="${t.estadoId == 1}">
                                        <button class="btn btn-primary btn-editar" data-id="${t.id}"
                                            data-pacienteid="${t.pacienteId}" data-medicoid="${t.medicoId}"
                                            data-fecha="${t.fecha}" data-hora="${t.hora}"
                                            data-obrasocialid="${t.obraSocialId}" data-notas="${t.notas}">
                                            <i class="fas fa-edit"></i> Modificar
                                        </button>

                                        <button class="btn btn-success" onclick="completarTurno('${t.id}')">
                                            <i class="fas fa-check"></i> Completar
                                        </button>

                                        <button class="btn btn-danger" onclick="cancelarTurno('${t.id}')">
                                            <i class="fas fa-ban"></i> Cancelar
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>

                </div>

                <!-- MODAL -->
                <dialog id="modalForm">
                    <h3 id="modalTitle"></h3>

                    <form method="post" action="/app/turnos">
                        <input type="hidden" name="id" id="form-id">

                        <label><i class="fas fa-user"></i> Paciente:</label>
                        <select id="paciente" name="pacienteId" onchange="onPacienteChange()" required>
                            <option value="">-- Seleccionar paciente --</option>
                            <c:forEach var="p" items="${pacientes}">
                                <option value="${p.id}" data-obrasocialid="${p.obraSocialId}"
                                    data-obrasocialnombre="${p.obraSocialNombre}">
                                    ${p.nombre}
                                </option>
                            </c:forEach>
                        </select>

                        <br><br>

                        <label><i class="fas fa-hospital"></i> Cobertura Médica:</label>
                        <input type="text" id="obra-social-display" readonly class="readonly-field">

                        <br><br>

                        <label><i class="fas fa-user-md"></i> Médico Tratante:</label>
                        <select id="medico" name="medicoId" required>
                            <option value="">-- Primero seleccione el paciente --</option>
                        </select>

                        <br><br>

                        <label><i class="fas fa-calendar"></i> Fecha del Turno:</label>
                        <input type="date" id="fecha" name="fecha" required>

                        <br><br>

                        <label><i class="fas fa-clock"></i> Hora del Turno:</label>
                        <input type="time" id="hora" name="hora" required min="08:00" max="17:45" step="900">

                        <input type="hidden" id="estadoId" name="estadoId" value="1">

                        <br><br>

                        <label><i class="fas fa-sticky-note"></i> Observaciones:</label>
                        <textarea id="notas" name="notas" style="height:60px;"></textarea>

                        <br><br>

                        <button class="btn btn-primary" type="submit"><i class="fas fa-save"></i> Confirmar
                            Turno</button>
                        <button type="button" class="btn" onclick="modalForm.close()">
                            <i class="fas fa-times"></i> Cancelar
                        </button>
                    </form>
                </dialog>

                <jsp:include page="/WEB-INF/includes/alerts.jsp" />

            </body>

            </html>