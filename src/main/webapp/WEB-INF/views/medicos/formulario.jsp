<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Formulario Médico</title></head>
<body>
<h2>Formulario Médico</h2>
<form action="${pageContext.request.contextPath}/medicos${empty it ? '' : '/actualizar'}" method="post">
  <input type="hidden" name="id" value="${it.id}" />
  <label>Nombre Completo:</label>
  <input type="text" name="nombreCompleto" value="${it.nombreCompleto}" required /><br/>

  <label>Especialidad:</label>
  <input type="text" name="especialidad" value="${it.especialidad}" required /><br/>

  <label>Matrícula:</label>
  <input type="text" name="matricula" value="${it.matricula}" required /><br/>

  <label>Obras Sociales:</label><br/>
  <c:forEach var="o" items="${it.obrasSociales}">
    <label>
      <input type="checkbox" name="obrasSocialesIds" value="${o.id}"
             <c:if test="${it.obrasSocialesIds contains o.id}">checked</c:if> />
      ${o.nombre}
    </label><br/>
  </c:forEach>

  <button type="submit">Guardar</button>
</form>
<a href="${pageContext.request.contextPath}/medicos">Volver</a>
</body>
</html>
