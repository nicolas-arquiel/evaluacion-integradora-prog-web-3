package com.app.controllers;

import com.app.models.Medico;
import com.app.repositories.MedicoRepository;
import com.app.repositories.ObraSocialRepository;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.sql.SQLException;
import java.util.List;

@RequestScoped
@Path("/medicos")
@Controller
public class MedicoController {

    private final MedicoRepository repo = new MedicoRepository();
    private final ObraSocialRepository repoObras = new ObraSocialRepository();

    @Inject
    Models models;

    // ============================================
    // LISTAR (INDEX)
    // ============================================
    @GET
    @View("medicos/index.jsp")
    public void listar() {
        models.put("medicos", repo.listar());
        models.put("obrasSociales", repoObras.listar());
    }

    // ============================================
    // GUARDAR (CREAR / ACTUALIZAR)
    // ============================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("action") String action,
            @FormParam("id") Integer id,
            @FormParam("nombreCompleto") String nombre,
            @FormParam("especialidad") String especialidad,
            @FormParam("matricula") String matricula,
            @FormParam("obrasSocialesIds") List<Integer> obras
    ) {

        try {
            if ("crear".equals(action)) {

                Medico m = new Medico();
                m.setNombreCompleto(nombre);
                m.setEspecialidad(especialidad);
                m.setMatricula(matricula);
                m.setActivo(true);
                m.setObrasSocialesIds(obras);
                repo.insertar(m);

            } else if ("actualizar".equals(action)) {

                Medico m = new Medico(id, nombre, especialidad, matricula, true);
                m.setObrasSocialesIds(obras);
                repo.actualizar(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "redirect:/medicos";
    }

    // ============================================
    // ELIMINAR
    // ============================================
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        repo.eliminar(id);
        return "redirect:/medicos";
    }
}
