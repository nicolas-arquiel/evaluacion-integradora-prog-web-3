package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.ObraSocial;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ObraSocialRepository {

    public List<ObraSocial> listar() {
        List<ObraSocial> obras = new ArrayList<>();
        String sql = "SELECT id, nombre FROM obras_sociales ORDER BY nombre";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                obras.add(new ObraSocial(
                        rs.getInt("id"),
                        rs.getString("nombre")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return obras;
    }

    public void insertar(ObraSocial o) throws SQLException {
        String sql = "INSERT INTO obras_sociales (nombre) VALUES (?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, o.getNombre());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) o.setId(keys.getInt(1));
        }
    }

    public ObraSocial obtenerPorId(int id) {
        String sql = "SELECT id, nombre FROM obras_sociales WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new ObraSocial(
                        rs.getInt("id"),
                        rs.getString("nombre")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void actualizar(ObraSocial o) throws SQLException {
        String sql = "UPDATE obras_sociales SET nombre = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, o.getNombre());
            ps.setInt(2, o.getId());
            ps.executeUpdate();
        }
    }

    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM obras_sociales WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public boolean existePorNombre(String nombre) {
        String sql = "SELECT COUNT(*) FROM obras_sociales WHERE UPPER(TRIM(nombre)) = UPPER(TRIM(?))";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existePorNombreExcluyendoId(String nombre, int idExcluir) {
        String sql = """
            SELECT COUNT(*) FROM obras_sociales
            WHERE UPPER(TRIM(nombre)) = UPPER(TRIM(?)) AND id != ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setInt(2, idExcluir);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }



    public int contarPacientesAsociados(int idObraSocial) {
        String sql = "SELECT COUNT(*) FROM pacientes WHERE obra_social_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idObraSocial);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }



}