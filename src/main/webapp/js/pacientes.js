// ========================================
//  GESTIÓN DE PACIENTES
// ========================================

function abrirNuevo() {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-user-plus"></i> Nuevo Paciente';
    document.getElementById("form-action").value = "crear";
    document.getElementById("form-id").value = "";

    document.getElementById("form-nombre").value = "";
    document.getElementById("form-email").value = "";
    document.getElementById("form-telefono").value = "";
    document.getElementById("form-documento").value = "";
    document.getElementById("form-obra-social").value = "";

    modalForm.showModal();
}

function abrirEditar(id, nombre, email, telefono, documento, obraSocialId) {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-user-edit"></i> Editar Paciente';
    document.getElementById("form-action").value = "actualizar";
    document.getElementById("form-id").value = id;

    document.getElementById("form-nombre").value = nombre;
    document.getElementById("form-email").value = email;
    document.getElementById("form-telefono").value = telefono;
    document.getElementById("form-documento").value = documento;
    document.getElementById("form-obra-social").value = obraSocialId;

    modalForm.showModal();
}

function eliminarPaciente(id) {
    confirmarEliminacion(
        "¿Estás seguro de eliminar este paciente?",
        function() {
            window.location.href = "/app/pacientes/eliminar/" + id;
        }
    );
}