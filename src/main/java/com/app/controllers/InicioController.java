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
@Path("/inicio")
@Controller
public class InicioController {

    private final TurnoRepository repoTurnos = new TurnoRepository();

    @Inject
    private Models models;

    @GET
    @View("inicio/index.jsp")
    public void inicio(
            @QueryParam("success") String success,
            @QueryParam("error") String error,
            @QueryParam("warning") String warning,
            @QueryParam("info") String info
    ) {

        List<Turno> proximosTurnos = repoTurnos.obtenerProximosTurnos();
        models.put("turnos", proximosTurnos);

        if (success != null && !success.isEmpty()) models.put("success", success);
        if (error != null && !error.isEmpty()) models.put("error", error);
        if (warning != null && !warning.isEmpty()) models.put("warning", warning);
        if (info != null && !info.isEmpty()) models.put("info", info);
    }
}
