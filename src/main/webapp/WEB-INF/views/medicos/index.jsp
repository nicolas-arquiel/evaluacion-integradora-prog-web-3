<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>Médicos</title>

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
</style>

<script>
function abrirNuevo() {
    document.getElementById("modalTitle").innerText = "Nuevo Médico";
    document.getElementById("form-action").value = "crear";
    document.getElementById("form-id").value = "";

    document.getElementById("form-nombre").value = "";
    document.getElementById("form-especialidad").value = "";
    document.getElementById("form-matricula").value = "";

    document.querySelectorAll(".chk-obra").forEach(chk => chk.checked = false);

    modalForm.showModal();
}

function abrirEditar(id, nombre, especialidad, matricula, obrasCsv) {
    document.getElementById("modalTitle").innerText = "Editar Médico";
    document.getElementById("form-action").value = "actualizar";
    document.getElementById("form-id").value = id;

    document.getElementById("form-nombre").value = nombre;
    document.getElementById("form-especialidad").value = especialidad;
    document.getElementById("form-matricula").value = matricula;

    const obras = obrasCsv.split(",").map(x => x.trim());

    document.querySelectorAll(".chk-obra").forEach(chk => {
        chk.checked = obras.includes(chk.value);
    });

    modalForm.showModal();
}

function confirmarEliminar(id) {
    if (confirm("¿Eliminar este médico?")) {
        window.location.href = `/medicos/eliminar/${id}`;
    }
}
</script>

</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="${pageContext.request.contextPath}/">🏠 Inicio</a>
    <a class="active" href="${pageContext.request.contextPath}/medicos">👨‍⚕️ Médicos</a>
    <a href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>
    <a href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
</div>

<!-- CONTENIDO -->
<div class="content">

    <h2>Médicos</h2>
    <button class="btn btn-primary" onclick="abrirNuevo()">➕ Nuevo Médico</button>

    <br><br>

    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Especialidad</th>
            <th>Matrícula</th>
            <th>Obras Sociales</th>
            <th>Acciones</th>
        </tr>

        <c:forEach var="m" items="${medicos}">
            <tr>
                <td>${m.id}</td>
                <td>${m.nombreCompleto}</td>
                <td>${m.especialidad}</td>
                <td>${m.matricula}</td>
                <td>
                    <c:forEach var="o" items="${m.obrasSociales}">
                        ${o.nombre}<br/>
                    </c:forEach>
                </td>
                <td>
                    <button class="btn btn-primary"
                            onclick="abrirEditar(
                                '${m.id}',
                                '${m.nombreCompleto}',
                                '${m.especialidad}',
                                '${m.matricula}',
                                '${m.obrasSocialesIdsCsv}'
                            )">✏ Editar</button>

                    <button class="btn btn-danger"
                            onclick="confirmarEliminar('${m.id}')">🗑 Eliminar</button>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>

<!-- MODAL -->
<dialog id="modalForm">
    <h3 id="modalTitle"></h3>

    <form method="post" action="${pageContext.request.contextPath}/medicos">

        <input type="hidden" name="action" id="form-action">
        <input type="hidden" name="id" id="form-id">

        <label>Nombre Completo:</label><br>
        <input type="text" id="form-nombre" name="nombreCompleto" required style="width:100%;"><br><br>

        <label>Especialidad:</label><br>
        <input type="text" id="form-especialidad" name="especialidad" required style="width:100%;"><br><br>

        <label>Matrícula:</label><br>
        <input type="text" id="form-matricula" name="matricula" required style="width:100%;"><br><br>

        <label>Obras Sociales:</label><br>

        <c:forEach var="o" items="${obrasSociales}">
            <label>
                <input type="checkbox" class="chk-obra" name="obrasSocialesIds" value="${o.id}">
                ${o.nombre}
            </label><br>
        </c:forEach>

        <br>
        <button class="btn btn-primary" type="submit">Guardar</button>
        <button type="button" class="btn" onclick="modalForm.close()">Cancelar</button>

    </form>
</dialog>

</body>
</html>
