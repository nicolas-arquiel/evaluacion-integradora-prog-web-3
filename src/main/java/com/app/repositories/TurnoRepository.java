package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Turno;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TurnoRepository {

    // =============================
    // LISTAR TODOS
    // =============================
    public List<Turno> listar() {
        List<Turno> turnos = new ArrayList<>();

        String sql = """
            SELECT t.id, t.paciente_id, t.medico_id, t.fecha, t.hora,
                   t.estado_id, t.notas,
                   e.nombre AS estado_nombre,
                   m.nombre AS medico_nombre,
                   p.nombre AS paciente_nombre,
                   p.obra_social_id
            FROM turnos t
            JOIN estados e ON e.id = t.estado_id
            JOIN medicos m ON t.medico_id = m.id
            JOIN pacientes p ON t.paciente_id = p.id
            ORDER BY t.fecha DESC, t.hora DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setPacienteId(rs.getInt("paciente_id"));
                t.setMedicoId(rs.getInt("medico_id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setEstadoId(rs.getInt("estado_id"));
                t.setNotas(rs.getString("notas"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                t.setNombreMedico(rs.getString("medico_nombre"));
                t.setNombrePaciente(rs.getString("paciente_nombre"));
                t.setObraSocialId(rs.getInt("obra_social_id"));
                turnos.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return turnos;
    }

    // =============================
    // BUSCAR POR ID
    // =============================
    public Turno buscarPorId(int id) {
        String sql = """
            SELECT t.*, 
                   m.nombre AS medico_nombre,
                   p.nombre AS paciente_nombre,
                   p.obra_social_id,
                   e.nombre AS estado_nombre
            FROM turnos t
            JOIN medicos m ON m.id = t.medico_id
            JOIN pacientes p ON p.id = t.paciente_id
            JOIN estados e ON e.id = t.estado_id
            WHERE t.id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setPacienteId(rs.getInt("paciente_id"));
                t.setMedicoId(rs.getInt("medico_id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setEstadoId(rs.getInt("estado_id"));
                t.setNotas(rs.getString("notas"));
                t.setNombreMedico(rs.getString("medico_nombre"));
                t.setNombrePaciente(rs.getString("paciente_nombre")); // <-- BUG FIX
                t.setObraSocialId(rs.getInt("obra_social_id"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                return t;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // =============================
    // FILTRAR 
    // =============================
    public List<Turno> filtrar(Integer idMedico, String desde, String hasta) {
        List<Turno> turnos = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT t.id, t.paciente_id, t.medico_id, t.fecha, t.hora,
                   t.estado_id, t.notas,
                   e.nombre AS estado_nombre,
                   m.nombre AS medico_nombre,
                   p.nombre AS paciente_nombre,
                   p.obra_social_id
            FROM turnos t
            JOIN estados e ON e.id = t.estado_id
            JOIN medicos m ON t.medico_id = m.id
            JOIN pacientes p ON t.paciente_id = p.id
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (idMedico != null) {
            sql.append(" AND t.medico_id = ?");
            params.add(idMedico);
        }

        boolean tieneDesde = (desde != null && !desde.isEmpty());
        boolean tieneHasta = (hasta != null && !hasta.isEmpty());

        if (tieneDesde && !tieneHasta) {
            sql.append(" AND t.fecha >= ?");
            params.add(Date.valueOf(desde));
        }

        if (!tieneDesde && tieneHasta) {
            sql.append(" AND t.fecha <= ?");
            params.add(Date.valueOf(hasta));
        }

        if (tieneDesde && tieneHasta) {
            sql.append(" AND t.fecha BETWEEN ? AND ?");
            params.add(Date.valueOf(desde));
            params.add(Date.valueOf(hasta));
        }

        sql.append(" ORDER BY t.fecha DESC, t.hora DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object val = params.get(i);
                if (val instanceof Integer) ps.setInt(i + 1, (Integer) val);
                else if (val instanceof Date) ps.setDate(i + 1, (Date) val);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setPacienteId(rs.getInt("paciente_id"));
                t.setMedicoId(rs.getInt("medico_id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setEstadoId(rs.getInt("estado_id"));
                t.setNotas(rs.getString("notas"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                t.setNombreMedico(rs.getString("medico_nombre"));
                t.setNombrePaciente(rs.getString("paciente_nombre"));
                t.setObraSocialId(rs.getInt("obra_social_id"));
                turnos.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return turnos;
    }

    // =============================
    // DUPLICADOS
    // =============================
    public boolean existeTurnoDuplicado(int idMedico, Date fecha, Time hora) {
        String sql = """
            SELECT COUNT(*) FROM turnos 
            WHERE medico_id = ? AND fecha = ? AND hora = ?
              AND estado_id = 1
        """;

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

    // =============================
    // INSERTAR
    // =============================
    public void insertar(Turno t) throws SQLException {
        if (existeTurnoDuplicado(t.getMedicoId(), t.getFecha(), t.getHora())) {
            throw new SQLException("Ya existe un turno para este médico en esa fecha y hora.");
        }

        String sql = """
            INSERT INTO turnos (paciente_id, medico_id, fecha, hora, estado_id, notas)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, t.getPacienteId());
            ps.setInt(2, t.getMedicoId());
            ps.setDate(3, t.getFecha());
            ps.setTime(4, t.getHora());
            ps.setInt(5, t.getEstadoId());
            ps.setString(6, t.getNotas());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) t.setId(keys.getInt(1));
        }
    }

    // =============================
    // ACTUALIZAR
    // =============================
    public void actualizar(Turno t) throws SQLException {
        String sql = """
            UPDATE turnos
            SET paciente_id=?, medico_id=?, fecha=?, hora=?, estado_id=?, notas=?
            WHERE id=?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getPacienteId());
            ps.setInt(2, t.getMedicoId());
            ps.setDate(3, t.getFecha());
            ps.setTime(4, t.getHora());
            ps.setInt(5, t.getEstadoId());
            ps.setString(6, t.getNotas());
            ps.setInt(7, t.getId());
            ps.executeUpdate();
        }
    }

    // =============================
    // CANCELAR
    // =============================
    public void cancelar(int id) {
        String sql = "UPDATE turnos SET estado_id = 2 WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // PRÓXIMOS TURNOS
    // =============================
    public List<Turno> obtenerProximosTurnos() {
        List<Turno> turnos = new ArrayList<>();

        String sql = """
            SELECT t.id, t.paciente_id, t.medico_id, t.fecha, t.hora,
                   t.estado_id, t.notas,
                   e.nombre AS estado_nombre,
                   m.nombre AS medico_nombre,
                   p.nombre AS paciente_nombre,
                   p.obra_social_id
            FROM turnos t
            JOIN estados e ON e.id = t.estado_id
            JOIN medicos m ON t.medico_id = m.id
            JOIN pacientes p ON t.paciente_id = p.id
            WHERE t.fecha >= CURRENT_DATE AND t.estado_id = 1
            ORDER BY t.fecha, t.hora
            LIMIT 50
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setPacienteId(rs.getInt("paciente_id"));
                t.setMedicoId(rs.getInt("medico_id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setEstadoId(rs.getInt("estado_id"));
                t.setNotas(rs.getString("notas"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                t.setNombreMedico(rs.getString("medico_nombre"));
                t.setNombrePaciente(rs.getString("paciente_nombre"));
                t.setObraSocialId(rs.getInt("obra_social_id"));
                turnos.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return turnos;
    }
}
