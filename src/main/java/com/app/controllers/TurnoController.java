package com.app.controllers;

import com.app.models.Turno;
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
import java.time.LocalDate;
import java.util.*;

@RequestScoped
@Path("/turnos")
@Controller
public class TurnoController {

    private final TurnoRepository repo = new TurnoRepository();
    private final MedicoRepository repoMedicos = new MedicoRepository();
    private final PacienteRepository repoPacientes = new PacienteRepository();

    @Inject
    private Models models;

    // ==================================================
    // LISTAR + FILTROS
    // ==================================================
    @GET
    @View("turnos/index.jsp")
    public void listar(
            @QueryParam("idMedico") Integer idMedico,
            @QueryParam("desde") String desde,
            @QueryParam("hasta") String hasta
    ) {
        models.put("medicos", repoMedicos.listar());
        models.put("pacientes", repoPacientes.listar());

        List<Turno> lista;

        boolean filtraFechas = (desde != null && !desde.isEmpty()) ||
                               (hasta != null && !hasta.isEmpty());

        if (idMedico != null || filtraFechas) {
            lista = repo.filtrar(idMedico, desde, hasta);
        } else {
            lista = repo.listar();
        }

        // Cargar obras en cada turno
        lista.forEach(t -> {
            List<Integer> obrasIds = repo.obtenerObrasPorPacienteIds(t.getIdPaciente());
            t.setObrasIds(obrasIds);
        });

        models.put("turnos", lista);
    }

    // ==================================================
    // FORM EDITAR
    // ==================================================
    @GET
    @Path("/editar/{id}")
    @View("turnos/index.jsp")
    public void editar(@PathParam("id") int id) {

        Turno t = repo.buscarPorId(id);

        models.put("turno", t);
        models.put("medicos", repoMedicos.listar());
        models.put("pacientes", repoPacientes.listar());
    }

    // ==================================================
    // GUARDAR
    // ==================================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("id") Integer id,
            @FormParam("idPaciente") int idPaciente,
            @FormParam("idMedico") int idMedico,
            @FormParam("fecha") String fecha,
            @FormParam("hora") String hora
    ) {
        try {
            Turno t = new Turno();
            t.setIdPaciente(idPaciente);
            t.setIdMedico(idMedico);
            t.setFecha(Date.valueOf(fecha));
            t.setHora(Time.valueOf(hora + ":00"));
            t.setIdEstado(1);

            if (id == null) {
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

    // ==================================================
    // CANCELAR
    // ==================================================
    @GET
    @Path("/cancelar/{id}")
    public String cancelar(@PathParam("id") int id) {
        repo.cancelar(id);
        return "redirect:/turnos";
    }

    // ==================================================
    // JSON → obras del paciente
    // ==================================================
    @GET
    @Path("/obras-sociales-paciente/{idPaciente}")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Map<String, Object>> obtenerObrasPaciente(@PathParam("idPaciente") int idPaciente) {
        return repo.obtenerObrasPorPaciente(idPaciente);
    }

    // ==================================================
    // JSON → médicos por obra
    // ==================================================
    @GET
    @Path("/medicos-disponibles")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Map<String, Object>> medicosPorObra(@QueryParam("obras") List<Integer> obras) {
        return repo.medicosPorObra(obras);
    }

    // ==================================================
    // CALENDARIO
    // ==================================================
    @GET
    @Path("/calendario")
    @View("turnos/calendario.jsp")
    public void calendario() {

        models.put("turnos", repo.obtenerProximosTurnos());

        String[] dias = {"Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo"};
        String[] horas = {"08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00"};

        models.put("dias", dias);
        models.put("horas", horas);

        Map<String,String> mapHoras = new HashMap<>();
        for (String h : horas) mapHoras.put(h, h + ":00");
        models.put("mapHoras", mapHoras);

        Map<String,String> mapFechas = new HashMap<>();
        LocalDate start = LocalDate.now();

        for (int i = 0; i < dias.length; i++) {
            mapFechas.put(dias[i], start.plusDays(i).toString());
        }

        models.put("mapFechas", mapFechas);
    }
}
