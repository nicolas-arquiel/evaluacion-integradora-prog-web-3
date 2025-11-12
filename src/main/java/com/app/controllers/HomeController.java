package com.app.controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write("<h1>Aplicación Base Jakarta MVC</h1><p>Funciona correctamente en Docker.</p>");
    }
}
