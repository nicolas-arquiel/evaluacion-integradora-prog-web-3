package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.ObraSocial;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ObraSocialRepository {

    public List<ObraSocial> listar() {
        List<ObraSocial> obras = new ArrayList<>();
        String sql = "SELECT * FROM obras_sociales ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                obras.add(new ObraSocial(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getBoolean("activo")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return obras;
    }

    public void insertar(ObraSocial o) {
        String sql = "INSERT INTO obras_sociales (nombre, activo) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, o.getNombre());
            ps.setBoolean(2, o.isActivo());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ObraSocial obtenerPorId(int id) {
        String sql = "SELECT * FROM obras_sociales WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new ObraSocial(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getBoolean("activo")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void actualizar(ObraSocial o) {
        String sql = "UPDATE obras_sociales SET nombre=?, activo=? WHERE id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, o.getNombre());
            ps.setBoolean(2, o.isActivo());
            ps.setInt(3, o.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void eliminar(int id) {
        String sql = "UPDATE obras_sociales SET activo = FALSE WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
