package com.app.controllers;

import com.app.models.Paciente;
import com.app.repositories.PacienteRepository;
import com.app.repositories.ObraSocialRepository;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.sql.SQLException;

@RequestScoped
@Path("/pacientes")
@Controller
public class PacienteController {

    private final PacienteRepository repo = new PacienteRepository();
    private final ObraSocialRepository repoObras = new ObraSocialRepository();

    @Inject
    private Models models;

    // =============================================
    // LISTAR (INDEX)
    // =============================================
    @GET
    @View("pacientes/index.jsp")
    public void listar() {
        models.put("pacientes", repo.listar());
        models.put("obrasSociales", repoObras.listar());
    }

    // =============================================
    // GUARDAR (CREAR / EDITAR)
    // =============================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("action") String action,
            @FormParam("id") Integer id,
            @FormParam("nombre") String nombre,
            @FormParam("email") String email,
            @FormParam("numeroTelefono") String numeroTelefono,
            @FormParam("documento") String documento,
            @FormParam("obraSocialId") int obraSocialId
    ) {

        try {
            if ("crear".equals(action)) {
                Paciente p = new Paciente();
                p.setNombre(nombre);
                p.setEmail(email);
                p.setNumeroTelefono(numeroTelefono);
                p.setDocumento(documento);
                p.setObraSocialId(obraSocialId);
                p.setActivo(true);

                repo.insertar(p);

            } else if ("actualizar".equals(action)) {
                Paciente p = new Paciente(id, nombre, email, numeroTelefono, 
                                         documento, obraSocialId, true);
                repo.actualizar(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "redirect:/pacientes";
    }

    // =============================================
    // ELIMINAR
    // =============================================
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        repo.eliminar(id);
        return "redirect:/pacientes";
    }
}