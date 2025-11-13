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
</div>

<div class="content">

    <h2>Turnos</h2>

    <button class="btn btn-primary" onclick="abrirNuevo()">➕ Nuevo Turno</button>

    <br><br>

    <!-- FILTROS -->
    <form method="get" class="filtros">
        <select name="idMedico">
            <option value="">-- Médico --</option>
            <c:forEach var="m" items="${medicos}">
                <option value="${m.id}">${m.nombreCompleto}</option>
            </c:forEach>
        </select>

        <input type="date" name="desde">
        <input type="date" name="hasta">

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
                        data-idpaciente="${t.idPaciente}"
                        data-idmedico="${t.idMedico}"
                        data-fecha="${t.fecha}"
                        data-hora="${t.hora}"
                        data-obras="${t.obrasIdsCsv}">
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
        <select id="paciente" name="idPaciente" onchange="onPacienteChange()" required style="width:100%;">
            <option value="">-- Seleccione --</option>
            <c:forEach var="p" items="${pacientes}">
                <option value="${p.id}">${p.nombreCompleto}</option>
            </c:forEach>
        </select>

        <label>Obras Sociales:</label>
        <select id="obras" multiple size="4" onchange="cargarMedicos()" style="width:100%;"></select>

        <label>Médico:</label>
        <select id="medico" name="idMedico" required style="width:100%;"></select>

        <label>Fecha:</label>
        <input type="date" id="fecha" name="fecha" required style="width:100%;">

        <label>Hora:</label>
        <input type="time" id="hora" name="hora" required style="width:100%;">

        <br><br>
        <button class="btn btn-primary" type="submit">Guardar</button>
        <button type="button" class="btn" onclick="modalForm.close()">Cancelar</button>

    </form>
</dialog>

<script>

// ======================================================
// CONFIGURACIÓN FIJA QUE SIEMPRE FUNCIONA
// ======================================================
const baseUrl = "/turnos";  
console.log("BASE URL:", baseUrl);


// ======================================================
// LOG HELPERS
// ======================================================
function log(...a) { console.log("🔵", ...a); }
function warn(...a) { console.warn("🟡", ...a); }
function err(...a) { console.error("🔴", ...a); }


// ======================================================
// NUEVO TURNO
// ======================================================
function resetCampos() {
    document.getElementById("obras").innerHTML = "";
    document.getElementById("medico").innerHTML = "";
}

function abrirNuevo() {
    log("Abrir nuevo turno");
    document.getElementById("modalTitle").innerText = "Nuevo Turno";
    document.getElementById("form-id").value = "";
    document.getElementById("paciente").value = "";
    document.getElementById("fecha").value = "";
    document.getElementById("hora").value = "";
    resetCampos();
    modalForm.showModal();
}


// ======================================================
// CAMBIO DE PACIENTE
// ======================================================
function onPacienteChange() {
    const id = document.getElementById("paciente").value;
    log("Paciente seleccionado:", id);
    cargarObras();
}


// ======================================================
// EDITAR
// ======================================================
function abrirEditar(t) {
    log("Editar turno:", t);

    document.getElementById("modalTitle").innerText = "Editar Turno";

    document.getElementById("form-id").value = t.id;
    document.getElementById("paciente").value = t.idPaciente;

    resetCampos();

    cargarObras().then(() => {

        const obrasSelect = document.getElementById("obras");
        t.obras.forEach(id => {
            Array.from(obrasSelect.options).forEach(opt => {
                if (opt.value == id) opt.selected = true;
            });
        });

        cargarMedicos().then(() => {
            document.getElementById("medico").value = t.idMedico;
        });

    });

    document.getElementById("fecha").value = t.fecha;
    document.getElementById("hora").value = t.hora;

    modalForm.showModal();
}


// ======================================================
// CARGAR OBRAS DEL PACIENTE
// ======================================================
async function cargarObras() {
    const idPaciente = document.getElementById("paciente").value;
    log("cargarObras(): idPaciente =", idPaciente);

    const obrasSelect = document.getElementById("obras");
    obrasSelect.innerHTML = "";

    if (!idPaciente) {
        warn("No hay idPaciente -> no se consulta");
        return;
    }

    const url = `${baseUrl}/obras-sociales-paciente/${idPaciente}`;
    log("URL OBRAS =", url);

    try {
        const res = await fetch(url);
        log("Status:", res.status);
        log("Content-Type:", res.headers.get("content-type"));

        const data = await res.json();
        log("Obras recibidas:", data);

        data.forEach(o => {
            obrasSelect.innerHTML += `<option value="${o.id}">${o.nombre}</option>`;
        });

    } catch (e) {
        err("Error cargando obras:", e);
    }
}


// ======================================================
// CARGAR MÉDICOS SEGÚN OBRAS
// ======================================================
async function cargarMedicos() {
    const obras = Array.from(document.getElementById("obras").selectedOptions)
        .map(o => o.value);

    log("cargarMedicos(): obras seleccionadas =", obras);

    const medicoSelect = document.getElementById("medico");
    medicoSelect.innerHTML = "";

    if (obras.length === 0) {
        warn("No hay obras -> no se cargan médicos");
        return;
    }

    const params = new URLSearchParams();
    obras.forEach(o => params.append("obras", o));

    const url = `${baseUrl}/medicos-disponibles?${params.toString()}`;
    log("URL MEDICOS =", url);

    try {
        const res = await fetch(url);
        log("Status:", res.status);

        const data = await res.json();
        log("Médicos recibidos:", data);

        data.forEach(m => {
            medicoSelect.innerHTML += `<option value="${m.id}">
                ${m.nombre} (${m.especialidad})
            </option>`;
        });

    } catch (e) {
        err("Error cargando médicos:", e);
    }
}


// ======================================================
// EVENTO CLICK EDITAR
// ======================================================
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".btn-editar").forEach(btn => {

        btn.addEventListener("click", () => {

            log("Click en editar → dataset:", btn.dataset);

            const obras = btn.dataset.obras
                ? btn.dataset.obras.split(",").map(Number)
                : [];

            const turno = {
                id: btn.dataset.id,
                idPaciente: btn.dataset.idpaciente,
                idMedico: btn.dataset.idmedico,
                fecha: btn.dataset.fecha,
                hora: btn.dataset.hora,
                obras: obras
            };

            abrirEditar(turno);
        });
    });
});

</script>

</body>
</html>
