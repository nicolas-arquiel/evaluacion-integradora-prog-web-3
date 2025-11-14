<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Gestión de Turnos - Salud Total</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
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

    <div style="background: #e8f4fd; padding: 12px; border-radius: 6px; margin-bottom: 20px; border-left: 4px solid #007bff;">
        <p style="margin: 0; color: #055160;">
            <i class="fas fa-info-circle"></i> 
            <strong>Horarios de atención:</strong> Lunes a Viernes de 8:00 a 17:45 hs (último turno). 
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
                <option value="${m.id}">Dr. ${m.nombre} (${m.especialidadDescripcion})</option>
            </c:forEach>
        </select>

        <input type="date" name="desde" placeholder="Desde">
        <input type="date" name="hasta" placeholder="Hasta">

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
                <td>Dr. ${t.nombreMedico}</td>
                <td>${t.fecha}</td>
                <td>${t.hora}</td>
                <td>
                    <c:choose>
                        <c:when test="${t.estadoNombre == 'Programado'}">
                            <span style="color: green; font-weight: bold;">
                                <i class="fas fa-clock"></i> ${t.estadoNombre}
                            </span>
                        </c:when>
                        <c:when test="${t.estadoNombre == 'Cancelado'}">
                            <span style="color: red; font-weight: bold;">
                                <i class="fas fa-times-circle"></i> ${t.estadoNombre}
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: orange; font-weight: bold;">
                                <i class="fas fa-question-circle"></i> ${t.estadoNombre}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
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

                    <button class="btn btn-danger" onclick="cancelarTurno('${t.id}')">
                        <i class="fas fa-ban"></i> Cancelar
                    </button>
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
                <option value="${p.id}"
                        data-obrasocialid="${p.obraSocialId}"
                        data-obrasocialnombre="${p.obraSocialNombre}">
                    ${p.nombre}
                </option>
            </c:forEach>
        </select>

        <br><br>
        <label><i class="fas fa-hospital"></i> Cobertura Médica:</label>
        <input type="text" id="obra-social-display" readonly style="background:#f0f0f0;">

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
        <small style="color: #666; font-style: italic;">
            Horario: 8:00 a 17:45 hs - Intervalos de 15 minutos - Solo días hábiles
        </small>

        <br><br>
        <label><i class="fas fa-sticky-note"></i> Observaciones Clínicas:</label>
        <textarea id="notas" name="notas" style="height:60px;" placeholder="Motivo de consulta, síntomas, observaciones..."></textarea>

        <br><br>
        <button class="btn btn-primary" type="submit">
            <i class="fas fa-save"></i> Confirmar Turno
        </button>
        <button type="button" class="btn" onclick="modalForm.close()">
            <i class="fas fa-times"></i> Cancelar
        </button>
    </form>
</dialog>

<!-- Incluir sistema de alertas -->
<jsp:include page="/WEB-INF/includes/alerts.jsp" />

</body>
</html>