package com.app.controllers;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.QueryParam;

@RequestScoped
@Path("/error")
@Controller
public class ErrorController {

    @Inject
    Models models;

    @GET
    @Path("/404")
    @View("error/404.jsp")
    public void notFound(@QueryParam("url") String url) {
        models.put("url", url);
        models.put("title", "Página no encontrada");
    }

    @GET
    @Path("/500")
    @View("error/500.jsp")
    public void serverError() {
        models.put("title", "Error interno del servidor");
    }
}
