<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Obras Sociales</title>

    <style>
        body {
            margin:0;
            display:flex;
            font-family: Arial;
            background:#f4f4f4;
        }

        /* SIDEBAR */
        .sidebar {
            width:220px;
            background:#2d3e50;
            color:white;
            padding:15px;
            height:100vh;
        }
        .sidebar a {
            color:white;
            display:block;
            padding:10px;
            text-decoration:none;
            border-radius:4px;
        }
        .sidebar a:hover, .active {
            background:#f1cc31;
            color:black !important;
            font-weight:bold;
        }

        /* CONTENIDO */
        .content {
            flex:1;
            padding:25px;
        }

        /* TABLA */
        table {
            width:100%;
            border-collapse: collapse;
            background:white;
            border-radius:6px;
        }
        th, td {
            padding:10px;
            border-bottom:1px solid #ddd;
        }
        th {
            background:#2d3e50;
            color:white;
        }

        tr:hover {
            background:#f9f9f9;
        }

        /* BOTÓN */
        .btn {
            padding:8px 14px;
            border:none;
            border-radius:4px;
            cursor:pointer;
        }
        .btn-primary {
            background:#2d3e50;
            color:white;
        }
        .btn-primary:hover {
            background:#1f2e3d;
        }
        .btn-danger {
            background:#d9534f;
            color:white;
        }

        /* MODAL */
        dialog {
            border:none;
            border-radius:8px;
            padding:20px;
            width:400px;
        }
        dialog::backdrop {
            background:rgba(0,0,0,0.4);
        }
    </style>

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
                window.location.href = "${pageContext.request.contextPath}/obras-sociales/eliminar/" + id;
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
    <a href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a class="active" href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>
    <a href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
    <a href="${pageContext.request.contextPath}/reportes">📊 Reportes</a>
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

    <form method="post" action="${pageContext.request.contextPath}/obras-sociales">
          
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