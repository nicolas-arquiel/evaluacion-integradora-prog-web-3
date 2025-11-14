// ========================================
//  GESTIÓN DE MÉDICOS
// ========================================

function abrirNuevo() {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-user-plus"></i> Nuevo Médico';
    document.getElementById("form-action").value = "crear";
    document.getElementById("form-id").value = "";
    document.getElementById("form-nombre").value = "";
    document.getElementById("form-especialidad").value = "";
    document.getElementById("form-matricula").value = "";

    // Limpiar checkboxes
    const checkboxes = document.querySelectorAll(".chk-obra");
    checkboxes.forEach(cb => cb.checked = false);

    modalForm.showModal();
}

function abrirEditar(id, nombre, especialidadId, matricula, obrasSocialesIds) {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-user-edit"></i> Editar Médico';
    document.getElementById("form-action").value = "actualizar";
    document.getElementById("form-id").value = id;
    document.getElementById("form-nombre").value = nombre;
    document.getElementById("form-especialidad").value = especialidadId;
    document.getElementById("form-matricula").value = matricula;

    // Limpiar checkboxes primero
    const checkboxes = document.querySelectorAll(".chk-obra");
    checkboxes.forEach(cb => cb.checked = false);

    // Marcar las obras sociales correspondientes
    if (obrasSocialesIds && obrasSocialesIds.trim() !== "") {
        const ids = obrasSocialesIds.split(",");
        ids.forEach(obraId => {
            const checkbox = document.querySelector(`input[value="${obraId.trim()}"]`);
            if (checkbox) checkbox.checked = true;
        });
    }

    modalForm.showModal();
}

function eliminarMedico(id) {
    confirmarEliminacion(
        "¿Estás seguro de eliminar este médico?",
        function() {
            window.location.href = "/app/medicos/eliminar/" + id;
        }
    );
}