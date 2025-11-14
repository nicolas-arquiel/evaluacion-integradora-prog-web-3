package com.app.controllers;

import com.app.repositories.MedicoRepository;
import com.app.repositories.PacienteRepository;
import com.app.repositories.TurnoRepository;
import com.app.models.Turno;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.*;

@RequestScoped
@Path("")  // ← Ruta vacía para que /app/ sea el index
@Controller
public class HomeController {

    private final MedicoRepository repoMedicos = new MedicoRepository();
    private final PacienteRepository repoPacientes = new PacienteRepository();
    private final TurnoRepository repoTurnos = new TurnoRepository();

    @Inject
    private Models models;

    @GET
    @Path("")  // ← Ruta vacía = /app/
    @View("index.jsp")
    public void index() {
        
        // Estadísticas
        models.put("totalMedicos", repoMedicos.listar().size());
        models.put("totalPacientes", repoPacientes.listar().size());
        
        // Turnos de hoy
        LocalDate hoy = LocalDate.now();
        List<Turno> todosLosTurnos = repoTurnos.listar();
        long turnosHoy = todosLosTurnos.stream()
            .filter(t -> t.getFecha() != null && t.getFecha().toLocalDate().equals(hoy))
            .count();
        models.put("turnosHoy", turnosHoy);
        
        // Próximos 7 días
        LocalDate limite = hoy.plusDays(7);
        long proximosTurnos = todosLosTurnos.stream()
            .filter(t -> {
                if (t.getFecha() == null) return false;
                LocalDate fechaTurno = t.getFecha().toLocalDate();
                return !fechaTurno.isBefore(hoy) && !fechaTurno.isAfter(limite);
            })
            .count();
        models.put("proximosTurnos", proximosTurnos);
        
        // Obtener turnos de la próxima semana para mostrar en el index
        List<Turno> turnosSemana = repoTurnos.filtrar(
            null, 
            hoy.toString(), 
            hoy.plusDays(6).toString()
        );
        models.put("turnos", turnosSemana);
        
        // Si quieres el calendario completo, descomenta esto:
        // generarCalendarioSemanal();
    }

    // Método opcional para calendario (si lo quieres en el index)
    private void generarCalendarioSemanal() {
        LocalDate hoy = LocalDate.now();
        
        // Días de la semana (próximos 7 días)
        String[] dias = new String[7];
        Map<String, String> mapFechas = new HashMap<>();
        
        for (int i = 0; i < 7; i++) {
            LocalDate fecha = hoy.plusDays(i);
            String nombreDia = fecha.getDayOfWeek()
                .getDisplayName(TextStyle.SHORT, new Locale("es", "ES"));
            dias[i] = nombreDia.substring(0, 1).toUpperCase() + nombreDia.substring(1);
            mapFechas.put(dias[i], fecha.toString());
        }
        
        models.put("dias", dias);
        models.put("mapFechas", mapFechas);
        
        // Horas (8am a 5pm)
        String[] horas = {
            "08:00", "09:00", "10:00", "11:00", 
            "12:00", "13:00", "14:00", "15:00", 
            "16:00", "17:00"
        };
        models.put("horas", horas);
        
        // Mapa de horas con segundos
        Map<String, String> mapHoras = new HashMap<>();
        for (String h : horas) {
            mapHoras.put(h, h + ":00");
        }
        models.put("mapHoras", mapHoras);
    }
}