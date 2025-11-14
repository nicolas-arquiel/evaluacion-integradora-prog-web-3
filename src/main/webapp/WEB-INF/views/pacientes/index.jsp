<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>Pacientes</title>

<style>
    body { margin:0; display:flex; font-family:Arial; background:#f4f4f4; }

    .sidebar {
        width:220px; background:#2d3e50; color:white;
        padding:15px; height:100vh;
    }
    .sidebar a {
        color:white; padding:10px; display:block; border-radius:4px;
        text-decoration:none;
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
</style>

<script>
function abrirNuevo() {
    document.getElementById("modalTitle").innerText = "Nuevo Paciente";
    document.getElementById("form-action").value = "crear";
    document.getElementById("form-id").value = "";

    document.getElementById("form-nombre").value = "";
    document.getElementById("form-email").value = "";
    document.getElementById("form-telefono").value = "";
    document.getElementById("form-documento").value = "";
    document.getElementById("form-obra-social").value = "";

    modalForm.showModal();
}

function abrirEditar(id, nombre, email, telefono, documento, obraSocialId) {
    document.getElementById("modalTitle").innerText = "Editar Paciente";
    document.getElementById("form-action").value = "actualizar";
    document.getElementById("form-id").value = id;

    document.getElementById("form-nombre").value = nombre;
    document.getElementById("form-email").value = email;
    document.getElementById("form-telefono").value = telefono;
    document.getElementById("form-documento").value = documento;
    document.getElementById("form-obra-social").value = obraSocialId;

    modalForm.showModal();
}

function confirmarEliminar(id) {
    if (confirm("¿Eliminar este paciente?")) {
        window.location.href = "${pageContext.request.contextPath}/pacientes/eliminar/" + id;
    }
}
</script>

</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="${pageContext.request.contextPath}/">🏠 Inicio</a>
    <a href="${pageContext.request.contextPath}/medicos">👨‍⚕️ Médicos</a>
    <a class="active" href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>
    <a href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
    <a href="${pageContext.request.contextPath}/reportes">📊 Reportes</a>
</div>

<!-- CONTENIDO -->
<div class="content">

    <h2>Pacientes</h2>
    <button class="btn btn-primary" onclick="abrirNuevo()">➕ Nuevo Paciente</button>

    <br><br>

    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Email</th>
            <th>Teléfono</th>
            <th>Documento</th>
            <th>Obra Social</th>
            <th>Acciones</th>
        </tr>

        <c:forEach var="p" items="${pacientes}">
            <tr>
                <td>${p.id}</td>
                <td>${p.nombre}</td>
                <td>${p.email}</td>
                <td>${p.numeroTelefono}</td>
                <td>${p.documento}</td>
                <td>${p.obraSocialNombre}</td>
                <td>
                    <button class="btn btn-primary"
                            onclick="abrirEditar(
                                '${p.id}',
                                '${p.nombre}',
                                '${p.email}',
                                '${p.numeroTelefono}',
                                '${p.documento}',
                                '${p.obraSocialId}'
                            )">✏ Editar</button>

                    <button class="btn btn-danger"
                            onclick="confirmarEliminar('${p.id}')">🗑 Eliminar</button>
                </td>
            </tr>
        </c:forEach>

    </table>

</div>

<!-- MODAL -->
<dialog id="modalForm">
    <h3 id="modalTitle"></h3>

    <form method="post" action="${pageContext.request.contextPath}/pacientes">

        <input type="hidden" name="action" id="form-action">
        <input type="hidden" name="id" id="form-id">

        <label>Nombre:</label><br>
        <input type="text" id="form-nombre" name="nombre" required style="width:100%;"><br><br>

        <label>Email:</label><br>
        <input type="email" id="form-email" name="email" style="width:100%;"><br><br>

        <label>Teléfono:</label><br>
        <input type="text" id="form-telefono" name="numeroTelefono" style="width:100%;"><br><br>

        <label>Documento:</label><br>
        <input type="text" id="form-documento" name="documento" required style="width:100%;"><br><br>

        <label>Obra Social:</label><br>
        <select id="form-obra-social" name="obraSocialId" required style="width:100%;">
            <option value="">-- Seleccione --</option>
            <c:forEach var="o" items="${obrasSociales}">
                <option value="${o.id}">${o.nombre}</option>
            </c:forEach>
        </select><br><br>

        <br>
        <button class="btn btn-primary" type="submit">Guardar</button>
        <button type="button" class="btn" onclick="modalForm.close()">Cancelar</button>

    </form>
</dialog>

</body>
</html>