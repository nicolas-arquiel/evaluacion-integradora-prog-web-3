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

    @Inject
    private Models models;

    @GET
    @View("reportes/index.jsp")
    public void index() {
        
        // Turnos por medico
        models.put("reporteTurnosMedico", repo.turnosPorMedico());
        models.put("totalMedicos", repoMedicos.listar().size());
        
        int totalTurnos = repoTurnos.listar().size();
        int totalMedicos = repoMedicos.listar().size();
        int promedio = totalMedicos > 0 ? totalTurnos / totalMedicos : 0;
        models.put("promedioTurnosMedico", promedio);

        // Turnos por especialidad
        models.put("reporteTurnosEspecialidad", repo.turnosPorEspecialidad());

        // Turnos por obra social
        models.put("reporteTurnosObraSocial", repo.turnosPorObraSocial());

        // Estados de turnos
        models.put("reporteEstados", repo.turnosPorEstado());
        models.put("estadosProgramados", repo.contarPorEstado("programado"));
        models.put("estadosCompletados", repo.contarPorEstado("completado"));
        models.put("estadosCancelados", repo.contarPorEstado("cancelado"));
        models.put("estadosTotal", totalTurnos);

        // Turnos por mes
        models.put("reporteTurnosMes", repo.turnosPorMes());

        // turnos vencidos en estado programado
        models.put("reporteTurnosVencidos", repo.turnosVencidos());
    }
}