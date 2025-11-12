package com.app.controllers;

import com.app.models.Medico;
import com.app.repositories.MedicoRepository;
import jakarta.mvc.Controller;
import jakarta.mvc.View;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import java.util.List;

@Path("/medicos")
@Controller
public class MedicoController {

    private MedicoRepository repo = new MedicoRepository();

    @GET
    @View("medicos/listar.jsp")
    public List<Medico> listar() {
        return repo.listar();
    }

    @GET
    @Path("/nuevo")
    @View("medicos/formulario.jsp")
    public void nuevo() {}

    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String crear(@FormParam("nombreCompleto") String nombre,
                        @FormParam("especialidad") String especialidad,
                        @FormParam("matricula") String matricula) {
        Medico m = new Medico();
        m.setNombreCompleto(nombre);
        m.setEspecialidad(especialidad);
        m.setMatricula(matricula);
        m.setActivo(true);
        repo.insertar(m);
        return "redirect:/medicos";
    }

    @GET
    @Path("/editar/{id}")
    @View("medicos/formulario.jsp")
    public Medico editar(@PathParam("id") int id) {
        return repo.obtenerPorId(id);
    }

    @POST
    @Path("/actualizar")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String actualizar(@FormParam("id") int id,
                             @FormParam("nombreCompleto") String nombre,
                             @FormParam("especialidad") String especialidad,
                             @FormParam("matricula") String matricula) {
        Medico m = new Medico(id, nombre, especialidad, matricula, true);
        repo.actualizar(m);
        return "redirect:/medicos";
    }

    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        repo.eliminar(id);
        return "redirect:/medicos";
    }
}
