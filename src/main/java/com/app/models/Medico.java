package com.app.models;

import java.util.List;

public class Medico {
    private int id;
    private String nombreCompleto;
    private String especialidad;
    private String matricula;
    private boolean activo;
    private List<Integer> obrasSocialesIds;

    public Medico() {}

    public Medico(int id, String nombreCompleto, String especialidad, String matricula, boolean activo) {
        this.id = id;
        this.nombreCompleto = nombreCompleto;
        this.especialidad = especialidad;
        this.matricula = matricula;
        this.activo = activo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getEspecialidad() { return especialidad; }
    public void setEspecialidad(String especialidad) { this.especialidad = especialidad; }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public List<Integer> getObrasSocialesIds() { return obrasSocialesIds; }
    public void setObrasSocialesIds(List<Integer> obrasSocialesIds) { this.obrasSocialesIds = obrasSocialesIds; }
}
