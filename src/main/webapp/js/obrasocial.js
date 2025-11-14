// ========================================
//  GESTIÓN DE OBRAS SOCIALES
// ========================================

function abrirNuevo() {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-plus"></i> Nueva Obra Social';
    document.getElementById("form-action").value = "crear";
    document.getElementById("form-id").value = "";
    document.getElementById("form-nombre").value = "";

    modalForm.showModal();
}

function abrirEditar(id, nombre) {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-edit"></i> Editar Obra Social';
    document.getElementById("form-action").value = "actualizar";
    document.getElementById("form-id").value = id;
    document.getElementById("form-nombre").value = nombre;

    modalForm.showModal();
}

function eliminarObraSocial(id) {
    confirmarEliminacion(
        "¿Estás seguro de eliminar esta obra social?",
        function() {
            window.location.href = "/app/obras-sociales/eliminar/" + id;
        }
    );
}

// Validación del formulario antes de enviar (opcional, ya que el servidor valida)
document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector('form[action="/app/obras-sociales"]');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            const nombre = document.getElementById('form-nombre').value.trim();
            
            if (!nombre) {
                e.preventDefault();
                mostrarError('Validación', 'El nombre es obligatorio');
                return false;
            }
            
            if (nombre.length < 2) {
                e.preventDefault();
                mostrarError('Validación', 'El nombre debe tener al menos 2 caracteres');
                return false;
            }
            
            if (nombre.length > 100) {
                e.preventDefault();
                mostrarError('Validación', 'El nombre no puede tener más de 100 caracteres');
                return false;
            }
        });
    }
});