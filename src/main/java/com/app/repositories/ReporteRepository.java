package com.app.repositories;

import com.app.config.DatabaseConnection;

import java.sql.*;
import java.util.*;

public class ReporteRepository {

    // Turnos por Médico
    public List<Map<String, Object>> turnosPorMedico() {
        List<Map<String, Object>> resultado = new ArrayList<>();

        String sql = """
            SELECT 
                m.nombre AS nombreMedico,
                e.descripcion AS especialidad,
                COUNT(CASE WHEN est.nombre = 'programado' THEN 1 END) as programados,
                COUNT(CASE WHEN est.nombre = 'completado' THEN 1 END) as completados,
                COUNT(CASE WHEN est.nombre = 'cancelado' THEN 1 END) as cancelados,
                COUNT(*) as total
            FROM medicos m
            LEFT JOIN turnos t ON t.medico_id = m.id
            LEFT JOIN estados est ON t.estado_id = est.id
            LEFT JOIN especialidades e ON m.especialidad_id = e.id
            WHERE m.activo = true
            GROUP BY m.id, m.nombre, e.descripcion
            ORDER BY total DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("nombreMedico", rs.getString("nombreMedico"));
                fila.put("especialidad", rs.getString("especialidad"));
                fila.put("programados", rs.getInt("programados"));
                fila.put("completados", rs.getInt("completados"));
                fila.put("cancelados", rs.getInt("cancelados"));
                fila.put("total", rs.getInt("total"));
                resultado.add(fila);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultado;
    }

    // Turnos por Especialidad
    public List<Map<String, Object>> turnosPorEspecialidad() {
        List<Map<String, Object>> resultado = new ArrayList<>();

        String sql = """
            SELECT 
                e.descripcion AS especialidad,
                COUNT(t.id) as cantidad,
                ROUND(COUNT(t.id) * 100.0 / (SELECT COUNT(*) FROM turnos), 2) as porcentaje
            FROM especialidades e
            LEFT JOIN medicos m ON m.especialidad_id = e.id
            LEFT JOIN turnos t ON t.medico_id = m.id
            GROUP BY e.id, e.descripcion
            HAVING COUNT(t.id) > 0
            ORDER BY cantidad DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("especialidad", rs.getString("especialidad"));
                fila.put("cantidad", rs.getInt("cantidad"));
                fila.put("porcentaje", rs.getDouble("porcentaje"));
                resultado.add(fila);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultado;
    }

    // Turnos por Obra Social
    public List<Map<String, Object>> turnosPorObraSocial() {
        List<Map<String, Object>> resultado = new ArrayList<>();

        String sql = """
            SELECT 
                os.nombre AS obraSocial,
                COUNT(DISTINCT p.id) as cantidadPacientes,
                COUNT(t.id) as cantidadTurnos,
                ROUND(
                    COUNT(t.id) * 1.0 / NULLIF(COUNT(DISTINCT p.id), 0),
                    2
                ) as promedio
            FROM obras_sociales os
            LEFT JOIN pacientes p ON p.obra_social_id = os.id
            LEFT JOIN turnos t ON t.paciente_id = p.id
            WHERE os.activo = true
            GROUP BY os.id, os.nombre
            ORDER BY cantidadTurnos DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("obraSocial", rs.getString("obraSocial"));
                fila.put("cantidadPacientes", rs.getInt("cantidadPacientes"));
                fila.put("cantidadTurnos", rs.getInt("cantidadTurnos"));
                fila.put("promedio", rs.getDouble("promedio"));
                resultado.add(fila);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultado;
    }


    // Turnos por Estado
    public List<Map<String, Object>> turnosPorEstado() {
        List<Map<String, Object>> resultado = new ArrayList<>();

        String sql = """
            SELECT 
                e.nombre AS estado,
                COUNT(t.id) as cantidad,
                ROUND(COUNT(t.id) * 100.0 / (SELECT COUNT(*) FROM turnos), 2) as porcentaje
            FROM estados e
            LEFT JOIN turnos t ON t.estado_id = e.id
            GROUP BY e.id, e.nombre
            ORDER BY cantidad DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("estado", rs.getString("estado"));
                fila.put("cantidad", rs.getInt("cantidad"));
                fila.put("porcentaje", rs.getDouble("porcentaje"));
                resultado.add(fila);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultado;
    }

    // Contar por Estado
    public int contarPorEstado(String estado) {
        String sql = """
            SELECT COUNT(*) 
            FROM turnos t
            JOIN estados e ON t.estado_id = e.id
            WHERE e.nombre = ?
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Turnos por Mes
    public List<Map<String, Object>> turnosPorMes() {
        List<Map<String, Object>> resultado = new ArrayList<>();

        String sql = """
            SELECT 
                TO_CHAR(t.fecha, 'Month') as mes,
                EXTRACT(YEAR FROM t.fecha) as anio,
                COUNT(CASE WHEN est.nombre = 'programado' THEN 1 END) as programados,
                COUNT(CASE WHEN est.nombre = 'completado' THEN 1 END) as completados,
                COUNT(CASE WHEN est.nombre = 'cancelado' THEN 1 END) as cancelados,
                COUNT(*) as total
            FROM turnos t
            JOIN estados est ON t.estado_id = est.id
            GROUP BY TO_CHAR(t.fecha, 'Month'), EXTRACT(YEAR FROM t.fecha), EXTRACT(MONTH FROM t.fecha)
            ORDER BY anio DESC, EXTRACT(MONTH FROM t.fecha) DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("mes", rs.getString("mes").trim());
                fila.put("anio", rs.getInt("anio"));
                fila.put("programados", rs.getInt("programados"));
                fila.put("completados", rs.getInt("completados"));
                fila.put("cancelados", rs.getInt("cancelados"));
                fila.put("total", rs.getInt("total"));
                resultado.add(fila);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultado;
    }

    // Turnos vencidos en estado programado
    public List<Map<String, Object>> turnosVencidos() {
        List<Map<String, Object>> resultado = new ArrayList<>();

        String sql = """
            SELECT 
                t.fecha,
                t.hora,
                est.nombre AS estado,
                p.nombre AS paciente,
                m.nombre AS medico,
                e.descripcion AS especialidad
            FROM turnos t
            JOIN estados est ON t.estado_id = est.id
            JOIN pacientes p ON t.paciente_id = p.id
            JOIN medicos m ON t.medico_id = m.id
            JOIN especialidades e ON m.especialidad_id = e.id
            WHERE est.nombre = 'programado'
            AND (
                t.fecha < CURRENT_DATE
                OR (t.fecha = CURRENT_DATE AND t.hora < CURRENT_TIME)
            )
            ORDER BY t.fecha DESC, t.hora DESC
        """;

        try (Connection conn = DatabaseConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("fecha", rs.getString("fecha"));
                fila.put("hora", rs.getString("hora"));
                fila.put("estado", rs.getString("estado"));
                fila.put("paciente", rs.getString("paciente"));
                fila.put("medico", rs.getString("medico"));
                fila.put("especialidad", rs.getString("especialidad"));
                resultado.add(fila);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultado;
    }


}