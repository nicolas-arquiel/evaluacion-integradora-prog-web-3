<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Sistema de Turnos Médicos</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      display: flex;
      height: 100vh;
    }

    .sidebar {
      width: 220px;
      background-color: #2d3e50;
      color: white;
      display: flex;
      flex-direction: column;
      padding: 15px;
    }

    .sidebar h2 {
      color: #f1cc31;
      font-size: 18px;
      margin-bottom: 10px;
      text-align: center;
    }

    .nav-link {
      color: white;
      text-decoration: none;
      padding: 10px;
      margin: 5px 0;
      border-radius: 5px;
      display: block;
    }

    .nav-link:hover, .nav-link.active {
      background-color: #f1cc31;
      color: #2d3e50;
      font-weight: bold;
    }

    .content {
      flex: 1;
      padding: 20px;
      background-color: #f8f8f8;
      overflow-y: auto;
    }

    iframe {
      border: none;
      width: 100%;
      height: calc(100vh - 40px);
    }
  </style>

  <script>
    function navigate(section) {
      const links = document.querySelectorAll('.nav-link');
      links.forEach(l => l.classList.remove('active'));
      document.getElementById('link-' + section).classList.add('active');
      document.getElementById('content-frame').src = section;
      history.pushState({}, '', section);
    }

    window.onload = () => {
      const path = window.location.pathname.replace('/', '') || 'home';
      navigate(path);
    };
  </script>
</head>
<body>
  <div class="sidebar">
    <h2>Salud Total</h2>
    <a href="javascript:void(0)" id="link-medicos" class="nav-link" onclick="navigate('medicos')">👨‍⚕️ Médicos</a>
    <a href="javascript:void(0)" id="link-pacientes" class="nav-link" onclick="navigate('pacientes')">🧑‍🤝‍🧑 Pacientes</a>
    <a href="javascript:void(0)" id="link-obras-sociales" class="nav-link" onclick="navigate('obras-sociales')">🏥 Obras Sociales</a>
    <a href="javascript:void(0)" id="link-turnos" class="nav-link" onclick="navigate('turnos')">📅 Turnos</a>
  </div>

  <div class="content">
    <iframe id="content-frame" src=""></iframe>
  </div>
</body>
</html>
