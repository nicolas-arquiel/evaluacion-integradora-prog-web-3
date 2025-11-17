<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Médicos - Salud Total</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <link rel="stylesheet" href="/css/medicos.css">
    <script src="/js/medicos.js"></script>
</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<!-- CONTENIDO -->
<div class="content">
    <h2><i class="fas fa-user-md"></i> Médicos</h2>
    <button class="btn btn-primary" onclick="abrirNuevo()">
        <i class="fas fa-plus"></i> Nuevo Médico
    </button>

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
                            )">
                        <i class="fas fa-edit"></i> Editar
                    </button>

                    <button class="btn btn-danger" onclick="eliminarMedico('${m.id}')">
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
    
    <form method="post" action="${pageContext.request.contextPath}/app/medicos">
        <input type="hidden" name="action" id="form-action">
        <input type="hidden" name="id" id="form-id">

        <label><i class="fas fa-user"></i> Nombre:</label>
        <input type="text" id="form-nombre" name="nombre" required>

        <label><i class="fas fa-stethoscope"></i> Especialidad:</label>
        <select id="form-especialidad" name="especialidadId" required>
            <option value="">-- Seleccione --</option>
            <c:forEach var="e" items="${especialidades}">
                <option value="${e.id}">${e.descripcion}</option>
            </c:forEach>
        </select>

        <label><i class="fas fa-id-badge"></i> Matrícula:</label>
        <input type="text" id="form-matricula" name="matricula" required>

        <label><i class="fas fa-hospital"></i> Obras Sociales:</label>
        <div class="obras-sociales-container">
            <c:forEach var="o" items="${obrasSociales}">
                <div class="obra-social-item">
                    <input type="checkbox" class="chk-obra" name="obrasSocialesIds" value="${o.id}" id="obra-${o.id}">
                    <label for="obra-${o.id}">${o.nombre}</label>
                </div>
            </c:forEach>
        </div>

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