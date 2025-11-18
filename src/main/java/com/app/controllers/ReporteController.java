package com.app.controllers;

import com.app.repositories.MedicoRepository;
import com.app.repositories.PacienteRepository;
import com.app.repositories.TurnoRepository;
import com.app.repositories.ReporteRepository;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@RequestScoped
@Path("/reportes")
@Controller
public class ReporteController {

    private final ReporteRepository repo = new ReporteRepository();
    private final MedicoRepository repoMedicos = new MedicoRepository();
    private final TurnoRepository repoTurnos = new TurnoRepository();
    private static final int ESTADO_PROGRAMADO = 1;
    private static final int ESTADO_CANCELADO  = 2;
    private static final int ESTADO_COMPLETADO = 3;

    @Inject
    private Models models;

    @GET
    @View("reportes/index.jsp")
    public void index() {

        models.put("reporteTurnosMedico", repo.turnosPorMedico());
        models.put("totalMedicos", repoMedicos.listar().size());

        int totalTurnos = repoTurnos.listar().size();
        int totalMedicos = repoMedicos.listar().size();
        int promedio = totalMedicos > 0 ? totalTurnos / totalMedicos : 0;
        models.put("promedioTurnosMedico", promedio);

        models.put("reporteTurnosEspecialidad", repo.turnosPorEspecialidad());

        models.put("reporteTurnosObraSocial", repo.turnosPorObraSocial());

        models.put("reporteEstados", repo.turnosPorEstado());
        models.put("estadosProgramados", repo.contarPorEstado(ESTADO_PROGRAMADO));
        models.put("estadosCompletados", repo.contarPorEstado(ESTADO_COMPLETADO));
        models.put("estadosCancelados", repo.contarPorEstado(ESTADO_CANCELADO));
        models.put("estadosTotal", totalTurnos);

        models.put("reporteTurnosMes", repo.turnosPorMes());

        models.put("reporteTurnosVencidos", repo.turnosVencidos());
    }
}
