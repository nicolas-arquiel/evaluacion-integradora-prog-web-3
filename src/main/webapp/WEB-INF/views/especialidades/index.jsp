<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Especialidades</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <script src="/js/especialidades.js"></script>
</head>
<body>

<!-- Sidebar -->
<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="content">

    <h2><i class="fas fa-stethoscope"></i> Especialidades Médicas</h2>

    <button class="btn btn-primary" onclick="abrirNuevo()">
        <i class="fas fa-plus"></i> Nueva Especialidad
    </button>

    <br><br>

    <table>
        <tr>
            <th>ID</th>
            <th>Descripción</th>
            <th>Acciones</th>
        </tr>

        <c:forEach var="e" items="${especialidades}">
            <tr>
                <td>${e.id}</td>
                <td>${e.descripcion}</td>
                <td>
                    <button class="btn btn-primary btn-editar"
                            data-id="${e.id}"
                            data-descripcion="${e.descripcion}">
                        <i class="fas fa-edit"></i> Editar
                    </button>

                    <button class="btn btn-danger"
                            onclick="eliminarEspecialidad('${e.id}')">
                        <i class="fas fa-trash"></i> Eliminar
                    </button>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>

<!-- MODAL -->
<dialog id="modalForm">
    <h3 id="modalTitle"></h3>

    <form method="post" action="/app/especialidades">
        <input type="hidden" name="id" id="form-id">

        <label>Descripción:</label>
        <input type="text" id="descripcion" name="descripcion" required>

        <br><br>

        <button class="btn btn-primary" type="submit">
            <i class="fas fa-save"></i> Guardar
        </button>

        <button type="button" class="btn" onclick="modalForm.close()">
            <i class="fas fa-times"></i> Cancelar
        </button>
    </form>
</dialog>

<jsp:include page="/WEB-INF/includes/alerts.jsp" />

</body>
</html>
