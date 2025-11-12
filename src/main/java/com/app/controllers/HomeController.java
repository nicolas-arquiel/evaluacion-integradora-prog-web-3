package com.app.controllers;

import jakarta.mvc.Controller;
import jakarta.mvc.View;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/")
@Controller
public class HomeController {

    @GET
    @View("index.jsp")
    public void index() {
        // Simplemente muestra la página principal
    }
}
