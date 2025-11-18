function mostrarExito(titulo, mensaje) {
  Swal.fire({
    icon: "success",
    title: titulo || "Éxito",
    text: mensaje,
    confirmButtonText: '<i class="fas fa-check"></i> OK',
    confirmButtonColor: "#28a745",
  });
}

function mostrarError(titulo, mensaje) {
  Swal.fire({
    icon: "error",
    title: titulo || "Error",
    text: mensaje,
    confirmButtonText: '<i class="fas fa-times"></i> OK',
    confirmButtonColor: "#dc3545",
  });
}

function mostrarAdvertencia(titulo, mensaje) {
  Swal.fire({
    icon: "warning",
    title: titulo || "Advertencia",
    text: mensaje,
    confirmButtonText: '<i class="fas fa-exclamation-triangle"></i> OK',
    confirmButtonColor: "#ffc107",
  });
}

function confirmarEliminacion(mensaje, callback) {
  Swal.fire({
    title: "¿Estás seguro?",
    text: mensaje || "Esta acción no se puede deshacer",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#dc3545",
    cancelButtonColor: "#6c757d",
    confirmButtonText: '<i class="fas fa-trash"></i> Sí, eliminar',
    cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
    reverseButtons: true,
  }).then((result) => {
    if (result.isConfirmed && callback) {
      callback();
    }
  });
}

function confirmarAccion(titulo, mensaje, callback, textoBoton = "Confirmar") {
  Swal.fire({
    title: titulo,
    text: mensaje,
    icon: "question",
    showCancelButton: true,
    confirmButtonColor: "#007bff",
    cancelButtonColor: "#6c757d",
    confirmButtonText: `<i class="fas fa-check"></i> ${textoBoton}`,
    cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
    reverseButtons: true,
  }).then((result) => {
    if (result.isConfirmed && callback) {
      callback();
    }
  });
}

function mostrarToast(tipo, mensaje) {
  const Toast = Swal.mixin({
    toast: true,
    position: "top-end",
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true,
    didOpen: (toast) => {
      toast.addEventListener("mouseenter", Swal.stopTimer);
      toast.addEventListener("mouseleave", Swal.resumeTimer);
    },
  });

  Toast.fire({
    icon: tipo,
    title: mensaje,
  });
}

function limpiarParametrosURL() {
  if (
    typeof window !== "undefined" &&
    window.history &&
    window.history.replaceState
  ) {
    const url = new URL(window.location);

    url.searchParams.delete("success");
    url.searchParams.delete("error");
    url.searchParams.delete("warning");
    url.searchParams.delete("info");

    window.history.replaceState(null, "", url);
  }
}