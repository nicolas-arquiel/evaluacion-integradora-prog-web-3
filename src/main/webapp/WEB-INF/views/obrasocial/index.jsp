<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Obras Sociales - Salud Total</title>
    <link rel="stylesheet" href="/css/styles.css">

    <script>
        // Abre modal para crear
        function abrirNuevo() {
            document.getElementById("form-id").value = "";
            document.getElementById("form-nombre").value = "";
            document.getElementById("modalTitle").innerText = "Nueva Obra Social";
            document.getElementById("form-action").value = "crear";
            document.getElementById("modalForm").showModal();
        }

        // Abre modal para editar con datos
        function abrirEditar(id, nombre) {
            document.getElementById("form-id").value = id;
            document.getElementById("form-nombre").value = nombre;
            document.getElementById("modalTitle").innerText = "Editar Obra Social";
            document.getElementById("form-action").value = "actualizar";
            document.getElementById("modalForm").showModal();
        }

        // Confirmación antes de eliminar
        function confirmarEliminar(id) {
            if (confirm("¿Seguro que desea eliminar esta obra social?")) {
                window.location.href = "/app/obras-sociales/eliminar/" + id;
            }
        }
    </script>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="/app/">🏠 Inicio</a>
    <a href="/app/medicos">👨‍⚕️ Médicos</a>
    <a href="/app/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a class="active" href="/app/obras-sociales">🏥 Obras Sociales</a>
    <a href="/app/turnos">📅 Turnos</a>
    <a href="/app/reportes">📊 Reportes</a>
</div>

<!-- CONTENIDO -->
<div class="content">

    <h2>Obras Sociales</h2>
    <button class="btn btn-primary" onclick="abrirNuevo()">➕ Nueva Obra Social</button>

    <br><br>

    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>

        <c:forEach var="o" items="${items}">
            <tr>
                <td>${o.id}</td>
                <td>${o.nombre}</td>
                <td>
                    <c:choose>
                        <c:when test="${o.activo}">
                            <span style="color: green;">✓ Activo</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: red;">✗ Inactivo</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <button class="btn btn-primary"
                            onclick="abrirEditar('${o.id}','${o.nombre}')">✏ Editar</button>

                    <button class="btn btn-danger"
                            onclick="confirmarEliminar('${o.id}')">🗑 Eliminar</button>
                </td>
            </tr>
        </c:forEach>

    </table>
</div>

<!-- MODAL -->
<dialog id="modalForm">
    <h3 id="modalTitle"></h3>

    <form method="post" action="/app/obras-sociales">
          
        <input type="hidden" id="form-action" name="action">
        <input type="hidden" id="form-id" name="id">

        <label>Nombre:</label><br>
        <input type="text" id="form-nombre" name="nombre" required style="width:100%; padding:8px;"><br><br>

        <button class="btn btn-primary" type="submit">Guardar</button>
        <button type="button" class="btn" onclick="modalForm.close()">Cancelar</button>
    </form>
</dialog>

</body>
</html>