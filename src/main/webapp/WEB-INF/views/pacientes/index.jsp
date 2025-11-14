<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Pacientes - Salud Total</title>
    <link rel="stylesheet" href="/css/styles.css">

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
            window.location.href = "${pageContext.request.contextPath}/app/pacientes/eliminar/" + id;
        }
    }
    </script>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="${pageContext.request.contextPath}/app">🏠 Inicio</a>
    <a href="${pageContext.request.contextPath}/app/medicos">👨‍⚕️ Médicos</a>
    <a class="active" href="${pageContext.request.contextPath}/app/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="${pageContext.request.contextPath}/app/obras-sociales">🏥 Obras Sociales</a>
    <a href="${pageContext.request.contextPath}/app/turnos">📅 Turnos</a>
    <a href="${pageContext.request.contextPath}/app/reportes">📊 Reportes</a>
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
                            onclick="abrirEditar('${p.id}','${p.nombre}','${p.email}','${p.numeroTelefono}','${p.documento}','${p.obraSocialId}')">
                        ✏ Editar
                    </button>
                    <button class="btn btn-danger" onclick="confirmarEliminar('${p.id}')">
                        🗑 Eliminar
                    </button>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>

<!-- MODAL -->
<dialog id="modalForm">
    <h3 id="modalTitle"></h3>
    <form method="post" action="${pageContext.request.contextPath}/app/pacientes">
        <input type="hidden" name="action" id="form-action">
        <input type="hidden" name="id" id="form-id">

        <label>Nombre:</label>
        <input type="text" id="form-nombre" name="nombre" required>

        <label>Email:</label>
        <input type="email" id="form-email" name="email">

        <label>Teléfono:</label>
        <input type="text" id="form-telefono" name="numeroTelefono">

        <label>Documento:</label>
        <input type="text" id="form-documento" name="documento" required>

        <label>Obra Social:</label>
        <select id="form-obra-social" name="obraSocialId" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="o" items="${obrasSociales}">
                <option value="${o.id}">${o.nombre}</option>
            </c:forEach>
        </select>

        <br>
        <button class="btn btn-primary" type="submit">Guardar</button>
        <button type="button" class="btn" onclick="modalForm.close()">Cancelar</button>
    </form>
</dialog>

</body>
</html>