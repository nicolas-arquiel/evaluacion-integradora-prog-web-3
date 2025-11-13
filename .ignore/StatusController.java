package com.app.controllers;

import com.app.config.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class StatusController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT NOW()")) {

            if (rs.next()) {
                String hora = rs.getString(1);
                resp.getWriter().write("<h2>✅ Conexión exitosa a la base de datos</h2>");
                resp.getWriter().write("<p>Hora del servidor DB: " + hora + "</p>");
            }

        } catch (Exception e) {
            resp.getWriter().write("<h2>❌ Error al conectar con la base de datos</h2>");
            resp.getWriter().write("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace();
        }
    }
}
