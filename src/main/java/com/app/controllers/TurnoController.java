package com.app.controllers;

import com.app.models.Turno;
import com.app.repositories.MedicoRepository;
import com.app.repositories.PacienteRepository;
import com.app.repositories.TurnoRepository;
import com.app.models.Medico;
import com.app.models.Paciente;
import jakarta.mvc.Controller;
import jakarta.mvc.View;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;
import java.util.*;

@Path("/turnos")
@Controller
public class TurnoController {

    private final TurnoRepository repo = new TurnoRepository();
    private final MedicoRepository repoMedicos = new MedicoRepository();
    private final PacienteRepository repoPacientes = new PacienteRepository();

    @GET
    @View("turnos/listar.jsp")
    public List<Turno> listar() {
        return repo.listar();
    }

    @GET
    @Path("/nuevo")
    @View("turnos/formulario.jsp")
    public Map<String, Object> nuevo() {
        Map<String, Object> data = new HashMap<>();
        data.put("medicos", repoMedicos.listar());
        data.put("pacientes", repoPacientes.listar());
        return data;
    }

    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String crear(@FormParam("idMedico") int idMedico,
                        @FormParam("idPaciente") int idPaciente,
                        @FormParam("fecha") String fecha,
                        @FormParam("hora") String hora) {
        try {
            Turno t = new Turno();
            t.setIdMedico(idMedico);
            t.setIdPaciente(idPaciente);
            t.setFecha(Date.valueOf(fecha));
            t.setHora(Time.valueOf(hora + ":00"));
            t.setEstado("activo");

            repo.insertar(t);
        } catch (SQLException e) {
            System.err.println("⚠ Error al registrar turno: " + e.getMessage());
        }

        return "redirect:/turnos";
    }

    @GET
    @Path("/cancelar/{id}")
    public String cancelar(@PathParam("id") int id) {
        repo.cancelar(id);
        return "redirect:/turnos";
    }

    @GET
    @Path("/obras-sociales-paciente/{idPaciente}")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Map<String, Object>> obtenerObrasPaciente(@PathParam("idPaciente") int idPaciente) {
        String sql = """
            SELECT o.id, o.nombre
            FROM pacientes_obras_sociales po
            JOIN obras_sociales o ON o.id = po.id_obra_social
            WHERE po.id_paciente = ?
        """;
        List<Map<String, Object>> obras = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("id"));
                item.put("nombre", rs.getString("nombre"));
                obras.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return obras;
    }

    @GET
    @Path("/medicos-disponibles")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Map<String, Object>> medicosPorObra(@QueryParam("obras") List<Integer> obras) {
        if (obras == null || obras.isEmpty()) return List.of();
        String placeholders = String.join(",", obras.stream().map(x -> "?").toList());
        String sql = "SELECT DISTINCT m.id, m.nombre_completo, m.especialidad FROM medicos_obras_sociales mo JOIN medicos m ON mo.id_medico = m.id WHERE mo.id_obra_social IN (" + placeholders + ")";
        List<Map<String, Object>> medicos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < obras.size(); i++) ps.setInt(i + 1, obras.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getInt("id"));
                m.put("nombre", rs.getString("nombre_completo"));
                m.put("especialidad", rs.getString("especialidad"));
                medicos.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return medicos;
    }









    
}
