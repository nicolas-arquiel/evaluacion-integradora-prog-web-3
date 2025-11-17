// =======================================
//   MOSTRAR/OCULTAR SECCIONES DE REPORTE
// =======================================

function mostrarReporte(id) {

    const secciones = document.querySelectorAll(".report-section");

    secciones.forEach(sec => sec.classList.remove("active"));

    const target = document.getElementById("report-" + id);

    if (target) {
        target.classList.add("active");
    }
}
