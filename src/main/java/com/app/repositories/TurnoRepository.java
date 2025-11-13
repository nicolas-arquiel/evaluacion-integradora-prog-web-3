package com.app.repositories;

import com.app.config.DatabaseConnection;
import com.app.models.Turno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.sql.Date;  // 👈 USAMOS SIEMPRE java.sql.Date
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class TurnoRepository {

    // =============================
    // LISTAR TODOS
    // =============================
    public List<Turno> listar() {
        List<Turno> turnos = new ArrayList<>();

        String sql = """
            SELECT t.id, t.fecha, t.hora, t.id_estado,
                   e.nombre AS estado_nombre,
                   m.nombre_completo AS medico,
                   p.nombre_completo AS paciente
            FROM turnos t
            JOIN estados_turno e ON e.id = t.id_estado
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
                t.setIdEstado(rs.getInt("id_estado"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                t.setNombreMedico(rs.getString("medico"));
                t.setNombrePaciente(rs.getString("paciente"));
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
                   m.nombre_completo AS medico,
                   p.nombre_completo AS paciente
            FROM turnos t
            JOIN medicos m ON m.id = t.id_medico
            JOIN pacientes p ON p.id = t.id_paciente
            WHERE t.id = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setIdPaciente(rs.getInt("id_paciente"));
                t.setIdMedico(rs.getInt("id_medico"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setIdEstado(rs.getInt("id_estado"));
                t.setNombreMedico(rs.getString("medico"));
                t.setNombrePaciente(rs.getString("paciente"));

                // =============================
                // CARGAR OBRA SOCIALES DEL PACIENTE (IDS)
                // =============================
                String sqlObras = """
                    SELECT id_obra_social
                    FROM pacientes_obras_sociales
                    WHERE id_paciente = ?
                """;

                try (PreparedStatement ps2 = conn.prepareStatement(sqlObras)) {

                    ps2.setInt(1, t.getIdPaciente());
                    ResultSet rs2 = ps2.executeQuery();

                    List<Integer> obras = new ArrayList<>();
                    while (rs2.next()) obras.add(rs2.getInt(1));

                    t.setObrasIds(obras);
                }

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
            SELECT t.id, t.fecha, t.hora, t.id_estado,
                   e.nombre AS estado_nombre,
                   m.nombre_completo AS medico,
                   p.nombre_completo AS paciente
            FROM turnos t
            JOIN estados_turno e ON e.id = t.id_estado
            JOIN medicos m ON t.id_medico = m.id
            JOIN pacientes p ON t.id_paciente = p.id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        // FILTRO POR MÉDICO
        if (idMedico != null) {
            sql.append(" AND t.id_medico = ?");
            params.add(idMedico);
        }

        // FILTROS DE FECHA
        boolean tieneDesde = (desde != null && !desde.isEmpty());
        boolean tieneHasta = (hasta != null && !hasta.isEmpty());

        if (tieneDesde && !tieneHasta) {
            sql.append(" AND t.fecha >= ?");
            params.add(Date.valueOf(desde)); // java.sql.Date
        }

        if (!tieneDesde && tieneHasta) {
            sql.append(" AND t.fecha <= ?");
            params.add(Date.valueOf(hasta)); // java.sql.Date
        }

        if (tieneDesde && tieneHasta) {
            sql.append(" AND t.fecha BETWEEN ? AND ?");
            params.add(Date.valueOf(desde));
            params.add(Date.valueOf(hasta));
        }

        sql.append(" ORDER BY t.fecha, t.hora");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // SET PARAMS
            for (int i = 0; i < params.size(); i++) {

                Object val = params.get(i);

                if (val instanceof Integer) {
                    ps.setInt(i + 1, (Integer) val);

                } else if (val instanceof java.sql.Date) {
                    ps.setDate(i + 1, (java.sql.Date) val);
                }
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setIdEstado(rs.getInt("id_estado"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                t.setNombreMedico(rs.getString("medico"));
                t.setNombrePaciente(rs.getString("paciente"));
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

        String sql = "SELECT COUNT(*) FROM turnos WHERE id_medico = ? AND fecha = ? AND hora = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idMedico);
            ps.setDate(2, fecha);
            ps.setTime(3, hora);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) { e.printStackTrace(); }

        return false;
    }

    // =============================
    // INSERTAR
    // =============================
    public void insertar(Turno t) throws SQLException {

        if (existeTurnoDuplicado(t.getIdMedico(), t.getFecha(), t.getHora()))
            throw new SQLException("Turno duplicado.");

        String sql = """
            INSERT INTO turnos (id_paciente, id_medico, fecha, hora, id_estado)
            VALUES (?, ?, ?, ?, 1)
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getIdPaciente());
            ps.setInt(2, t.getIdMedico());
            ps.setDate(3, t.getFecha());
            ps.setTime(4, t.getHora());
            ps.executeUpdate();
        }
    }

    // =============================
    // ACTUALIZAR
    // =============================
    public void actualizar(Turno t) throws SQLException {

        if (existeTurnoDuplicado(t.getIdMedico(), t.getFecha(), t.getHora()))
            throw new SQLException("Turno duplicado.");

        String sql = """
            UPDATE turnos
               SET id_paciente=?, id_medico=?, fecha=?, hora=?, id_estado=?
             WHERE id=?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getIdPaciente());
            ps.setInt(2, t.getIdMedico());
            ps.setDate(3, t.getFecha());
            ps.setTime(4, t.getHora());
            ps.setInt(5, t.getIdEstado());
            ps.setInt(6, t.getId());

            ps.executeUpdate();
        }
    }

    // =============================
    // CANCELAR
    // =============================
    public void cancelar(int id) {

        String sql = "UPDATE turnos SET id_estado=2 WHERE id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) { e.printStackTrace(); }
    }

    // =============================
    // OBRAS POR PACIENTE (JSON)
    // =============================
    public List<Map<String, Object>> obtenerObrasPorPaciente(int idPaciente) {

        List<Map<String, Object>> obras = new ArrayList<>();

        String sql = """
            SELECT o.id, o.nombre
            FROM obras_sociales o
            JOIN pacientes_obras_sociales po ON po.id_obra_social = o.id
            WHERE po.id_paciente = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("id", rs.getInt("id"));
                fila.put("nombre", rs.getString("nombre"));
                obras.add(fila);
            }

        } catch (SQLException e) { e.printStackTrace(); }

        return obras;
    }

    // =============================
    // OBRAS POR PACIENTE (IDs)
    // =============================
    public List<Integer> obtenerObrasPorPacienteIds(int idPaciente) {

        List<Integer> ids = new ArrayList<>();

        String sql = """
            SELECT id_obra_social
            FROM pacientes_obras_sociales
            WHERE id_paciente = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ids.add(rs.getInt("id_obra_social"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ids;
    }

    // =============================
    // MÉDICOS POR OBRA SOCIAL
    // =============================
    public List<Map<String, Object>> medicosPorObra(List<Integer> obras) {

        if (obras == null || obras.isEmpty()) return new ArrayList<>();

        List<Map<String, Object>> medicos = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT m.id, m.nombre_completo AS nombre, m.especialidad
            FROM medicos m
            JOIN medicos_obras_sociales mo ON mo.id_medico = m.id
            WHERE mo.id_obra_social IN (
        """);

        for (int i = 0; i < obras.size(); i++) {
            sql.append("?");
            if (i < obras.size() - 1) sql.append(",");
        }
        sql.append(") GROUP BY m.id");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < obras.size(); i++) {
                ps.setInt(i + 1, obras.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getInt("id"));
                m.put("nombre", rs.getString("nombre"));
                m.put("especialidad", rs.getString("especialidad"));
                medicos.add(m);
            }

        } catch (SQLException e) { e.printStackTrace(); }

        return medicos;
    }

    // =============================
    // PRÓXIMOS TURNOS
    // =============================
    public List<Turno> obtenerProximosTurnos() {

        List<Turno> turnos = new ArrayList<>();

        String sql = """
            SELECT t.id, t.fecha, t.hora, t.id_estado,
                   e.nombre AS estado_nombre,
                   m.nombre_completo AS medico,
                   p.nombre_completo AS paciente
            FROM turnos t
            JOIN estados_turno e ON e.id = t.id_estado
            JOIN medicos m ON t.id_medico = m.id
            JOIN pacientes p ON t.id_paciente = p.id
            WHERE t.fecha >= CURRENT_DATE
            ORDER BY t.fecha, t.hora
            LIMIT 50
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setFecha(rs.getDate("fecha"));
                t.setHora(rs.getTime("hora"));
                t.setIdEstado(rs.getInt("id_estado"));
                t.setEstadoNombre(rs.getString("estado_nombre"));
                t.setNombreMedico(rs.getString("medico"));
                t.setNombrePaciente(rs.getString("paciente"));
                turnos.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return turnos;
    }
}
