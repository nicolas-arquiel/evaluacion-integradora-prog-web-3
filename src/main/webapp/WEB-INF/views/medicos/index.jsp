<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Médicos - Salud Total</title>
    <link rel="stylesheet" href="/css/styles.css">

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

    function abrirEditar(id, nombre, especialidadId, matricula, obrasCsv) {
        document.getElementById("modalTitle").innerText = "Editar Médico";
        document.getElementById("form-action").value = "actualizar";
        document.getElementById("form-id").value = id;

        document.getElementById("form-nombre").value = nombre;
        document.getElementById("form-especialidad").value = especialidadId;
        document.getElementById("form-matricula").value = matricula;

        const obras = obrasCsv.split(",").map(x => x.trim());

        document.querySelectorAll(".chk-obra").forEach(chk => {
            chk.checked = obras.includes(chk.value);
        });

        modalForm.showModal();
    }

    function confirmarEliminar(id) {
        if (confirm("¿Eliminar este médico?")) {
            window.location.href = "/app/medicos/eliminar/" + id;
        }
    }
    </script>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="/app/">🏠 Inicio</a>
    <a class="active" href="/app/medicos">👨‍⚕️ Médicos</a>
    <a href="/app/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="/app/obras-sociales">🏥 Obras Sociales</a>
    <a href="/app/turnos">📅 Turnos</a>
    <a href="/app/reportes">📊 Reportes</a>
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
                <td>${m.nombre}</td>
                <td>${m.especialidadDescripcion}</td>
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
                                '${m.nombre}',
                                '${m.especialidadId}',
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

    <form method="post" action="/app/medicos">

        <input type="hidden" name="action" id="form-action">
        <input type="hidden" name="id" id="form-id">

        <label>Nombre:</label><br>
        <input type="text" id="form-nombre" name="nombre" required style="width:100%;"><br><br>

        <label>Especialidad:</label><br>
        <select id="form-especialidad" name="especialidadId" required style="width:100%;">
            <option value="">-- Seleccione --</option>
            <c:forEach var="e" items="${especialidades}">
                <option value="${e.id}">${e.descripcion}</option>
            </c:forEach>
        </select><br><br>

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