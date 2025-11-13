package com.app.controllers;

import com.app.repositories.TurnoRepository;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@RequestScoped
@Path("/")
@Controller
public class HomeController {

    @Inject
    private Models models;

    @GET
    @View("index.jsp")
    public void index() {
        TurnoRepository repo = new TurnoRepository();
        models.put("turnos", repo.obtenerProximosTurnos());
    }
}
