package com.app.controllers;

import com.app.models.Paciente;
import com.app.models.ObraSocial;
import com.app.repositories.PacienteRepository;
import com.app.repositories.ObraSocialRepository;

import jakarta.mvc.Controller;
import jakarta.mvc.View;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.sql.SQLException;
import java.util.*;

@Path("/pacientes")
@Controller
public class PacienteController {

    private final PacienteRepository repo = new PacienteRepository();
    private final ObraSocialRepository repoObras = new ObraSocialRepository();

    @GET
    @View("pacientes/listar.jsp")
    public List<Paciente> listar() {
        return repo.listar();
    }

    @GET
    @Path("/nuevo")
    @View("pacientes/formulario.jsp")
    public Map<String, Object> nuevo() {
        Map<String, Object> data = new HashMap<>();
        data.put("obrasSociales", repoObras.listar());
        return data;
    }

    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String crear(@FormParam("nombreCompleto") String nombre,
                        @FormParam("telefono") String telefono,
                        @FormParam("documento") String documento,
                        @FormParam("obrasSocialesIds") List<Integer> obrasSocialesIds) {
        try {
            Paciente p = new Paciente();
            p.setNombreCompleto(nombre);
            p.setTelefono(telefono);
            p.setDocumento(documento);
            p.setActivo(true);
            p.setObrasSocialesIds(obrasSocialesIds);
            repo.insertar(p);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "redirect:/pacientes";
    }

    @GET
    @Path("/editar/{id}")
    @View("pacientes/formulario.jsp")
    public Map<String, Object> editar(@PathParam("id") int id) {
        Map<String, Object> data = new HashMap<>();
        data.put("paciente", repo.obtenerPorId(id));
        data.put("obrasSociales", repoObras.listar());
        return data;
    }

    @POST
    @Path("/actualizar")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String actualizar(@FormParam("id") int id,
                             @FormParam("nombreCompleto") String nombre,
                             @FormParam("telefono") String telefono,
                             @FormParam("documento") String documento,
                             @FormParam("obrasSocialesIds") List<Integer> obrasSocialesIds) {
        try {
            Paciente p = new Paciente(id, nombre, telefono, documento, true);
            p.setObrasSocialesIds(obrasSocialesIds);
            repo.actualizar(p);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "redirect:/pacientes";
    }

    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        repo.eliminar(id);
        return "redirect:/pacientes";
    }
}
