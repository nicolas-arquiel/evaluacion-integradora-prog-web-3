package com.app.controllers;

import com.app.models.ObraSocial;
import com.app.repositories.ObraSocialRepository;
import jakarta.mvc.Controller;
import jakarta.mvc.View;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import java.util.List;

@Path("/obras-sociales")
@Controller
public class ObraSocialController {

    private final ObraSocialRepository repo = new ObraSocialRepository();

    @GET
    @View("obrasocial/listar.jsp")
    public List<ObraSocial> listar() {
        return repo.listar();
    }

    @GET
    @Path("/nuevo")
    @View("obrasocial/formulario.jsp")
    public void nuevo() {}

    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String crear(@FormParam("nombre") String nombre) {
        ObraSocial o = new ObraSocial();
        o.setNombre(nombre);
        o.setActivo(true);
        repo.insertar(o);
        return "redirect:/obras-sociales";
    }

    @GET
    @Path("/editar/{id}")
    @View("obrasocial/formulario.jsp")
    public ObraSocial editar(@PathParam("id") int id) {
        return repo.obtenerPorId(id);
    }

    @POST
    @Path("/actualizar")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String actualizar(@FormParam("id") int id, @FormParam("nombre") String nombre) {
        ObraSocial o = new ObraSocial(id, nombre, true);
        repo.actualizar(o);
        return "redirect:/obras-sociales";
    }

    @GET
    @Path("/eliminar/{id}")
    public String eliminar(@PathParam("id") int id) {
        repo.eliminar(id);
        return "redirect:/obras-sociales";
    }
}
