<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Formulario Obra Social</title></head>
<body>
<h2>Formulario Obra Social</h2>
<form action="${pageContext.request.contextPath}/obras-sociales${empty it ? '' : '/actualizar'}" method="post">
  <input type="hidden" name="id" value="${it.id}" />
  <label>Nombre:</label>
  <input type="text" name="nombre" value="${it.nombre}" required /><br/>
  <button type="submit">Guardar</button>
</form>
<a href="${pageContext.request.contextPath}/obras-sociales">Volver</a>
</body>
</html>
