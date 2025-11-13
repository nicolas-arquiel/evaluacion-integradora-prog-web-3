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

import java.util.List;

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
        List<ObraSocial> obras = repo.listar();
        models.put("items", obras);
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

        if ("crear".equals(action)) {
            // Crear nuevo
            ObraSocial nueva = new ObraSocial();
            nueva.setNombre(nombre);
            nueva.setActivo(true);

            repo.insertar(nueva);

        } else if ("actualizar".equals(action)) {
            // Actualizar existente
            ObraSocial editada = new ObraSocial(id, nombre, true);
            repo.actualizar(editada);
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
