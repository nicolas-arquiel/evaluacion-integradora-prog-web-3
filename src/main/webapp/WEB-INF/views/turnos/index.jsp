<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Turnos</title>

    <style>
        body { margin:0; display:flex; font-family:Arial; background:#f4f4f4; }

        .sidebar {
            width:220px; background:#2d3e50; color:white;
            padding:15px; height:100vh;
        }
        .sidebar a {
            color:white; padding:10px; display:block;
            text-decoration:none; border-radius:4px;
        }
        .sidebar a:hover, .active {
            background:#f1cc31; color:black !important; font-weight:bold;
        }

        .content { flex:1; padding:25px; }

        table {
            width:100%; border-collapse:collapse;
            background:white; border-radius:6px;
        }
        th, td { padding:10px; border-bottom:1px solid #ddd; }
        th { background:#2d3e50; color:white; }

        tr:hover { background:#f9f9f9; }

        .btn { padding:8px 14px; border:none; border-radius:4px; cursor:pointer; }
        .btn-primary { background:#2d3e50; color:white; }
        .btn-danger { background:#d9534f; color:white; }

        dialog { border:none; border-radius:8px; padding:20px; width:420px; }
        dialog::backdrop { background:rgba(0,0,0,0.4); }

        .filtros { display:flex; gap:15px; margin-bottom:20px; }
        .filtros input, .filtros select { padding:6px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="${pageContext.request.contextPath}/">🏠 Inicio</a>
    <a href="${pageContext.request.contextPath}/medicos">👨‍⚕️ Médicos</a>
    <a href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>
    <a class="active" href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
    <a href="${pageContext.request.contextPath}/reportes">📊 Reportes</a>
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

    <form method="post" action="${pageContext.request.contextPath}/turnos">

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

<!-- ========================================================== -->
<!-- DATOS EMBEBIDOS EN JAVASCRIPT                               -->
<!-- ========================================================== -->

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

// ============================
// RESET CAMPOS
// ============================
function resetCampos() {
    document.getElementById("obra-social-display").value = "";
    document.getElementById("medico").innerHTML = '<option value="">-- Seleccione un paciente primero --</option>';
    document.getElementById("notas").value = "";
}

// ============================
// NUEVO TURNO
// ============================
function abrirNuevo() {
    document.getElementById("modalTitle").innerText = "Nuevo Turno";
    document.getElementById("form-id").value = "";
    document.getElementById("paciente").value = "";
    document.getElementById("fecha").value = "";
    document.getElementById("hora").value = "";

    resetCampos();
    modalForm.showModal();
}

// ============================
// CAMBIO DE PACIENTE
// ============================
function onPacienteChange() {
    const sel = document.getElementById("paciente");
    const idPaciente = parseInt(sel.value);

    console.log("🟡 Paciente seleccionado:", idPaciente);

    if (!idPaciente) {
        resetCampos();
        return;
    }

    // Buscar paciente en los datos cargados
    const paciente = TODO_PACIENTES.find(p => p.id === idPaciente);

    if (!paciente) {
        console.warn("⚠️ Paciente no encontrado");
        resetCampos();
        return;
    }

    console.log("📦 Paciente encontrado:", paciente);

    // Mostrar obra social del paciente
    document.getElementById("obra-social-display").value = paciente.obraSocialNombre;

    // Cargar médicos que acepten esa obra social
    cargarMedicos(paciente.obraSocialId);
}

// ============================
// CARGAR MÉDICOS FILTRADOS
// ============================
function cargarMedicos(obraSocialId) {
    console.log("🔵 Filtrando médicos por obra social ID:", obraSocialId);

    const medicoSelect = document.getElementById("medico");
    
    // IMPORTANTE: Limpiar completamente el select
    medicoSelect.innerHTML = "";

    if (!obraSocialId) {
        console.warn("⚠️ Sin obra social");
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = "-- Sin obra social --";
        medicoSelect.appendChild(opt);
        return;
    }

    // Filtrar médicos que acepten la obra social del paciente
    const medicosFiltrados = TODO_MEDICOS.filter(medico => {
        return medico.obras.includes(parseInt(obraSocialId));
    });

    console.log("📦 Médicos filtrados:", medicosFiltrados);

    if (medicosFiltrados.length === 0) {
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = "No hay médicos para esta obra social";
        medicoSelect.appendChild(opt);
        return;
    }

    // Agregar opción por defecto
    const optDefault = document.createElement("option");
    optDefault.value = "";
    optDefault.textContent = "-- Seleccione un médico --";
    medicoSelect.appendChild(optDefault);

    // Agregar cada médico filtrado
    medicosFiltrados.forEach(medico => {
        const opt = document.createElement("option");
        opt.value = medico.id;
        opt.textContent = medico.nombre + " (" + medico.especialidad + ")";
        medicoSelect.appendChild(opt);
    });

    console.log("✅ Select de médicos actualizado con", medicosFiltrados.length, "opciones");
}

// ============================
// CONFIRMAR CANCELAR
// ============================
function confirmarCancelar(id) {
    if (confirm("¿Cancelar turno?")) {
        window.location.href = "${pageContext.request.contextPath}/turnos/cancelar/" + id;
    }
}

// ============================
// EDITAR
// ============================
function abrirEditar(turno) {
    console.log("✏ Editando turno:", turno);

    document.getElementById("modalTitle").innerText = "Editar Turno";
    document.getElementById("form-id").value = turno.id;
    document.getElementById("paciente").value = turno.pacienteId;
    document.getElementById("fecha").value = turno.fecha;
    document.getElementById("hora").value = turno.hora;
    document.getElementById("notas").value = turno.notas || "";

    // Cargar obra social del paciente y médicos
    onPacienteChange();

    // Seleccionar el médico correcto después de que se carguen
    setTimeout(() => {
        const medicoSelect = document.getElementById("medico");
        medicoSelect.value = turno.medicoId;
        console.log("✅ Médico seleccionado:", turno.medicoId);
    }, 100);

    modalForm.showModal();
}

// ============================
// EVENTOS INICIALES
// ============================
document.addEventListener("DOMContentLoaded", () => {
    console.log("🟩 DOMContentLoaded");

    const btns = document.querySelectorAll(".btn-editar");
    console.log("🔎 Botones editar encontrados:", btns.length);

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