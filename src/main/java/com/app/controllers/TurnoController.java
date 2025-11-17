package com.app.controllers;

import com.app.models.Turno;
import com.app.models.Medico;
import com.app.models.Paciente;
import com.app.repositories.MedicoRepository;
import com.app.repositories.PacienteRepository;
import com.app.repositories.TurnoRepository;
import com.app.utils.AlertUtils;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@RequestScoped
@Path("/turnos")
@Controller
public class TurnoController {

    private final TurnoRepository repo = new TurnoRepository();
    private final MedicoRepository repoMedicos = new MedicoRepository();
    private final PacienteRepository repoPacientes = new PacienteRepository();

    @Inject
    private Models models;

    // ==========================================
    // LISTAR + FILTROS + DATOS COMPLETOS
    // ==========================================
    @GET
    @View("turnos/index.jsp")
    public void listar(
            @QueryParam("idMedico") Integer idMedico,
            @QueryParam("desde") String desde,
            @QueryParam("hasta") String hasta,
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {
        List<Medico> todosMedicos = repoMedicos.listar();
        models.put("medicos", todosMedicos);

        List<Paciente> todosPacientes = repoPacientes.listar();
        models.put("pacientes", todosPacientes);

        List<Turno> lista;
        boolean filtraFechas = (desde != null && !desde.isEmpty()) ||
                               (hasta != null && !hasta.isEmpty());

        if (idMedico != null || filtraFechas) {
            lista = repo.filtrar(idMedico, desde, hasta);
        } else {
            lista = repo.listar();
        }

        models.put("turnos", lista);

        if (success != null && !success.isEmpty()) models.put("success", success);
        if (error != null && !error.isEmpty()) models.put("error", error);
        if (warning != null && !warning.isEmpty()) models.put("warning", warning);
        if (info != null && !info.isEmpty()) models.put("info", info);
    }

    // ==========================================
    // GUARDAR CON VALIDACIONES
    // ==========================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("id") Integer id,
            @FormParam("pacienteId") int pacienteId,
            @FormParam("medicoId") int medicoId,
            @FormParam("fecha") String fecha,
            @FormParam("hora") String hora,
            @FormParam("notas") String notas,

            // ★ AGREGADO: Se permite recibir estadoId (si viene)
            @FormParam("estadoId") Integer estadoId
    ) {
        try {
            // ===============================
            // VALIDACIONES ORIGINALES
            // ===============================

            if (fecha == null || fecha.trim().isEmpty()) {
                return AlertUtils.redirectWithError("/turnos", "Debe seleccionar una fecha para el turno");
            }
            if (hora == null || hora.trim().isEmpty()) {
                return AlertUtils.redirectWithError("/turnos", "Debe seleccionar una hora para el turno");
            }

            LocalDate fechaTurno = LocalDate.parse(fecha);
            LocalTime horaTurno = LocalTime.parse(hora);
            LocalDate hoy = LocalDate.now();
            LocalTime horaActual = LocalTime.now();

            if (fechaTurno.isBefore(hoy)) {
                return AlertUtils.redirectWithError("/turnos", "No es posible agendar turnos en fechas pasadas");
            }

            if (fechaTurno.equals(hoy) && horaTurno.isBefore(horaActual)) {
                return AlertUtils.redirectWithError("/turnos", "No es posible agendar turnos en horas pasadas");
            }

            if (horaTurno.isBefore(LocalTime.of(8, 0)) || horaTurno.isAfter(LocalTime.of(17, 45))) {
                return AlertUtils.redirectWithError("/turnos",
                        "Los turnos deben estar dentro del horario de atención (8:00 a 17:45 hs)");
            }

            if (fechaTurno.getDayOfWeek().getValue() >= 6) {
                return AlertUtils.redirectWithError("/turnos",
                        "La clínica no atiende los fines de semana. Seleccione un día de lunes a viernes");
            }

            if (fechaTurno.equals(hoy)) {
                LocalTime limite = LocalTime.of(16, 45);
                if (horaActual.isAfter(limite)) {
                    return AlertUtils.redirectWithError("/turnos",
                            "No es posible agendar más turnos para hoy. Último turno disponible: 17:45 hs");
                }

                LocalTime horaMinima = horaActual.plusHours(1);
                if (horaTurno.isBefore(horaMinima)) {
                    return AlertUtils.redirectWithError("/turnos",
                            "Los turnos para el día actual requieren al menos 1 hora de anticipación. " +
                            "Próximo horario disponible: " + horaMinima.toString().substring(0, 5));
                }
            }

            Paciente paciente = repoPacientes.obtenerPorId(pacienteId);
            if (paciente == null) {
                return AlertUtils.redirectWithError("/turnos",
                        "El paciente seleccionado no está registrado en el sistema");
            }

            List<Medico> medicos = repoMedicos.listar();
            Medico medico = medicos.stream()
                    .filter(m -> m.getId() == medicoId)
                    .findFirst()
                    .orElse(null);

            if (medico == null) {
                return AlertUtils.redirectWithError("/turnos",
                        "El médico seleccionado no está registrado en el sistema");
            }

            boolean medicoTieneObraSocial = medico.getObrasSocialesIds()
                    .contains(paciente.getObraSocialId());

            if (!medicoTieneObraSocial) {
                return AlertUtils.redirectWithError("/turnos",
                        medico.getNombre() + " no atiende pacientes de " + paciente.getObraSocialNombre() +
                                ". Verifique la cobertura médica");
            }

            // ===============================
            // CREAR OBJETO TURNO
            // ===============================
            Turno t = new Turno();
            t.setPacienteId(pacienteId);
            t.setMedicoId(medicoId);
            t.setFecha(Date.valueOf(fecha));
            t.setHora(Time.valueOf(hora + ":00"));
            t.setNotas(notas);
            t.setEstadoId(estadoId != null ? estadoId : 1);
            // ===============================
            // LOGICA ORIGINAL DE CREAR / EDITAR
            // ===============================
            if (id == null || id == 0) {
                repo.insertar(t);
                return AlertUtils.redirectWithSuccess("/turnos",
                        "Turno registrado exitosamente - Paciente: " + paciente.getNombre() +
                                " - Médico: " + medico.getNombre() + " - " + fecha + " " + hora + " hs");

            } else {
                Turno turnoExistente = repo.buscarPorId(id);
                if (turnoExistente == null) {
                    return AlertUtils.redirectWithError("/turnos",
                            "El turno seleccionado no existe o fue eliminado");
                }

                LocalDate fechaExistente = turnoExistente.getFecha().toLocalDate();
                if (fechaExistente.isBefore(hoy)) {
                    return AlertUtils.redirectWithError("/turnos",
                            "No es posible modificar turnos de fechas pasadas");
                }

                t.setId(id);
                repo.actualizar(t);

                return AlertUtils.redirectWithSuccess("/turnos",
                        "Turno actualizado exitosamente - Paciente: " + paciente.getNombre() +
                                " - Médico: " + medico.getNombre() + " - " + fecha + " " + hora + " hs");
            }

        } catch (SQLException e) {
            e.printStackTrace();

            if (e.getMessage().contains("Ya existe un turno")) {
                return AlertUtils.redirectWithError("/turnos",
                        "Conflicto de agenda: Dr. ya tiene un turno asignado en ese horario. Seleccione otro horario disponible");
            }

            return AlertUtils.redirectWithError("/turnos",
                    "Error del sistema al guardar el turno: " + e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/turnos",
                    "Error inesperado del sistema: " + e.getMessage());
        }
    }

