package com.app.controllers;

import com.app.models.ObraSocial;
import com.app.repositories.ObraSocialRepository;
import com.app.utils.AlertUtils;

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
    public void listar(
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {
        models.put("items", repo.listar());
        
        // Pasar mensajes desde parámetros URL
        if (success != null && !success.isEmpty()) {
            models.put("success", success);
        }
        if (error != null && !error.isEmpty()) {
            models.put("error", error);
        }
        if (warning != null && !warning.isEmpty()) {
            models.put("warning", warning);
        }
        if (info != null && !info.isEmpty()) {
            models.put("info", info);
        }
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
            // Validar campos vacíos
            if (nombre == null || nombre.trim().isEmpty()) {
                return AlertUtils.redirectWithError("/obras-sociales", 
                    "El nombre de la obra social es obligatorio");
            }

            // Normalizar el nombre
            nombre = nombre.trim();

            // Validar longitud
            if (nombre.length() < 2) {
                return AlertUtils.redirectWithError("/obras-sociales", 
                    "El nombre debe tener al menos 2 caracteres");
            }
            
            if (nombre.length() > 100) {
                return AlertUtils.redirectWithError("/obras-sociales", 
                    "El nombre no puede tener más de 100 caracteres");
            }

            if ("crear".equals(action)) {
                // Verificar si ya existe una obra social con el mismo nombre
                if (repo.existePorNombre(nombre)) {
                    return AlertUtils.redirectWithError("/obras-sociales", 
                        "Ya existe una obra social con el nombre " + nombre);
                }

                ObraSocial nueva = new ObraSocial();
                nueva.setNombre(nombre);
                nueva.setActivo(true);
                repo.insertar(nueva);

                return AlertUtils.redirectWithSuccess("/obras-sociales", 
                    "Obra social " + nombre + " creada exitosamente");

            } else if ("actualizar".equals(action)) {
                // Verificar si ya existe otra obra social con el mismo nombre (excluyendo la actual)
                if (repo.existePorNombreExcluyendoId(nombre, id)) {
                    return AlertUtils.redirectWithError("/obras-sociales", 
                        "Ya existe otra obra social con el nombre " + nombre);
                }

                ObraSocial editada = new ObraSocial(id, nombre, true);
                repo.actualizar(editada);

                return AlertUtils.redirectWithSuccess("/obras-sociales", 
                    "Obra social " + nombre + " actualizada exitosamente");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/obras-sociales", 
                "Error en la base de datos: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/obras-sociales", 
                "Error inesperado: " + e.getMessage());
        }

        return AlertUtils.redirectWithInfo("/obras-sociales", "Operación completada");
    }

    // ======================================================
    // ELIMINAR (BAJA LÓGICA)
    // ======================================================
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        try {
            ObraSocial obra = repo.obtenerPorId(id);
            if (obra != null) {
                repo.eliminar(id);
                return AlertUtils.redirectWithSuccess("/obras-sociales", 
                    "Obra social " + obra.getNombre() + " eliminada exitosamente");
            } else {
                return AlertUtils.redirectWithError("/obras-sociales", 
                    "La obra social no existe");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/obras-sociales", 
                "Error al eliminar la obra social: " + e.getMessage());
        }
    }
}