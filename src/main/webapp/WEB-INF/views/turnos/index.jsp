<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Turnos - Salud Total</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>

<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="/app/">🏠 Inicio</a>
    <a href="/app/medicos">👨‍⚕️ Médicos</a>
    <a href="/app/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="/app/obras-sociales">🏥 Obras Sociales</a>
    <a class="active" href="/app/turnos">📅 Turnos</a>
    <a href="/app/reportes">📊 Reportes</a>
</div>

<div class="content">

    <h2>Turnos</h2>

    <button class="btn btn-primary" onclick="abrirNuevo()">➕ Nuevo Turno</button>

    <br><br>

    <!-- FILTROS -->
    <form method="get" class="filtros">
        <select name="idMedico">
            <option value="">-- Todos los médicos --</option>
            <c:forEach var="m" items="${medicos}">
                <option value="${m.id}">${m.nombre} (${m.especialidadDescripcion})</option>
            </c:forEach>
        </select>

        <input type="date" name="desde" placeholder="Desde">
        <input type="date" name="hasta" placeholder="Hasta">

        <button class="btn btn-primary" type="submit">Filtrar</button>
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
                <td>${t.estadoNombre}</td>
                <td>
                    <button class="btn btn-primary btn-editar"
                            data-id="${t.id}"
                            data-pacienteid="${t.pacienteId}"
                            data-medicoid="${t.medicoId}"
                            data-fecha="${t.fecha}"
                            data-hora="${t.hora}"
                            data-obrasocialid="${t.obraSocialId}"
                            data-notas="${t.notas}">
                        ✏ Editar
                    </button>

                    <button class="btn btn-danger"
                            onclick="confirmarCancelar('${t.id}')">🗑 Cancelar</button>
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

        <label>Paciente:</label>
        <select id="paciente" name="pacienteId" onchange="onPacienteChange()" required style="width:100%; padding:6px;">
            <option value="">-- Seleccione --</option>
            <c:forEach var="p" items="${pacientes}">
                <option value="${p.id}"
                        data-obrasocialid="${p.obraSocialId}"
                        data-obrasocialnombre="${p.obraSocialNombre}">
                    ${p.nombre}
                </option>
            </c:forEach>
        </select>

        <br><br>
        <label>Obra Social del Paciente:</label>
        <input type="text" id="obra-social-display" readonly style="width:100%; background:#f0f0f0; padding:6px;">

        <br><br>
        <label>Médico:</label>
        <select id="medico" name="medicoId" required style="width:100%; padding:6px;">
            <option value="">-- Seleccione un paciente primero --</option>
        </select>

        <br><br>
        <label>Fecha:</label>
        <input type="date" id="fecha" name="fecha" required style="width:100%; padding:6px;">

        <br><br>
        <label>Hora:</label>
        <input type="time" id="hora" name="hora" required style="width:100%; padding:6px;">

        <br><br>
        <label>Notas (opcional):</label>
        <textarea id="notas" name="notas" style="width:100%; height:60px; padding:6px;"></textarea>

        <br><br>
        <button class="btn btn-primary" type="submit">Guardar</button>
        <button type="button" class="btn" onclick="modalForm.close()">Cancelar</button>

    </form>
</dialog>

<script>
// DATOS CARGADOS DESDE EL SERVIDOR
const TODO_MEDICOS = [
    <c:forEach var="m" items="${medicos}" varStatus="status">
        {
            id: ${m.id},
            nombre: "${m.nombre}",
            especialidad: "${m.especialidadDescripcion}",
            obras: [${m.obrasSocialesIdsCsv}]
        }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
];

const TODO_PACIENTES = [
    <c:forEach var="p" items="${pacientes}" varStatus="status">
        {
            id: ${p.id},
            nombre: "${p.nombre}",
            obraSocialId: ${p.obraSocialId},
            obraSocialNombre: "${p.obraSocialNombre}"
        }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
];

console.log("✅ Médicos cargados:", TODO_MEDICOS.length);
console.log("✅ Pacientes cargados:", TODO_PACIENTES.length);

function resetCampos() {
    document.getElementById("obra-social-display").value = "";
    document.getElementById("medico").innerHTML = '<option value="">-- Seleccione un paciente primero --</option>';
    document.getElementById("notas").value = "";
}

function abrirNuevo() {
    document.getElementById("modalTitle").innerText = "Nuevo Turno";
    document.getElementById("form-id").value = "";
    document.getElementById("paciente").value = "";
    document.getElementById("fecha").value = "";
    document.getElementById("hora").value = "";
    resetCampos();
    modalForm.showModal();
}

function onPacienteChange() {
    const sel = document.getElementById("paciente");
    const idPaciente = parseInt(sel.value);

    if (!idPaciente) {
        resetCampos();
        return;
    }

    const paciente = TODO_PACIENTES.find(p => p.id === idPaciente);

    if (!paciente) {
        console.warn("⚠️ Paciente no encontrado");
        resetCampos();
        return;
    }

    document.getElementById("obra-social-display").value = paciente.obraSocialNombre;
    cargarMedicos(paciente.obraSocialId);
}

function cargarMedicos(obraSocialId) {
    const medicoSelect = document.getElementById("medico");
    medicoSelect.innerHTML = "";

    if (!obraSocialId) {
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = "-- Sin obra social --";
        medicoSelect.appendChild(opt);
        return;
    }

    const medicosFiltrados = TODO_MEDICOS.filter(medico => {
        return medico.obras.includes(parseInt(obraSocialId));
    });

    if (medicosFiltrados.length === 0) {
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = "No hay médicos para esta obra social";
        medicoSelect.appendChild(opt);
        return;
    }

    const optDefault = document.createElement("option");
    optDefault.value = "";
    optDefault.textContent = "-- Seleccione un médico --";
    medicoSelect.appendChild(optDefault);

    medicosFiltrados.forEach(medico => {
        const opt = document.createElement("option");
        opt.value = medico.id;
        opt.textContent = medico.nombre + " (" + medico.especialidad + ")";
        medicoSelect.appendChild(opt);
    });
}

function confirmarCancelar(id) {
    if (confirm("¿Cancelar turno?")) {
        window.location.href = "/app/turnos/cancelar/" + id;
    }
}

function abrirEditar(turno) {
    document.getElementById("modalTitle").innerText = "Editar Turno";
    document.getElementById("form-id").value = turno.id;
    document.getElementById("paciente").value = turno.pacienteId;
    document.getElementById("fecha").value = turno.fecha;
    document.getElementById("hora").value = turno.hora;
    document.getElementById("notas").value = turno.notas || "";

    onPacienteChange();

    setTimeout(() => {
        document.getElementById("medico").value = turno.medicoId;
    }, 100);

    modalForm.showModal();
}

document.addEventListener("DOMContentLoaded", () => {
    const btns = document.querySelectorAll(".btn-editar");

    btns.forEach(btn => {
        btn.addEventListener("click", () => {
            const turno = {
                id:            btn.dataset.id,
                pacienteId:    parseInt(btn.dataset.pacienteid),
                medicoId:      parseInt(btn.dataset.medicoid),
                fecha:         btn.dataset.fecha,
                hora:          btn.dataset.hora.substring(0, 5),
                obraSocialId:  parseInt(btn.dataset.obrasocialid),
                notas:         btn.dataset.notas || ""
            };

            abrirEditar(turno);
        });
    });
});
</script>

</body>
</html>