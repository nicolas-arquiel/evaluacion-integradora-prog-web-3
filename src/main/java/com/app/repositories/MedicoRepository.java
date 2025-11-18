package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Medico;
import com.app.models.ObraSocial;

import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public class MedicoRepository {

    public List<Medico> listar() {
        List<Medico> medicos = new ArrayList<>();
        String sql = """
            SELECT m.*, e.descripcion as especialidad_nombre
            FROM medicos m
            INNER JOIN especialidades e ON m.especialidad_id = e.id
            ORDER BY m.id
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {

                Medico m = new Medico(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getInt("especialidad_id"),
                    rs.getString("matricula"),
                    rs.getBoolean("activo")
                );

                m.setEspecialidadDescripcion(rs.getString("especialidad_nombre"));
                m.setObrasSocialesIds(obrasPorMedico(m.getId()));
                m.setObrasSociales(listarObras(m.getObrasSocialesIds()));

                m.setObrasSocialesIdsCsv(
                    m.getObrasSocialesIds()
                        .stream()
                        .map(Object::toString)
                        .collect(Collectors.joining(","))
                );

                medicos.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicos;
    }

    public void insertar(Medico m) throws SQLException {
        String sql = "INSERT INTO medicos (nombre, especialidad_id, matricula, activo) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, m.getNombre());
            ps.setInt(2, m.getEspecialidadId());
            ps.setString(3, m.getMatricula());
            ps.setBoolean(4, m.isActivo());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) m.setId(keys.getInt(1));

            actualizarObrasSociales(conn, m);
        }
    }

    public Medico obtenerPorId(int id) {
        String sql = """
            SELECT m.*, e.descripcion as especialidad_nombre
            FROM medicos m
            INNER JOIN especialidades e ON m.especialidad_id = e.id
            WHERE m.id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Medico m = new Medico(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getInt("especialidad_id"),
                    rs.getString("matricula"),
                    rs.getBoolean("activo")
                );

                m.setEspecialidadDescripcion(rs.getString("especialidad_nombre"));
                m.setObrasSocialesIds(obrasPorMedico(id));
                m.setObrasSociales(listarObras(m.getObrasSocialesIds()));
                m.setObrasSocialesIdsCsv(
                    m.getObrasSocialesIds()
                        .stream()
                        .map(Object::toString)
                        .collect(Collectors.joining(","))
                );

                return m;
            }

        } catch (SQLException e) { 
            e.printStackTrace(); 
        }

        return null;
    }

    public boolean existeMatricula(String matricula) {
        String sql = "SELECT COUNT(*) FROM medicos WHERE matricula = ? AND activo = true";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, matricula);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    

    public boolean existeMatriculaOtroMedico(String matricula, int idMedico) {
        String sql = "SELECT COUNT(*) FROM medicos WHERE matricula = ? AND id != ? AND activo = true";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, matricula);
            ps.setInt(2, idMedico);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    private List<Integer> obrasPorMedico(int id) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT obra_social_id FROM medicos_obras_sociales WHERE medico_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) ids.add(rs.getInt(1));

        } catch (SQLException e) { 
            e.printStackTrace(); 
        }

        return ids;
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
                lista.add(new ObraSocial(
                    rs.getInt("id"),
                    rs.getString("nombre")
                ));
            }

        } catch (SQLException e) { 
            e.printStackTrace(); 
        }

        return lista;
    }

    private void actualizarObrasSociales(Connection conn, Medico m) throws SQLException {
        try (PreparedStatement del = conn.prepareStatement(
                "DELETE FROM medicos_obras_sociales WHERE medico_id = ?")) {

            del.setInt(1, m.getId());
            del.executeUpdate();
        }

        if (m.getObrasSocialesIds() == null) return;

        for (Integer idObra : m.getObrasSocialesIds()) {
            try (PreparedStatement ins = conn.prepareStatement(
                    "INSERT INTO medicos_obras_sociales (medico_id, obra_social_id) VALUES (?, ?)")) {

                ins.setInt(1, m.getId());
                ins.setInt(2, idObra);
                ins.executeUpdate();
            }
        }
    }

    public void actualizar(Medico m) throws SQLException {
        String sql = "UPDATE medicos SET nombre=?, especialidad_id=?, matricula=?, activo=? WHERE id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getNombre());
            ps.setInt(2, m.getEspecialidadId());
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

    public void activar(int id) {
        String sql = "UPDATE medicos SET activo = TRUE WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }


}