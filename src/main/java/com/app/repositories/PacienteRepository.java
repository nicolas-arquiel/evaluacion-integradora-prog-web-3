package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Paciente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PacienteRepository {

    public List<Paciente> listar() {
        List<Paciente> pacientes = new ArrayList<>();

        String sql = """
            SELECT p.*, os.nombre AS obra_social_nombre
            FROM pacientes p
            INNER JOIN obras_sociales os ON p.obra_social_id = os.id
            ORDER BY p.id DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {

                Paciente p = new Paciente(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("email"),
                    rs.getString("numero_telefono"),
                    rs.getString("documento"),
                    rs.getInt("obra_social_id"),
                    rs.getBoolean("activo")
                );

                p.setObraSocialNombre(rs.getString("obra_social_nombre"));

                pacientes.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pacientes;
    }



    public boolean existeDocumento(String documento) {
        String sql = "SELECT COUNT(*) FROM pacientes WHERE documento = ? AND activo = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean existeDocumentoParaOtro(String documento, int idPaciente) {
        String sql = "SELECT COUNT(*) FROM pacientes WHERE documento = ? AND id != ? AND activo = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, documento);
            ps.setInt(2, idPaciente);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public void insertar(Paciente p) throws SQLException {
        if (existeDocumento(p.getDocumento())) {
            throw new SQLException("Ya existe un paciente con el documento: " + p.getDocumento());
        }

        String sql = """
            INSERT INTO pacientes (nombre, email, numero_telefono, documento, obra_social_id, activo) 
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getNumeroTelefono());
            ps.setString(4, p.getDocumento());
            ps.setInt(5, p.getObraSocialId());
            ps.setBoolean(6, p.isActivo());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) p.setId(keys.getInt(1));
        }
    }

    public Paciente obtenerPorId(int id) {
        String sql = """
            SELECT p.*, os.nombre as obra_social_nombre
            FROM pacientes p
            INNER JOIN obras_sociales os ON p.obra_social_id = os.id
            WHERE p.id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Paciente p = new Paciente(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("email"),
                    rs.getString("numero_telefono"),
                    rs.getString("documento"),
                    rs.getInt("obra_social_id"),
                    rs.getBoolean("activo")
                );

                p.setObraSocialNombre(rs.getString("obra_social_nombre"));
                return p;
            }

        } catch (SQLException e) { 
            e.printStackTrace(); 
        }

        return null;
    }

    public void actualizar(Paciente p) throws SQLException {
        if (existeDocumentoParaOtro(p.getDocumento(), p.getId())) {
            throw new SQLException("Ya existe otro paciente con el documento: " + p.getDocumento());
        }

        String sql = """
            UPDATE pacientes 
            SET nombre=?, email=?, numero_telefono=?, documento=?, obra_social_id=?, activo=? 
            WHERE id=?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getNumeroTelefono());
            ps.setString(4, p.getDocumento());
            ps.setInt(5, p.getObraSocialId());
            ps.setBoolean(6, p.isActivo());
            ps.setInt(7, p.getId());
            ps.executeUpdate();
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

    public void activar(int id) {
        String sql = "UPDATE pacientes SET activo = TRUE WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}