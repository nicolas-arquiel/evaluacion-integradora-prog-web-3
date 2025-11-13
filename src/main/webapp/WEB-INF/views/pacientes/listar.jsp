  <%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <html>
  <head><title>Pacientes</title></head>
  <body>
  <h2>Listado de Pacientes</h2>
  <a href="${pageContext.request.contextPath}/pacientes/nuevo">➕ Nuevo Paciente</a>
  <table border="1">
  <tr><th>ID</th><th>Nombre</th><th>Teléfono</th><th>Documento</th><th>Activo</th><th>Acciones</th></tr>
  <c:forEach var="p" items="${it}">
    <tr>
      <td>${p.id}</td>
      <td>${p.nombreCompleto}</td>
      <td>${p.telefono}</td>
      <td>${p.documento}</td>
      <td><c:out value="${p.activo ? 'Sí' : 'No'}"/></td>
      <td>
        <a href="${pageContext.request.contextPath}/pacientes/editar/${p.id}">Editar</a> |
        <a href="${pageContext.request.contextPath}/pacientes/eliminar/${p.id}">Eliminar</a>
      </td>
    </tr>
  </c:forEach>
  </table>
  </body>
  </html>
