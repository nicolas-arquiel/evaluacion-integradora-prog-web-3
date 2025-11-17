package com.app.controllers;

import com.app.repositories.TurnoRepository;
import com.app.models.Turno;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.QueryParam;

import java.util.List;

@RequestScoped
@Path("")
@Controller
public class HomeController {

    private final TurnoRepository repoTurnos = new TurnoRepository();

    @Inject
    private Models models;

    @GET
    @Path("")
    @View("index.jsp")
    public void index(
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {

        // BIENVENIDA
        models.put("bienvenida", "Bienvenido al Sistema de Gestión Médica - Salud Total");

        // PRÓXIMOS TURNOS (SQL optimizado)
        List<Turno> proximosTurnos = repoTurnos.obtenerProximosTurnos();
        models.put("turnos", proximosTurnos);

        // MENSAJES
        if (success != null && !success.isEmpty()) models.put("success", success);
        if (error != null && !error.isEmpty()) models.put("error", error);
        if (warning != null && !warning.isEmpty()) models.put("warning", warning);
        if (info != null && !info.isEmpty()) models.put("info", info);
    }
}
