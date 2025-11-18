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

    // LISTAR
    @GET
    @View("turnos/index.jsp")
    public void listar(
            @QueryParam("idMedico") Integer idMedico,
            @QueryParam("desde") String desde,
            @QueryParam("hasta") String hasta,
            @QueryParam("estado") List<Integer> estados,
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {

        List<Medico> medicosActivos = repoMedicos.listar()
                .stream()
                .filter(Medico::isActivo)
                .toList();

        List<Paciente> pacientesActivos = repoPacientes.listar()
                .stream()
                .filter(Paciente::isActivo)
                .toList();

        models.put("medicos", medicosActivos);
        models.put("pacientes", pacientesActivos);

        boolean hayFiltros =
                idMedico != null ||
                (desde != null && !desde.isEmpty()) ||
                (hasta != null && !hasta.isEmpty()) ||
                (estados != null && !estados.isEmpty());

        List<Turno> lista;

        if (hayFiltros) {
            lista = repo.filtrar(idMedico, desde, hasta, estados);
        } else {
            lista = repo.listar();
        }

        models.put("turnos", lista);

        if (success != null) models.put("success", success);
        if (error != null) models.put("error", error);
        if (warning != null) models.put("warning", warning);
        if (info != null) models.put("info", info);
    }


    // GUARDAR
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("id") Integer id,
            @FormParam("pacienteId") int pacienteId,
            @FormParam("medicoId") int medicoId,
            @FormParam("fecha") String fecha,
            @FormParam("hora") String hora,
            @FormParam("notas") String notas,
            @FormParam("estadoId") Integer estadoId
    ) {
        try {

            if (fecha == null || fecha.trim().isEmpty()) {
                return AlertUtils.redirectWithError("/turnos",
                        "Debe seleccionar una fecha para el turno");
            }
            if (hora == null || hora.trim().isEmpty()) {
                return AlertUtils.redirectWithError("/turnos",
                        "Debe seleccionar una hora para el turno");
            }

            LocalDate fechaTurno = LocalDate.parse(fecha);
            LocalTime horaTurno = LocalTime.parse(hora);
            LocalDate hoy = LocalDate.now();
            LocalTime horaActual = LocalTime.now();

            // Validación básica
            if (fechaTurno.isBefore(hoy)) {
                return AlertUtils.redirectWithError("/turnos",
                        "No puede agendar turnos en fechas pasadas");
            }

            Paciente paciente = repoPacientes.obtenerPorId(pacienteId);
            if (paciente == null || !paciente.isActivo()) {
                return AlertUtils.redirectWithError("/turnos",
                        "El paciente seleccionado no está activo");
            }

            Medico medico = repoMedicos.obtenerPorId(medicoId);
            if (medico == null || !medico.isActivo()) {
                return AlertUtils.redirectWithError("/turnos",
                        "El médico seleccionado no está activo");
            }

            // Validación obra social
            if (!medico.getObrasSocialesIds().contains(paciente.getObraSocialId())) {
                return AlertUtils.redirectWithError("/turnos",
                        "El médico no atiende la obra social del paciente");
            }

            Turno t = new Turno();
            t.setPacienteId(pacienteId);
            t.setMedicoId(medicoId);
            t.setFecha(Date.valueOf(fecha));
            t.setHora(Time.valueOf(hora + ":00"));
            t.setNotas(notas);
            t.setEstadoId(estadoId != null ? estadoId : 1);

            if (id == null || id == 0) {
                repo.insertar(t);
                return AlertUtils.redirectWithSuccess("/turnos",
                        "Turno creado correctamente");
            } else {
                t.setId(id);
                repo.actualizar(t);
                return AlertUtils.redirectWithSuccess("/turnos",
                        "Turno actualizado correctamente");
            }

        } catch (SQLException e) {
            return AlertUtils.redirectWithError("/turnos", e.getMessage());
        } catch (Exception e) {
            return AlertUtils.redirectWithError("/turnos",
                    "Error inesperado: " + e.getMessage());
        }
    }

    // CANCELAR
    @GET
    @Path("/cancelar/{id}")
    public String cancelar(@PathParam("id") int id) {
        try {
            Turno turno = repo.buscarPorId(id);
            if (turno == null) {
                return AlertUtils.redirectWithError("/turnos",
                        "El turno no existe");
            }

            turno.setEstadoId(2);
            repo.actualizar(turno);

            return AlertUtils.redirectWithSuccess("/turnos",
                    "Turno cancelado correctamente");

        } catch (Exception e) {
            return AlertUtils.redirectWithError("/turnos",
                    "Error inesperado: " + e.getMessage());
        }
    }

    // COMPLETAR
    @GET
    @Path("/completar/{id}")
    public String completar(@PathParam("id") int id) {
        try {
            Turno turno = repo.buscarPorId(id);
            if (turno == null) {
                return AlertUtils.redirectWithError("/turnos", "El turno no existe");
            }

            turno.setEstadoId(3);
            repo.actualizar(turno);

            return AlertUtils.redirectWithSuccess("/turnos",
                    "Turno completado correctamente");

        } catch (Exception e) {
            return AlertUtils.redirectWithError("/turnos",
                    "No se pudo completar: " + e.getMessage());
        }
    }
}
