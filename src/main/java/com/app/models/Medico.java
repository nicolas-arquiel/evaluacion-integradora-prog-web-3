package com.app.models;

import java.util.List;

public class Medico {

    private int id;
    private String nombre;
    private int especialidadId;
    private String especialidadDescripcion;
    private String matricula;
    private boolean activo;

    private List<Integer> obrasSocialesIds;
    private List<ObraSocial> obrasSociales;
    private String obrasSocialesIdsCsv;

    public Medico() {}

    public Medico(int id, String nombre, int especialidadId, String matricula, boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.especialidadId = especialidadId;
        this.matricula = matricula;
        this.activo = activo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getEspecialidadId() { return especialidadId; }
    public void setEspecialidadId(int especialidadId) { this.especialidadId = especialidadId; }

    public String getEspecialidadDescripcion() { return especialidadDescripcion; }
    public void setEspecialidadDescripcion(String especialidadDescripcion) { 
        this.especialidadDescripcion = especialidadDescripcion; 
    }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public List<Integer> getObrasSocialesIds() { return obrasSocialesIds; }
    public void setObrasSocialesIds(List<Integer> obrasSocialesIds) { 
        this.obrasSocialesIds = obrasSocialesIds; 
    }

    public List<ObraSocial> getObrasSociales() { return obrasSociales; }
    public void setObrasSociales(List<ObraSocial> obrasSociales) { 
        this.obrasSociales = obrasSociales; 
    }

    public String getObrasSocialesIdsCsv() { return obrasSocialesIdsCsv; }
    public void setObrasSocialesIdsCsv(String obrasSocialesIdsCsv) { 
        this.obrasSocialesIdsCsv = obrasSocialesIdsCsv; 
    }
}