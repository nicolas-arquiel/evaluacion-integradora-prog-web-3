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
import java.util.ArrayList;
import java.util.List;

@RequestScoped
@Path("/medicos")
@Controller
public class MedicoController {

    private final MedicoRepository repo = new MedicoRepository();
    private final ObraSocialRepository repoObras = new ObraSocialRepository();
    private final EspecialidadRepository repoEspecialidades = new EspecialidadRepository();

    @Inject
    private Models models;

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
            @FormParam("especialidadId") Integer especialidadId,
            @FormParam("matricula") String matricula,
            @FormParam("obrasSocialesIds") List<Integer> obras
    ) {

        // ============================================
        // VALIDACIONES OBLIGATORIAS
        // ============================================
        List<String> errores = new ArrayList<>();

        // Validar nombre
        if (nombre == null || nombre.trim().isEmpty()) {
            errores.add("El nombre es obligatorio");
        }

        // Validar especialidad
        if (especialidadId == null || especialidadId <= 0) {
            errores.add("Debe seleccionar una especialidad");
        }

        // Validar matrícula
        if (matricula == null || matricula.trim().isEmpty()) {
            errores.add("La matrícula es obligatoria");
        }

        // Validar obras sociales
        if (obras == null || obras.isEmpty()) {
            errores.add("Debe seleccionar al menos una obra social");
        }

        // Si hay errores, mostrar mensaje de validación
        if (!errores.isEmpty()) {
            String mensajeError = "Faltan completar los siguientes datos: " + String.join(", ", errores);
            return AlertUtils.redirectWithError("/medicos", mensajeError);
        }

        try {
            if ("crear".equals(action)) {
                // Validación adicional para crear: verificar que no exista la matrícula
                if (repo.existeMatricula(matricula.trim())) {
                    return AlertUtils.redirectWithError("/medicos", 
                        "Ya existe un médico con la matrícula " + matricula.trim());
                }

                Medico m = new Medico();
                m.setNombre(nombre.trim());
                m.setEspecialidadId(especialidadId);
                m.setMatricula(matricula.trim());
                m.setActivo(true);
                m.setObrasSocialesIds(obras);
                
                repo.insertar(m);
                return AlertUtils.redirectWithSuccess("/medicos", 
                    "Médico " + nombre.trim() + " creado exitosamente con matrícula " + matricula.trim());

            } else if ("actualizar".equals(action)) {
                // Validación adicional para actualizar: verificar que el ID exista
                if (id == null || id <= 0) {
                    return AlertUtils.redirectWithError("/medicos", "ID de médico inválido");
                }

                // Verificar que no exista otra matrícula igual (excepto el mismo médico)
                if (repo.existeMatriculaOtroMedico(matricula.trim(), id)) {
                    return AlertUtils.redirectWithError("/medicos", 
                        "Ya existe otro médico con la matrícula " + matricula.trim());
                }

                Medico m = new Medico(id, nombre.trim(), especialidadId, matricula.trim(), true);
                m.setObrasSocialesIds(obras);
                
                repo.actualizar(m);
                return AlertUtils.redirectWithSuccess("/medicos", 
                    "Médico " + nombre.trim() + " actualizado exitosamente");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/medicos", 
                "Error al guardar el médico: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/medicos", 
                "Error inesperado: " + e.getMessage());
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
            // Validar que el ID sea válido
            if (id <= 0) {
                return AlertUtils.redirectWithError("/medicos", "ID de médico inválido");
            }

            // Obtener datos del médico antes de eliminar
            Medico medico = repo.obtenerPorId(id);
            
            if (medico == null) {
                return AlertUtils.redirectWithWarning("/medicos", 
                    "El médico que intenta eliminar ya no existe");
            }

            repo.eliminar(id);
            
            return AlertUtils.redirectWithSuccess("/medicos", 
                "Médico " + medico.getNombre() + " (Matrícula: " + medico.getMatricula() + ") eliminado exitosamente");
            
        } catch (Exception e) {
            e.printStackTrace();
            return AlertUtils.redirectWithError("/medicos", 
                "Error al eliminar el médico: " + e.getMessage());
        }
    }
}