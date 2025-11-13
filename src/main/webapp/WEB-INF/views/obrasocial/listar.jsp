<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Obras Sociales</title>
    <style>
        body { margin:0; display:flex; font-family:Arial; }
        .sidebar { width:220px; background:#2d3e50; color:white; padding:15px; }
        .sidebar a { color:white; display:block; padding:8px; text-decoration:none; border-radius:4px; }
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

    <!-- ESTA ES LA ACTIVA -->
    <a class="active" href="${pageContext.request.contextPath}/obras-sociales">🏥 Obras Sociales</a>

    <a href="${pageContext.request.contextPath}/turnos">📅 Turnos</a>
</div>

<div class="content">

    <h2>Listado de Obras Sociales</h2>

    <a href="${pageContext.request.contextPath}/obras-sociales/nuevo">➕ Nueva Obra Social</a>

    <br><br>

    <table border="1" cellpadding="5">
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Activo</th>
            <th>Acciones</th>
        </tr>

        <c:forEach var="o" items="${items}">
            <tr>
                <td>${o.id}</td>
                <td>${o.nombre}</td>
                <td>${o.activo}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/obras-sociales/editar/${o.id}">Editar</a>
                    |
                    <a href="${pageContext.request.contextPath}/obras-sociales/eliminar/${o.id}">Eliminar</a>
                </td>
            </tr>
        </c:forEach>
    </table>

</div>

</body>
</html>
