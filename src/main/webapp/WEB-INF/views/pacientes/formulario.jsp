<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Formulario Paciente</title></head>
<body>
<h2>Formulario Paciente</h2>
<form action="${pageContext.request.contextPath}/pacientes${empty paciente ? '' : '/actualizar'}" method="post">
  <input type="hidden" name="id" value="${paciente.id}" />

  <label>Nombre Completo:</label>
  <input type="text" name="nombreCompleto" value="${paciente.nombreCompleto}" required /><br/>

  <label>Teléfono:</label>
  <input type="text" name="telefono" value="${paciente.telefono}" /><br/>

  <label>Documento:</label>
  <input type="text" name="documento" value="${paciente.documento}" required /><br/>

  <label>Obras Sociales:</label><br/>
  <c:forEach var="o" items="${obrasSociales}">
    <label>
      <input type="checkbox" name="obrasSocialesIds" value="${o.id}"
             <c:if test="${paciente.obrasSocialesIds contains o.id}">checked</c:if> />
      ${o.nombre}
    </label><br/>
  </c:forEach>

  <button type="submit">Guardar</button>
</form>
<a href="${pageContext.request.contextPath}/pacientes">Volver</a>
</body>
</html>
