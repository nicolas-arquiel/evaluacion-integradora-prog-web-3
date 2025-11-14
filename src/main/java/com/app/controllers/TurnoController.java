package com.app.controllers;

import com.app.models.Turno;
import com.app.models.Medico;
import com.app.models.Paciente;
import com.app.repositories.MedicoRepository;
import com.app.repositories.PacienteRepository;
import com.app.repositories.TurnoRepository;

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
            @QueryParam("hasta") String hasta
    ) {
        // Cargar TODOS los médicos con sus obras sociales
        List<Medico> todosMedicos = repoMedicos.listar();
        models.put("medicos", todosMedicos);

        // Cargar TODOS los pacientes (cada uno con su obra social)
        List<Paciente> todosPacientes = repoPacientes.listar();
        models.put("pacientes", todosPacientes);

        // Filtrar turnos si hay criterios
        List<Turno> lista;
        boolean filtraFechas = (desde != null && !desde.isEmpty()) ||
                               (hasta != null && !hasta.isEmpty());

        if (idMedico != null || filtraFechas) {
            lista = repo.filtrar(idMedico, desde, hasta);
        } else {
            lista = repo.listar();
        }

        models.put("turnos", lista);
    }

    // ==========================================
    // GUARDAR
    // ==========================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("id") Integer id,
            @FormParam("pacienteId") int pacienteId,
            @FormParam("medicoId") int medicoId,
            @FormParam("fecha") String fecha,
            @FormParam("hora") String hora,
            @FormParam("notas") String notas
    ) {
        try {
            Turno t = new Turno();
            t.setPacienteId(pacienteId);
            t.setMedicoId(medicoId);
            t.setFecha(Date.valueOf(fecha));
            t.setHora(Time.valueOf(hora + ":00"));
            t.setEstadoId(1); // programado
            t.setNotas(notas);
            t.setActivo(true);

            if (id == null || id == 0) {
                repo.insertar(t);
            } else {
                t.setId(id);
                repo.actualizar(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "redirect:/turnos";
    }

    // ==========================================
    // CANCELAR
    // ==========================================
    @GET
    @Path("/cancelar/{id}")
    public String cancelar(@PathParam("id") int id) {
        repo.cancelar(id);
        return "redirect:/turnos";
    }

 
}