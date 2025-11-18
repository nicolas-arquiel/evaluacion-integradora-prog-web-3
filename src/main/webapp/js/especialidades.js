function abrirNuevo() {
  document.getElementById("modalTitle").innerHTML =
    '<i class="fas fa-plus"></i> Nueva Especialidad';

  document.getElementById("form-id").value = "";
  document.getElementById("descripcion").value = "";

  modalForm.showModal();
}

function abrirEditar(data) {
  document.getElementById("modalTitle").innerHTML =
    '<i class="fas fa-edit"></i> Editar Especialidad';

  document.getElementById("form-id").value = data.id;
  document.getElementById("descripcion").value = data.descripcion;

  modalForm.showModal();
}

function eliminarEspecialidad(id) {
  confirmarEliminacion("¿Eliminar esta especialidad?", function () {
    window.location.href = "/app/especialidades/eliminar/" + id;
  });
}

document.addEventListener("DOMContentLoaded", () => {
  const btns = document.querySelectorAll(".btn-editar");

  btns.forEach((btn) => {
    btn.addEventListener("click", () => {
      abrirEditar({
        id: btn.dataset.id,
        descripcion: btn.dataset.descripcion,
      });
    });
  });
});
