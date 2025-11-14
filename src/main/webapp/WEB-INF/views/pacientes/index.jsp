<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Pacientes - Salud Total</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <script src="/js/pacientes.js"></script>
</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<!-- CONTENIDO -->
<div class="content">
    <h2><i class="fas fa-users"></i> Pacientes</h2>
    <button class="btn btn-primary" onclick="abrirNuevo()">
        <i class="fas fa-plus"></i> Nuevo Paciente
    </button>

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
                        <i class="fas fa-edit"></i> Editar
                    </button>
                    <button class="btn btn-danger" onclick="eliminarPaciente('${p.id}')">
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
    <form method="post" action="${pageContext.request.contextPath}/app/pacientes">
        <input type="hidden" name="action" id="form-action">
        <input type="hidden" name="id" id="form-id">

        <label><i class="fas fa-user"></i> Nombre:</label>
        <input type="text" id="form-nombre" name="nombre" required>

        <label><i class="fas fa-envelope"></i> Email:</label>
        <input type="email" id="form-email" name="email">

        <label><i class="fas fa-phone"></i> Teléfono:</label>
        <input type="text" id="form-telefono" name="numeroTelefono">

        <label><i class="fas fa-id-card"></i> Documento:</label>
        <input type="text" id="form-documento" name="documento" required>

        <label><i class="fas fa-hospital"></i> Obra Social:</label>
        <select id="form-obra-social" name="obraSocialId" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="o" items="${obrasSociales}">
                <option value="${o.id}">${o.nombre}</option>
            </c:forEach>
        </select>

        <br>
        <button class="btn btn-primary" type="submit">
            <i class="fas fa-save"></i> Guardar
        </button>
        <button type="button" class="btn" onclick="modalForm.close()">
            <i class="fas fa-times"></i> Cancelar
        </button>
    </form>
</dialog>

<!-- Incluir sistema de alertas -->
<jsp:include page="/WEB-INF/includes/alerts.jsp" />

</body>
</html>