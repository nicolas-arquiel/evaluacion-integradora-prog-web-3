package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.ObraSocial;
import com.app.models.Paciente;

import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public class PacienteRepository {

    public List<Paciente> listar() {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM pacientes ORDER BY id";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Paciente p = new Paciente(
                    rs.getInt("id"),
                    rs.getString("nombre_completo"),
                    rs.getString("telefono"),
                    rs.getString("documento"),
                    rs.getBoolean("activo")
                );

                p.setObrasSocialesIds(obrasPorPaciente(p.getId()));
                p.setObrasSociales(listarObras(p.getObrasSocialesIds()));

                p.setObrasSocialesIdsCsv(
                    p.getObrasSocialesIds().stream()
                        .map(Object::toString)
                        .collect(Collectors.joining(","))
                );

                pacientes.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pacientes;
    }

    public void insertar(Paciente p) throws SQLException {
        String sql = "INSERT INTO pacientes (nombre_completo, telefono, documento, activo) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getNombreCompleto());
            ps.setString(2, p.getTelefono());
            ps.setString(3, p.getDocumento());
            ps.setBoolean(4, p.isActivo());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) p.setId(keys.getInt(1));

            actualizarObrasSociales(conn, p);
        }
    }

    public Paciente obtenerPorId(int id) {
        String sql = "SELECT * FROM pacientes WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Paciente p = new Paciente(
                    rs.getInt("id"),
                    rs.getString("nombre_completo"),
                    rs.getString("telefono"),
                    rs.getString("documento"),
                    rs.getBoolean("activo")
                );

                p.setObrasSocialesIds(obrasPorPaciente(id));
                p.setObrasSociales(listarObras(p.getObrasSocialesIds()));

                p.setObrasSocialesIdsCsv(
                    p.getObrasSocialesIds().stream()
                        .map(Object::toString)
                        .collect(Collectors.joining(","))
                );

                return p;
            }

        } catch (SQLException e) { e.printStackTrace(); }

        return null;
    }

    private List<Integer> obrasPorPaciente(int id) {
        List<Integer> obras = new ArrayList<>();
        String sql = "SELECT id_obra_social FROM pacientes_obras_sociales WHERE id_paciente = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) obras.add(rs.getInt(1));

        } catch (SQLException e) { e.printStackTrace(); }

        return obras;
    }

    private List<ObraSocial> listarObras(List<Integer> ids) {
        List<ObraSocial> lista = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return lista;

        String placeholders = String.join(",", ids.stream().map(x -> "?").toList());
        String sql = "SELECT id, nombre FROM obras_sociales WHERE id IN (" + placeholders + ")";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++)
                ps.setInt(i + 1, ids.get(i));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new ObraSocial(rs.getInt(1), rs.getString(2), true));
            }

        } catch (SQLException e) { e.printStackTrace(); }

        return lista;
    }

    private void actualizarObrasSociales(Connection conn, Paciente p) throws SQLException {

        try (PreparedStatement del = conn.prepareStatement(
                "DELETE FROM pacientes_obras_sociales WHERE id_paciente = ?")) {

            del.setInt(1, p.getId());
            del.executeUpdate();
        }

        if (p.getObrasSocialesIds() == null) return;

        for (Integer idObra : p.getObrasSocialesIds()) {
            try (PreparedStatement ins = conn.prepareStatement(
                "INSERT INTO pacientes_obras_sociales (id_paciente, id_obra_social) VALUES (?, ?)")) {

                ins.setInt(1, p.getId());
                ins.setInt(2, idObra);
                ins.executeUpdate();
            }
        }
    }

    public void actualizar(Paciente p) throws SQLException {
        String sql = "UPDATE pacientes SET nombre_completo=?, telefono=?, documento=?, activo=? WHERE id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombreCompleto());
            ps.setString(2, p.getTelefono());
            ps.setString(3, p.getDocumento());
            ps.setBoolean(4, p.isActivo());
            ps.setInt(5, p.getId());
            ps.executeUpdate();

            actualizarObrasSociales(conn, p);
        }
    }

    public void eliminar(int id) {
        String sql = "UPDATE pacientes SET activo = FALSE WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
