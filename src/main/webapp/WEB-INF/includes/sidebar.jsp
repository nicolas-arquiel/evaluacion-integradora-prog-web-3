<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="currentPath" value="${pageContext.request.requestURI}" />

<div class="sidebar">
    <h2><i class="fas fa-heartbeat"></i> Salud Total</h2>
    
    <a href="/app/" class="${currentPath.matches('.*/app/?$') ? 'active' : ''}">
        <i class="fas fa-home"></i> Inicio
    </a>
    
    <a href="/app/medicos" class="${currentPath.contains('medicos') ? 'active' : ''}">
        <i class="fas fa-user-md"></i> Médicos
    </a>

    <a href="/app/especialidades" class="${currentPath.contains('especialidades') ? 'active' : ''}">
        <i class="fas fa-stethoscope"></i> Especialidades
    </a>
    
    <a href="/app/pacientes" class="${currentPath.contains('pacientes') ? 'active' : ''}">
        <i class="fas fa-users"></i> Pacientes
    </a>
    
    <a href="/app/obras-sociales" class="${currentPath.contains('obras-sociales') ? 'active' : ''}">
        <i class="fas fa-hospital"></i> Obras Sociales
    </a>
    
    <a href="/app/turnos" class="${currentPath.contains('turnos') ? 'active' : ''}">
        <i class="fas fa-calendar-alt"></i> Turnos
    </a>
    
    <a href="/app/reportes" class="${currentPath.contains('reportes') ? 'active' : ''}">
        <i class="fas fa-chart-bar"></i> Reportes
    </a>
</div>
