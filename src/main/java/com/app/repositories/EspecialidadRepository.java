package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Especialidad;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EspecialidadRepository {

    public List<Especialidad> listar() {
        List<Especialidad> especialidades = new ArrayList<>();
        String sql = "SELECT * FROM especialidades ORDER BY descripcion";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                especialidades.add(new Especialidad(
                    rs.getInt("id"),
                    rs.getString("descripcion")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return especialidades;
    }

    public Especialidad obtenerPorId(int id) {
        String sql = "SELECT * FROM especialidades WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Especialidad(
                    rs.getInt("id"),
                    rs.getString("descripcion")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insertar(Especialidad e) throws SQLException {
        String sql = "INSERT INTO especialidades (descripcion) VALUES (?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, e.getDescripcion());
            ps.executeUpdate();

        }
    }

    public void actualizar(Especialidad e) throws SQLException {
        String sql = "UPDATE especialidades SET descripcion=? WHERE id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, e.getDescripcion());
            ps.setInt(2, e.getId());
            ps.executeUpdate();

        }
    }

    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM especialidades WHERE id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        }
    }
}