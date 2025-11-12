package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Medico;
import java.sql.*;
import java.util.*;

public class MedicoRepository {

    public List<Medico> listar() {
        List<Medico> medicos = new ArrayList<>();
        String sql = "SELECT * FROM medicos ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Medico m = new Medico(
                    rs.getInt("id"),
                    rs.getString("nombre_completo"),
                    rs.getString("especialidad"),
                    rs.getString("matricula"),
                    rs.getBoolean("activo")
                );
                medicos.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicos;
    }

    public void insertar(Medico m) throws SQLException {
        String sql = "INSERT INTO medicos (nombre_completo, especialidad, matricula, activo) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, m.getNombreCompleto());
            ps.setString(2, m.getEspecialidad());
            ps.setString(3, m.getMatricula());
            ps.setBoolean(4, m.isActivo());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                m.setId(keys.getInt(1));
            }
            actualizarObrasSociales(conn, m);
        }
    }

    public Medico obtenerPorId(int id) {
        String sql = "SELECT * FROM medicos WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Medico m = new Medico(
                    rs.getInt("id"),
                    rs.getString("nombre_completo"),
                    rs.getString("especialidad"),
                    rs.getString("matricula"),
                    rs.getBoolean("activo")
                );
                m.setObrasSocialesIds(obrasPorMedico(id));
                return m;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<Integer> obrasPorMedico(int id) {
        List<Integer> obras = new ArrayList<>();
        String sql = "SELECT id_obra_social FROM medicos_obras_sociales WHERE id_medico = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) obras.add(rs.getInt(1));
        } catch (SQLException e) { e.printStackTrace(); }
        return obras;
    }

    private void actualizarObrasSociales(Connection conn, Medico m) throws SQLException {
        try (PreparedStatement del = conn.prepareStatement("DELETE FROM medicos_obras_sociales WHERE id_medico = ?")) {
            del.setInt(1, m.getId());
            del.executeUpdate();
        }

        if (m.getObrasSocialesIds() == null) return;

        for (Integer idObra : m.getObrasSocialesIds()) {
            try (PreparedStatement ins = conn.prepareStatement("INSERT INTO medicos_obras_sociales (id_medico, id_obra_social) VALUES (?, ?)")) {
                ins.setInt(1, m.getId());
                ins.setInt(2, idObra);
                ins.executeUpdate();
            }
        }
    }

    public void actualizar(Medico m) throws SQLException {
        String sql = "UPDATE medicos SET nombre_completo=?, especialidad=?, matricula=?, activo=? WHERE id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getNombreCompleto());
            ps.setString(2, m.getEspecialidad());
            ps.setString(3, m.getMatricula());
            ps.setBoolean(4, m.isActivo());
            ps.setInt(5, m.getId());
            ps.executeUpdate();
            actualizarObrasSociales(conn, m);
        }
    }

    public void eliminar(int id) {
        String sql = "UPDATE medicos SET activo = FALSE WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
