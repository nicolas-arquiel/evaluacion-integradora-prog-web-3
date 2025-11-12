<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Gestión de Turnos</title></head>
<body>
<h2>Listado de Turnos</h2>
<a href="${pageContext.request.contextPath}/turnos/nuevo">➕ Nuevo Turno</a>
<table border="1">
    <tr><th>ID</th><th>Paciente</th><th>Médico</th><th>Fecha</th><th>Hora</th><th>Estado</th><th>Acciones</th></tr>
    <c:forEach var="t" items="${it}">
        <tr>
            <td>${t.id}</td>
            <td>${t.nombrePaciente}</td>
            <td>${t.nombreMedico}</td>
            <td>${t.fecha}</td>
            <td>${t.hora}</td>
            <td>${t.estado}</td>
            <td>
                <c:if test="${t.estado == 'activo'}">
                    <a href="${pageContext.request.contextPath}/turnos/cancelar/${t.id}">Cancelar</a>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
