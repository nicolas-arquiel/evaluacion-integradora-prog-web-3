<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Obras Sociales - Formulario</title>
    <style>
        body { margin:0; display:flex; font-family:Arial; }
        .sidebar { width:220px; background:#2d3e50; color:white; padding:15px; }
        .sidebar a { color:white; display:block; padding:8px; text-decoration:none; border-radius:4px;}
        .sidebar a:hover { background:#f1cc31; color:black; }
        .active { background:#f1cc31; color:black !important; font-weight:bold; }
        .content { flex:1; padding:20px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Salud Total</h2>
    <a href="${pageContext.request.contextPath}/">🏠 Inicio</a>
    <a href="${pageContext.request.contextPath}/medicos">👨‍⚕️ Médicos</a>
    <a href="${pageContext.request.contextPath}/pacientes">🧑‍🤝‍🧑 Pacientes</a>

    <!-- ACTIVO -->
    <a class="active" href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>

    <a href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
</div>

<div class="content">

    <h2>${it == null ? "Nueva Obra Social" : "Editar Obra Social"}</h2>

    <form method="post" action="${pageContext.request.contextPath}/obras-sociales/${it == null ? "crear" : "actualizar"}">

        <c:if test="${it != null}">
            <input type="hidden" name="id" value="${it.id}">
        </c:if>

        <label>Nombre:</label><br>
        <input type="text" name="nombre" value="${it != null ? it.nombre : ''}" required><br><br>

        <button type="submit">Guardar</button>
    </form>

</div>

</body>
</html>
