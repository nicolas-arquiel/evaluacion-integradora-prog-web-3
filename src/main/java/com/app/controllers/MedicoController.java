package com.app.controllers;

import com.app.models.Medico;
import com.app.repositories.EspecialidadRepository;
import com.app.repositories.MedicoRepository;
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
import java.util.List;

@RequestScoped
@Path("/medicos")
@Controller
public class MedicoController {

    private final MedicoRepository repo = new MedicoRepository();
    private final ObraSocialRepository repoObras = new ObraSocialRepository();
    private final EspecialidadRepository repoEspecialidades = new EspecialidadRepository();

    @Inject
    Models models;

    // ============================================
    // LISTAR (INDEX)
    // ============================================
    @GET
    @View("medicos/index.jsp")
    public void listar(
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {
        models.put("medicos", repo.listar());
        models.put("obrasSociales", repoObras.listar());
        models.put("especialidades", repoEspecialidades.listar());
        
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

    // ============================================
    // GUARDAR (CREAR / ACTUALIZAR)
    // ============================================
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String guardar(
            @FormParam("action") String action,
            @FormParam("id") Integer id,
            @FormParam("nombre") String nombre,
            @FormParam("especialidadId") int especialidadId,
            @FormParam("matricula") String matricula,
            @FormParam("obrasSocialesIds") List<Integer> obras
    ) {

        try {
            if ("crear".equals(action)) {

                Medico m = new Medico();
                m.setNombre(nombre);
                m.setEspecialidadId(especialidadId);
                m.setMatricula(matricula);
                m.setActivo(true);
                m.setObrasSocialesIds(obras);
                repo.insertar(m);
                
                return AlertUtils.redirectWithSuccess("/medicos", 
                    "Médico " + nombre + " creado exitosamente");

            } else if ("actualizar".equals(action)) {

                Medico m = new Medico(id, nombre, especialidadId, matricula, true);
                m.setObrasSocialesIds(obras);
                repo.actualizar(m);
                
                return AlertUtils.redirectWithSuccess("/medicos", 
                    "Médico " + nombre + " actualizado exitosamente");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/medicos", 
                "Error al guardar el médico: " + e.getMessage());
        }

        return AlertUtils.redirectWithInfo("/medicos", "Operación completada");
    }

    // ============================================
    // ELIMINAR
    // ============================================
    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        try {
            // Obtener datos del médico antes de eliminar
            List<Medico> medicos = repo.listar();
            Medico medico = medicos.stream()
                                  .filter(m -> m.getId() == id)
                                  .findFirst()
                                  .orElse(null);
            
            repo.eliminar(id);
            
            String mensaje = "Médico eliminado exitosamente";
            if (medico != null) {
                mensaje = "Médico " + medico.getNombre() + " eliminado exitosamente";
            }
            
            return AlertUtils.redirectWithSuccess("/medicos", mensaje);
            
        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/medicos", 
                "Error al eliminar el médico: " + e.getMessage());
        }
    }
}