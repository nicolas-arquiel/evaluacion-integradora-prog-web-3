// ========================================
//  GESTIÓN DE TURNOS
// ========================================

// Variables globales para datos del servidor
let TODO_MEDICOS = [];
let TODO_PACIENTES = [];

// ========================================
//  INICIALIZACIÓN DE DATOS
// ========================================

function inicializarDatos() {
    const contentDiv = document.querySelector('.content');
    
    try {
        TODO_MEDICOS = JSON.parse(contentDiv.dataset.medicos);
        TODO_PACIENTES = JSON.parse(contentDiv.dataset.pacientes);
        
        console.log("✅ Médicos cargados:", TODO_MEDICOS.length);
        console.log("✅ Pacientes cargados:", TODO_PACIENTES.length);
    } catch (error) {
        console.error("❌ Error al cargar datos:", error);
        TODO_MEDICOS = [];
        TODO_PACIENTES = [];
    }
}

// ========================================
//  FUNCIONES DE MODAL
// ========================================

function resetCampos() {
    document.getElementById("obra-social-display").value = "";
    document.getElementById("medico").innerHTML = '<option value="">-- Primero seleccione el paciente --</option>';
    document.getElementById("notas").value = "";
    // ❌ SE ELIMINÓ SOLO ESTA LÍNEA
    // document.getElementById("estadoId").value = "1";
}

function abrirNuevo() {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-plus"></i> Agendar Nuevo Turno';
    document.getElementById("form-id").value = "";
    document.getElementById("paciente").value = "";
    document.getElementById("fecha").value = "";
    document.getElementById("hora").value = "";
    resetCampos();

    const hoy = new Date();
    document.getElementById("fecha").min = hoy.toISOString().split('T')[0];

    modalForm.showModal();
}

function abrirEditar(turno) {
    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-edit"></i> Modificar Turno Agendado';
    document.getElementById("form-id").value = turno.id;
    document.getElementById("paciente").value = turno.pacienteId;
    document.getElementById("fecha").value = turno.fecha;
    document.getElementById("hora").value = turno.hora;
    document.getElementById("notas").value = turno.notas || "";

    onPacienteChange();

    setTimeout(() => {
        document.getElementById("medico").value = turno.medicoId;
    }, 100);

    // ❌ SE ELIMINÓ SOLO ESTA PARTE
    // if (turno.estadoId) {
    //     document.getElementById("estadoId").value = turno.estadoId;
    // }

    modalForm.showModal();
}

// Función para actualizar horas disponibles según la fecha
function actualizarHorasDisponibles() {
    const fechaInput = document.getElementById("fecha");
    const horaInput = document.getElementById("hora");
    const fechaSeleccionada = fechaInput.value;
    const hoy = new Date().toISOString().split('T')[0];
    
    if (!fechaSeleccionada) return;
    
    const fecha = new Date(fechaSeleccionada + 'T00:00:00');
    const diaSemana = fecha.getDay();
    
    if (diaSemana === 0 || diaSemana === 6) {
        modalForm.close();
        setTimeout(() => {
            mostrarError("Día no hábil", 
                "La clínica no atiende los fines de semana. Por favor seleccione un día de lunes a viernes.");
        }, 100);
        fechaInput.value = "";
        return;
    }
    
    if (fechaSeleccionada === hoy) {
        const ahora = new Date();
        const horaActual = ahora.getHours();
        const minutosActuales = ahora.getMinutes();
        
        if (horaActual > 16 || (horaActual === 16 && minutosActuales > 45)) {
            modalForm.close();
            setTimeout(() => {
                mostrarAdvertencia("Horario cerrado", 
                    "No es posible agendar más turnos para hoy. El último turno disponible es a las 17:45 hs.");
            }, 100);
            return;
        }
        
        const horaMinima = horaActual + 1;
        const minutosMinimos = Math.ceil(minutosActuales / 15) * 15;
        
        let horaFinal = horaMinima;
        let minutosFinal = minutosMinimos;
        
        if (minutosFinal >= 60) {
            horaFinal += 1;
            minutosFinal = 0;
        }
        
        if (horaFinal < 8) {
            horaFinal = 8;
            minutosFinal = 0;
        }
        
        const horaString = horaFinal.toString().padStart(2, '0') + ":" + 
                          minutosFinal.toString().padStart(2, '0');
        
        horaInput.min = horaString;
        
        mostrarToast("info", `Horarios disponibles hoy desde las ${horaString}`);
    } else {
        horaInput.min = "08:00";
    }
}

// ========================================
//  LÓGICA DE FILTRADO
// ========================================

function onPacienteChange() {
    const sel = document.getElementById("paciente");
    const idPaciente = parseInt(sel.value);

    if (!idPaciente) {
        resetCampos();
        return;
    }

    const paciente = TODO_PACIENTES.find(p => p.id === idPaciente);

    if (!paciente) {
        console.warn("⚠️ Paciente no encontrado");
        resetCampos();
        return;
    }

    document.getElementById("obra-social-display").value = paciente.obraSocialNombre || "Sin cobertura";
    cargarMedicos(paciente.obraSocialId);
}

function cargarMedicos(obraSocialId) {
    const medicoSelect = document.getElementById("medico");
    medicoSelect.innerHTML = "";

    if (!obraSocialId) {
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = "-- Paciente sin cobertura médica --";
        medicoSelect.appendChild(opt);
        return;
    }

    const medicosFiltrados = TODO_MEDICOS.filter(medico => {
        return medico.obras.includes(parseInt(obraSocialId));
    });

    if (medicosFiltrados.length === 0) {
        const opt = document.createElement("option");
        opt.value = "";
        opt.textContent = "-- No hay médicos disponibles para esta cobertura --";
        medicoSelect.appendChild(opt);
        return;
    }

    const optDefault = document.createElement("option");
    optDefault.value = "";
    optDefault.textContent = "-- Seleccionar médico --";
    medicoSelect.appendChild(optDefault);

    medicosFiltrados.forEach(medico => {
        const opt = document.createElement("option");
        opt.value = medico.id;
        opt.textContent = `${medico.nombre} (${medico.especialidad})`;
        medicoSelect.appendChild(opt);
    });
}

// ========================================
//  ACCIONES
// ========================================

function cancelarTurno(id) {
    confirmarEliminacion(
        "¿Confirma la cancelación de este turno?",
        function() {
            window.location.href = "/app/turnos/cancelar/" + id;
        }
    );
}

function completarTurno(id) {
    window.location.href = "/app/turnos/completar/" + id;
}

// ========================================
//  INICIALIZACIÓN
// ========================================

document.addEventListener("DOMContentLoaded", () => {
    inicializarDatos();

    const btns = document.querySelectorAll(".btn-editar");
    btns.forEach(btn => {
        btn.addEventListener("click", () => {
            const turno = {
                id:            btn.dataset.id,
                pacienteId:    parseInt(btn.dataset.pacienteid),
                medicoId:      parseInt(btn.dataset.medicoid),
                fecha:         btn.dataset.fecha,
                hora:          btn.dataset.hora.substring(0, 5),
                obraSocialId:  parseInt(btn.dataset.obrasocialid),
                notas:         btn.dataset.notas || "",
                estadoId:      parseInt(btn.dataset.estadoid || "1")
            };

            abrirEditar(turno);
        });
    });

    const fechaInput = document.getElementById("fecha");
    if (fechaInput) {
        fechaInput.addEventListener('change', actualizarHorasDisponibles);
    }
});
