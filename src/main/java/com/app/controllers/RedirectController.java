package com.app.controllers;

import jakarta.enterprise.context.RequestScoped;
import jakarta.mvc.Controller;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@RequestScoped
@Path("")
@Controller
public class RedirectController {

    @GET
    public Response redirectToInicio() {
        return Response.status(302)
                .header("Location", "/app/inicio")
                .build();
    }
}
