<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Reportes y Estadísticas - Salud Total</title>
    <link rel="stylesheet" href="/css/reportes.css">

    <style>
        /* === ESTILOS ESPECÍFICOS DE REPORTES === */
        .report-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .report-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            border: 3px solid transparent;
        }

        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .report-card.selected {
            border: 3px solid #2e8bff;
            background: #e3f2fd;
            box-shadow: 0 4px 12px rgba(46, 139, 255, 0.3);
        }

        .report-card h3 {
            margin: 0 0 10px 0;
            font-size: 18px;
            color: #2d3e50;
        }

        .report-card .icon {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .report-card p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }

        .report-section {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: none;
        }

        .report-section.active {
            display: block;
            animation: fadeIn 0.3s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .report-section h2 {
            margin-top: 0;
            color: #2d3e50;
            border-bottom: 3px solid #2e8bff;
            padding-bottom: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .stat-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #2e8bff;
        }

        .stat-box h4 {
            margin: 0 0 10px 0;
            color: #666;
            font-size: 14px;
        }

        .stat-box .value {
            font-size: 32px;
            font-weight: bold;
            color: #2d3e50;
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>🏥 Salud Total</h2>
    <a href="/app/">🏠 Inicio</a>
    <a href="/app/medicos">👨‍⚕️ Médicos</a>
    <a href="/app/pacientes">🧑‍🤝‍🧑 Pacientes</a>
    <a href="/app/obras-sociales">🏥 Obras Sociales</a>
    <a href="/app/turnos">📅 Turnos</a>
    <a class="active" href="/app/reportes">📊 Reportes</a>
</div>

<!-- CONTENIDO PRINCIPAL -->
<div class="content">

    <h1>📊 Reportes y Estadísticas</h1>
    <p style="color: #666; margin-bottom: 30px;">Seleccione un tipo de reporte para ver las estadísticas detalladas</p>

    <!-- CARDS DE REPORTES -->
    <div class="report-cards">
        <div class="report-card" onclick="mostrarReporte('turnos-medico')" id="card-turnos-medico">
            <div class="icon">👨‍⚕️</div>
            <h3>Turnos por Médico</h3>
            <p>Cantidad de turnos atendidos por cada médico</p>
        </div>

        <div class="report-card" onclick="mostrarReporte('turnos-especialidad')" id="card-turnos-especialidad">
            <div class="icon">🏥</div>
            <h3>Turnos por Especialidad</h3>
            <p>Distribución de turnos según especialidad médica</p>
        </div>

        <div class="report-card" onclick="mostrarReporte('turnos-obra-social')" id="card-turnos-obra-social">
            <div class="icon">💳</div>
            <h3>Turnos por Obra Social</h3>
            <p>Cantidad de turnos según obra social del paciente</p>
        </div>

        <div class="report-card" onclick="mostrarReporte('estados-turnos')" id="card-estados-turnos">
            <div class="icon">📈</div>
            <h3>Estados de Turnos</h3>
            <p>Estadísticas de turnos programados, completados y cancelados</p>
        </div>

        <div class="report-card" onclick="mostrarReporte('turnos-mes')" id="card-turnos-mes">
            <div class="icon">📅</div>
            <h3>Turnos por Mes</h3>
            <p>Evolución mensual de la cantidad de turnos</p>
        </div>

        <div class="report-card" onclick="mostrarReporte('medicos-obras')" id="card-medicos-obras">
            <div class="icon">🔗</div>
            <h3>Médicos y Obras Sociales</h3>
            <p>Relación entre médicos y obras sociales aceptadas</p>
        </div>
    </div>

    <!-- ESTADO INICIAL -->
    <div class="report-section active" id="report-inicial">
        <div class="empty-state">
            <div class="icon">📊</div>
            <h3>Seleccione un reporte</h3>
            <p>Haga clic en una de las tarjetas superiores para ver las estadísticas</p>
        </div>
    </div>

    <!-- REPORTE: TURNOS POR MÉDICO -->
    <div class="report-section" id="report-turnos-medico">
        <h2>👨‍⚕️ Turnos por Médico</h2>
        
        <div class="stats-grid">
            <div class="stat-box">
                <h4>Total de Médicos</h4>
                <div class="value">${totalMedicos}</div>
            </div>
            <div class="stat-box">
                <h4>Promedio Turnos/Médico</h4>
                <div class="value">${promedioTurnosMedico}</div>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Médico</th>
                    <th>Especialidad</th>
                    <th>Turnos Programados</th>
                    <th>Turnos Completados</th>
                    <th>Turnos Cancelados</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reporteTurnosMedico}">
                    <tr>
                        <td>${r.nombreMedico}</td>
                        <td>${r.especialidad}</td>
                        <td>${r.programados}</td>
                        <td>${r.completados}</td>
                        <td>${r.cancelados}</td>
                        <td><strong>${r.total}</strong></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- REPORTE: TURNOS POR ESPECIALIDAD -->
    <div class="report-section" id="report-turnos-especialidad">
        <h2>🏥 Turnos por Especialidad</h2>

        <table>
            <thead>
                <tr>
                    <th>Especialidad</th>
                    <th>Cantidad de Turnos</th>
                    <th>Porcentaje</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reporteTurnosEspecialidad}">
                    <tr>
                        <td>${r.especialidad}</td>
                        <td><strong>${r.cantidad}</strong></td>
                        <td>${r.porcentaje}%</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- REPORTE: TURNOS POR OBRA SOCIAL -->
    <div class="report-section" id="report-turnos-obra-social">
        <h2>💳 Turnos por Obra Social</h2>

        <table>
            <thead>
                <tr>
                    <th>Obra Social</th>
                    <th>Cantidad de Pacientes</th>
                    <th>Cantidad de Turnos</th>
                    <th>Promedio Turnos/Paciente</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reporteTurnosObraSocial}">
                    <tr>
                        <td>${r.obraSocial}</td>
                        <td>${r.cantidadPacientes}</td>
                        <td><strong>${r.cantidadTurnos}</strong></td>
                        <td>${r.promedio}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- REPORTE: ESTADOS DE TURNOS -->
    <div class="report-section" id="report-estados-turnos">
        <h2>📈 Estados de Turnos</h2>

        <div class="stats-grid">
            <div class="stat-box" style="border-left-color: #2e8bff;">
                <h4>Programados</h4>
                <div class="value" style="color: #2e8bff;">${estadosProgramados}</div>
            </div>
            <div class="stat-box" style="border-left-color: #4caf50;">
                <h4>Completados</h4>
                <div class="value" style="color: #4caf50;">${estadosCompletados}</div>
            </div>
            <div class="stat-box" style="border-left-color: #d32f2f;">
                <h4>Cancelados</h4>
                <div class="value" style="color: #d32f2f;">${estadosCancelados}</div>
            </div>
            <div class="stat-box" style="border-left-color: #666;">
                <h4>Total</h4>
                <div class="value">${estadosTotal}</div>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Estado</th>
                    <th>Cantidad</th>
                    <th>Porcentaje</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reporteEstados}">
                    <tr>
                        <td>${r.estado}</td>
                        <td><strong>${r.cantidad}</strong></td>
                        <td>${r.porcentaje}%</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- REPORTE: TURNOS POR MES -->
    <div class="report-section" id="report-turnos-mes">
        <h2>📅 Turnos por Mes</h2>

        <table>
            <thead>
                <tr>
                    <th>Mes</th>
                    <th>Año</th>
                    <th>Programados</th>
                    <th>Completados</th>
                    <th>Cancelados</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reporteTurnosMes}">
                    <tr>
                        <td>${r.mes}</td>
                        <td>${r.anio}</td>
                        <td>${r.programados}</td>
                        <td>${r.completados}</td>
                        <td>${r.cancelados}</td>
                        <td><strong>${r.total}</strong></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- REPORTE: MÉDICOS Y OBRAS SOCIALES -->
    <div class="report-section" id="report-medicos-obras">
        <h2>🔗 Médicos y Obras Sociales</h2>

        <table>
            <thead>
                <tr>
                    <th>Médico</th>
                    <th>Especialidad</th>
                    <th>Obras Sociales Aceptadas</th>
                    <th>Cantidad</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reporteMedicosObras}">
                    <tr>
                        <td>${r.nombreMedico}</td>
                        <td>${r.especialidad}</td>
                        <td>${r.obrasSociales}</td>
                        <td><strong>${r.cantidad}</strong></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div>

<script>
let reporteActual = null;

function mostrarReporte(tipoReporte) {
    document.querySelectorAll('.report-card').forEach(card => {
        card.classList.remove('selected');
    });

    document.querySelectorAll('.report-section').forEach(section => {
        section.classList.remove('active');
    });

    document.getElementById('card-' + tipoReporte).classList.add('selected');
    document.getElementById('report-' + tipoReporte).classList.add('active');

    reporteActual = tipoReporte;
}
</script>

</body>
</html>