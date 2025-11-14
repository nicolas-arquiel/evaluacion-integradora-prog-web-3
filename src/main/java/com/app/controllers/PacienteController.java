package com.app.controllers;

import com.app.models.Paciente;
import com.app.repositories.PacienteRepository;
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
    public void listar(
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {
        models.put("pacientes", repo.listar());
        models.put("obrasSociales", repoObras.listar());
        
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
                return AlertUtils.redirectWithSuccess("/pacientes", 
                    "Paciente " + nombre + " creado exitosamente");

            } else if ("actualizar".equals(action)) {
                Paciente p = new Paciente(id, nombre, email, numeroTelefono, 
                                         documento, obraSocialId, true);
                repo.actualizar(p);
                return AlertUtils.redirectWithSuccess("/pacientes", 
                    "Paciente " + nombre + " actualizado exitosamente");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/pacientes", e.getMessage());
        }

        return AlertUtils.redirectWithInfo("/pacientes", "Operación completada");
    }

    // =============================================
    // ELIMINAR
    // =============================================
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        try {
            // Obtener nombre del paciente antes de eliminar
            Paciente paciente = repo.obtenerPorId(id);
            repo.eliminar(id);
            
            String mensaje = "Paciente eliminado exitosamente";
            if (paciente != null) {
                mensaje = "Paciente " + paciente.getNombre() + " eliminado exitosamente";
            }
            
            return AlertUtils.redirectWithSuccess("/pacientes", mensaje);
            
        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/pacientes", 
                "Error al eliminar el paciente: " + e.getMessage());
        }
    }
}