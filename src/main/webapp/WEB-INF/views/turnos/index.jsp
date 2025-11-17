<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Gestión de Turnos - Salud Total</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <link rel="stylesheet" href="/css/turnos.css">   
    <script src="/js/turnos.js"></script>
</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<!-- CONTENIDO -->
<div class="content"
     data-medicos='[<c:forEach var="m" items="${medicos}" varStatus="status">{"id":${m.id},"nombre":"${m.nombre}","especialidad":"${m.especialidadDescripcion}","obras":[${m.obrasSocialesIdsCsv}]}<c:if test="${!status.last}">,</c:if></c:forEach>]'
     data-pacientes='[<c:forEach var="p" items="${pacientes}" varStatus="status">{"id":${p.id},"nombre":"${p.nombre}","obraSocialId":${p.obraSocialId},"obraSocialNombre":"${p.obraSocialNombre}"}<c:if test="${!status.last}">,</c:if></c:forEach>]'>

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

    <!-- FILTROS -->
    <form method="get" class="filtros">
        <select name="idMedico">
            <option value="">-- Todos los médicos --</option>
            <c:forEach var="m" items="${medicos}">
                <option value="${m.id}">${m.nombre} (${m.especialidadDescripcion})</option>
            </c:forEach>
        </select>

        <input type="date" name="desde">
        <input type="date" name="hasta">

        <button class="btn btn-primary" type="submit">
            <i class="fas fa-filter"></i> Filtrar Agenda
        </button>
    </form>

    <!-- LISTADO -->
    <table>
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
                    <c:choose>
                        <c:when test="${t.estadoNombre == 'programado' || t.estadoNombre == 'Programado'}">
                            <span class="estado estado-programado">
                                <i class="fas fa-clock estado-icon"></i> ${t.estadoNombre}
                            </span>
                        </c:when>

                        <c:when test="${t.estadoNombre == 'cancelado' || t.estadoNombre == 'Cancelado'}">
                            <span class="estado estado-cancelado">
                                <i class="fas fa-times-circle estado-icon"></i> ${t.estadoNombre}
                            </span>
                        </c:when>

                        <c:when test="${t.estadoNombre == 'completado' || t.estadoNombre == 'Completado'}">
                            <span class="estado estado-completado">
                                <i class="fas fa-check-circle estado-icon"></i> ${t.estadoNombre}
                            </span>
                        </c:when>

                        <c:otherwise>
                            <span class="estado estado-desconocido">
                                <i class="fas fa-question-circle estado-icon"></i> ${t.estadoNombre}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td>
                    <!-- Solo mostrar acciones si está programado -->
                    <c:if test="${t.estadoId == 1}">
                        <button class="btn btn-primary btn-editar"
                                data-id="${t.id}"
                                data-pacienteid="${t.pacienteId}"
                                data-medicoid="${t.medicoId}"
                                data-fecha="${t.fecha}"
                                data-hora="${t.hora}"
                                data-obrasocialid="${t.obraSocialId}"
                                data-notas="${t.notas}">
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
                <option value="${p.id}" data-obrasocialid="${p.obraSocialId}" data-obrasocialnombre="${p.obraSocialNombre}">
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

        <!-- Estado siempre 1 -->
        <input type="hidden" id="estadoId" name="estadoId" value="1">

        <br><br>
        <label><i class="fas fa-sticky-note"></i> Observaciones:</label>
        <textarea id="notas" name="notas" style="height:60px;"></textarea>

        <br><br>
        <button class="btn btn-primary" type="submit"><i class="fas fa-save"></i> Confirmar Turno</button>
        <button type="button" class="btn" onclick="modalForm.close()"><i class="fas fa-times"></i> Cancelar</button>
    </form>
</dialog>

<jsp:include page="/WEB-INF/includes/alerts.jsp" />

</body>
</html>