    // ==========================================
    // CANCELAR CON VALIDACIONES
    // ==========================================
    @GET
    @Path("/cancelar/{id}")
    public String cancelar(@PathParam("id") int id) {
        try {
            Turno turno = repo.buscarPorId(id);
            if (turno == null) {
                return AlertUtils.redirectWithError("/turnos",
                        "El turno seleccionado no existe o ya fue eliminado");
            }

            LocalDate fechaTurno = turno.getFecha().toLocalDate();
            LocalTime horaTurno = turno.getHora().toLocalTime();
            LocalDate hoy = LocalDate.now();
            LocalTime horaActual = LocalTime.now();

            // ✔ NO permitir cancelar un turno COMPLETADO
            if (turno.getEstadoId() == 3) {
                return AlertUtils.redirectWithError("/turnos",
                        "No es posible cancelar un turno que ya fue COMPLETADO.");
            }

            // ✔ Mantener tu regla original: si el turno es HOY y faltan < 2 horas → no permitir
            if (fechaTurno.equals(hoy) && horaTurno.minusHours(2).isBefore(horaActual)) {
                return AlertUtils.redirectWithError("/turnos",
                        "Política de cancelación: No se pueden cancelar turnos con menos de 2 horas de anticipación.");
            }

            // ✔ Permitir cancelar turnos pasados
            repo.cancelar(id);

            return AlertUtils.redirectWithSuccess("/turnos",
                    "Turno cancelado exitosamente - Paciente: " + turno.getNombrePaciente() +
                            " - Médico: " + turno.getNombreMedico());

        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/turnos",
                    "Error del sistema al cancelar el turno: " + e.getMessage());
        }
    }


    // ==========================================
    // ★ AGREGADO — COMPLETAR TURNO
    // ==========================================
    @GET
    @Path("/completar/{id}")
    public String completar(@PathParam("id") int id) {
        try {
            Turno turno = repo.buscarPorId(id);
            if (turno == null) {
                return AlertUtils.redirectWithError("/turnos", "El turno no existe");
            }

            // no se tocan tus reglas de cancelación
            // solo se marca estado = 3

            turno.setEstadoId(3);  // completado

            repo.actualizar(turno);

            return AlertUtils.redirectWithSuccess("/turnos",
                    "Turno marcado como COMPLETADO correctamente");

        } catch (Exception e) {
            return AlertUtils.redirectWithError("/turnos",
                    "No se pudo completar el turno: " + e.getMessage());
        }
    }
}
