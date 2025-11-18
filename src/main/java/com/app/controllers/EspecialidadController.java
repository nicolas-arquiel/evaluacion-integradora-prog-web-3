package com.app.controllers;

import com.app.models.Especialidad;
import com.app.repositories.EspecialidadRepository;
import com.app.utils.AlertUtils;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.*;

import jakarta.ws.rs.core.MediaType;
import java.util.List;

@RequestScoped
@Path("/especialidades")
@Controller
public class EspecialidadController {

    private final EspecialidadRepository repo = new EspecialidadRepository();

    @Inject
    private Models models;

    // LISTAR
    @GET
    @View("especialidades/index.jsp")
    public void listar(
            @QueryParam("success") String success,
            @QueryParam("error") String error
    ) {
        List<Especialidad> lista = repo.listar();
        models.put("especialidades", lista);

        if (success != null) models.put("success", success);
        if (error != null) models.put("error", error);
    }

    // GUARDAR
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("id") Integer id,
            @FormParam("descripcion") String descripcion
    ) {
        try {
            if (descripcion == null || descripcion.trim().isEmpty()) {
                return AlertUtils.redirectWithError("/especialidades",
                        "Debe ingresar una descripción");
            }

            if (id == null || id == 0) {
                // Crear
                Especialidad e = new Especialidad();
                e.setDescripcion(descripcion);
                repo.insertar(e);

                return AlertUtils.redirectWithSuccess("/especialidades",
                        "Especialidad creada exitosamente");
            } else {
                // Editar
                Especialidad e = repo.obtenerPorId(id);
                if (e == null) {
                    return AlertUtils.redirectWithError("/especialidades",
                            "La especialidad no existe");
                }

                e.setDescripcion(descripcion);
                repo.actualizar(e);

                return AlertUtils.redirectWithSuccess("/especialidades",
                        "Especialidad actualizada correctamente");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            return AlertUtils.redirectWithError("/especialidades",
                    "Error: " + ex.getMessage());
        }
    }

    // ELIMINAR
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        try {
            Especialidad e = repo.obtenerPorId(id);
            if (e == null) {
                return AlertUtils.redirectWithError("/especialidades",
                        "La especialidad no existe");
            }

            repo.eliminar(id);

            return AlertUtils.redirectWithSuccess("/especialidades",
                    "Especialidad eliminada correctamente");

        } catch (Exception ex) {
            ex.printStackTrace();
            return AlertUtils.redirectWithError("/especialidades",
                    "No se puede eliminar esta especialidad (puede estar en uso)");
        }
    }
}
