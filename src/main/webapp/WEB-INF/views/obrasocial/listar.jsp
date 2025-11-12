<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Obras Sociales</title></head>
<body>
<h2>Listado de Obras Sociales</h2>
<a href="${pageContext.request.contextPath}/obras-sociales/nuevo">➕ Nueva Obra Social</a>
<table border="1">
<tr><th>ID</th><th>Nombre</th><th>Activo</th><th>Acciones</th></tr>
<c:forEach var="o" items="${it}">
  <tr>
    <td>${o.id}</td>
    <td>${o.nombre}</td>
    <td><c:out value="${o.activo ? 'Sí' : 'No'}"/></td>
    <td>
      <a href="${pageContext.request.contextPath}/obras-sociales/editar/${o.id}">Editar</a> |
      <a href="${pageContext.request.contextPath}/obras-sociales/eliminar/${o.id}">Eliminar</a>
    </td>
  </tr>
</c:forEach>
</table>
</body>
</html>
