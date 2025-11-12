<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>Nuevo Turno</title>
<script>
async function cargarObras() {
  const idPaciente = document.getElementById("paciente").value;
  const obrasSelect = document.getElementById("obras");
  const medicosSelect = document.getElementById("medico");
  obrasSelect.innerHTML = "";
  medicosSelect.innerHTML = "";
  if (!idPaciente) return;

  const res = await fetch(`/turnos/obras-sociales-paciente/${idPaciente}`);
  const obras = await res.json();
  obras.forEach(o => {
    const opt = document.createElement("option");
    opt.value = o.id;
    opt.text = o.nombre;
    obrasSelect.appendChild(opt);
  });
}

async function cargarMedicos() {
  const obras = Array.from(document.getElementById("obras").selectedOptions).map(o => o.value);
  const medicosSelect = document.getElementById("medico");
  medicosSelect.innerHTML = "";
  if (obras.length === 0) return;

  const params = new URLSearchParams();
  obras.forEach(o => params.append("obras", o));
  const res = await fetch(`/turnos/medicos-disponibles?${params.toString()}`);
  const medicos = await res.json();
  medicos.forEach(m => {
    const opt = document.createElement("option");
    opt.value = m.id;
    opt.text = `${m.nombre} (${m.especialidad})`;
    medicosSelect.appendChild(opt);
  });
}
</script>
</head>
<body>
<h2>Registrar Turno</h2>
<form action="${pageContext.request.contextPath}/turnos" method="post">
  <label>Paciente:</label>
  <select id="paciente" name="idPaciente" onchange="cargarObras()" required>
    <option value="">-- Seleccione --</option>
    <c:forEach var="p" items="${it.pacientes}">
      <option value="${p.id}">${p.nombreCompleto}</option>
    </c:forEach>
  </select><br/>

  <label>Obras Sociales:</label>
  <select id="obras" multiple size="3" onchange="cargarMedicos()"></select><br/>

  <label>Médico:</label>
  <select id="medico" name="idMedico" required></select><br/>

  <label>Fecha:</label>
  <input type="date" name="fecha" required><br/>

  <label>Hora:</label>
  <input type="time" name="hora" required><br/>

  <button type="submit">Guardar</button>
</form>
<a href="${pageContext.request.contextPath}/turnos">Volver</a>
</body>
</html>
