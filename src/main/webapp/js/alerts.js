// ========================================
//  SISTEMA GLOBAL DE ALERTAS
// ========================================

/**
 * Muestra alerta de éxito
 * @param {string} titulo - Título de la alerta
 * @param {string} mensaje - Mensaje de la alerta
 */
function mostrarExito(titulo, mensaje) {
    Swal.fire({
        icon: 'success',
        title: titulo || 'Éxito',
        text: mensaje,
        confirmButtonText: '<i class="fas fa-check"></i> OK',
        confirmButtonColor: '#28a745'
    });
}

/**
 * Muestra alerta de error
 * @param {string} titulo - Título de la alerta
 * @param {string} mensaje - Mensaje de error
 */
function mostrarError(titulo, mensaje) {
    Swal.fire({
        icon: 'error',
        title: titulo || 'Error',
        text: mensaje,
        confirmButtonText: '<i class="fas fa-times"></i> OK',
        confirmButtonColor: '#dc3545'
    });
}

/**
 * Muestra alerta de advertencia
 * @param {string} titulo - Título de la alerta
 * @param {string} mensaje - Mensaje de advertencia
 */
function mostrarAdvertencia(titulo, mensaje) {
    Swal.fire({
        icon: 'warning',
        title: titulo || 'Advertencia',
        text: mensaje,
        confirmButtonText: '<i class="fas fa-exclamation-triangle"></i> OK',
        confirmButtonColor: '#ffc107'
    });
}

/**
 * Muestra confirmación de eliminación
 * @param {string} mensaje - Mensaje de confirmación
 * @param {function} callback - Función a ejecutar si confirma
 */
function confirmarEliminacion(mensaje, callback) {
    Swal.fire({
        title: '¿Estás seguro?',
        text: mensaje || "Esta acción no se puede deshacer",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-trash"></i> Sí, eliminar',
        cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed && callback) {
            callback();
        }
    });
}

/**
 * Muestra confirmación genérica
 * @param {string} titulo - Título de la confirmación
 * @param {string} mensaje - Mensaje de confirmación
 * @param {function} callback - Función a ejecutar si confirma
 * @param {string} textoBoton - Texto del botón de confirmación
 */
function confirmarAccion(titulo, mensaje, callback, textoBoton = 'Confirmar') {
    Swal.fire({
        title: titulo,
        text: mensaje,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#007bff',
        cancelButtonColor: '#6c757d',
        confirmButtonText: `<i class="fas fa-check"></i> ${textoBoton}`,
        cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed && callback) {
            callback();
        }
    });
}

/**
 * Muestra notificación toast (pequeña y temporal)
 * @param {string} tipo - 'success', 'error', 'warning', 'info'
 * @param {string} mensaje - Mensaje de la notificación
 */
function mostrarToast(tipo, mensaje) {
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer)
            toast.addEventListener('mouseleave', Swal.resumeTimer)
        }
    });

    Toast.fire({
        icon: tipo,
        title: mensaje
    });
}

/**
 * Limpia los parámetros de alerta de la URL
 */
function limpiarParametrosURL() {
    // Verificar si estamos en el navegador
    if (typeof window !== 'undefined' && window.history && window.history.replaceState) {
        const url = new URL(window.location);
        
        // Remover parámetros de alerta
        url.searchParams.delete('success');
        url.searchParams.delete('error');
        url.searchParams.delete('warning');
        url.searchParams.delete('info');
        
        // Actualizar URL sin recargar la página
        window.history.replaceState(null, '', url);
    }
}

// ========================================
//  AUTO-INICIALIZACIÓN AL CARGAR PÁGINA
// ========================================

document.addEventListener("DOMContentLoaded", function() {
    console.log("🔔 Sistema de alertas cargado");
});