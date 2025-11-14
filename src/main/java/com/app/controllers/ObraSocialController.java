package com.app.controllers;

import com.app.models.ObraSocial;
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
@Path("/obras-sociales")
@Controller
public class ObraSocialController {

    private final ObraSocialRepository repo = new ObraSocialRepository();

    @Inject
    private Models models;

    // ======================================================
    // LISTAR (INDEX)
    // ======================================================
    @GET
    @View("obrasocial/index.jsp")
    public void listar() {
        models.put("items", repo.listar());
    }

    // ======================================================
    // GUARDAR (CREAR O EDITAR)
    // ======================================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("action") String action,
            @FormParam("id") Integer id,
            @FormParam("nombre") String nombre
    ) {

        try {
            if ("crear".equals(action)) {
                ObraSocial nueva = new ObraSocial();
                nueva.setNombre(nombre);
                nueva.setActivo(true);
                repo.insertar(nueva);

            } else if ("actualizar".equals(action)) {
                ObraSocial editada = new ObraSocial(id, nombre, true);
                repo.actualizar(editada);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "redirect:/obras-sociales";
    }

    // ======================================================
    // ELIMINAR (BAJA LÓGICA)
    // ======================================================
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        repo.eliminar(id);
        return "redirect:/obras-sociales";
    }
}