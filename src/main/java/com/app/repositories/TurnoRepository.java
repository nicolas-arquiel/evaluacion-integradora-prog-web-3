package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Turno;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TurnoRepository {

    public List<Turno> listar() {
        List<Turno> turnos = new ArrayList<>();
        String sql = """
            SELECT t.id, t.fecha, t.hora, t.estado,
                   m.nombre_completo AS medico,
                   p.nombre_completo AS paciente
            FROM turnos t
            JOIN medicos m ON t.id_medico = m.id
            JOIN pacientes p ON t.id_paciente = p.id
            ORDER BY t.fecha, t.hora
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setEstado(rs.getString("estado"));
                t.setNombreMedico(rs.getString("medico"));
                t.setNombrePaciente(rs.getString("paciente"));
                turnos.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return turnos;
    }

    public boolean existeTurnoDuplicado(int idMedico, Date fecha, Time hora) {
        String sql = "SELECT COUNT(*) FROM turnos WHERE id_medico = ? AND fecha = ? AND hora = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setDate(2, fecha);
            ps.setTime(3, hora);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertar(Turno t) throws SQLException {
        if (existeTurnoDuplicado(t.getIdMedico(), t.getFecha(), t.getHora())) {
            throw new SQLException("Ya existe un turno para ese médico en esa fecha y hora.");
        }

        String sql = "INSERT INTO turnos (id_paciente, id_medico, fecha, hora, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getIdPaciente());
            ps.setInt(2, t.getIdMedico());
            ps.setDate(3, t.getFecha());
            ps.setTime(4, t.getHora());
            ps.setString(5, t.getEstado());
            ps.executeUpdate();
        }
    }

    public void cancelar(int id) {
        String sql = "UPDATE turnos SET estado = 'cancelado' WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
