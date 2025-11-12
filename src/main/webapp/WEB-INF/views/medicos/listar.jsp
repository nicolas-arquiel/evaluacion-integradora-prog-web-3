<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Listado de Médicos</title></head>
<body>
<h2>Listado de Médicos</h2>
<a href="${pageContext.request.contextPath}/medicos/nuevo">➕ Nuevo Médico</a>
<table border="1">
    <tr><th>ID</th><th>Nombre</th><th>Especialidad</th><th>Matrícula</th><th>Activo</th><th>Acciones</th></tr>
    <c:forEach var="m" items="${it}">
        <tr>
            <td>${m.id}</td>
            <td>${m.nombreCompleto}</td>
            <td>${m.especialidad}</td>
            <td>${m.matricula}</td>
            <td><c:out value="${m.activo ? 'Sí' : 'No'}"/></td>
            <td>
                <a href="${pageContext.request.contextPath}/medicos/editar/${m.id}">Editar</a> |
                <a href="${pageContext.request.contextPath}/medicos/eliminar/${m.id}">Eliminar</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
