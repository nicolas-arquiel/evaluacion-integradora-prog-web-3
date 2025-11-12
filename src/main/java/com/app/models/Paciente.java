package com.app.models;

import java.util.List;

public class Paciente {
    private int id;
    private String nombreCompleto;
    private String telefono;
    private String documento;
    private boolean activo;
    private List<Integer> obrasSocialesIds;

    public Paciente() {}

    public Paciente(int id, String nombreCompleto, String telefono, String documento, boolean activo) {
        this.id = id;
        this.nombreCompleto = nombreCompleto;
        this.telefono = telefono;
        this.documento = documento;
        this.activo = activo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getDocumento() { return documento; }
    public void setDocumento(String documento) { this.documento = documento; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public List<Integer> getObrasSocialesIds() { return obrasSocialesIds; }
    public void setObrasSocialesIds(List<Integer> obrasSocialesIds) { this.obrasSocialesIds = obrasSocialesIds; }
}
