package com.app.models;

import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.stream.Collectors;

public class Turno {
    private int id;
    private int idPaciente;
    private int idMedico;
    private Date fecha;
    private Time hora;

    private int idEstado;
    private String estadoNombre;

    private String nombrePaciente;
    private String nombreMedico;

    private List<Integer> obrasIds;

    public Turno() {}

    // Getters y setters básicos
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public Time getHora() { return hora; }
    public void setHora(Time hora) { this.hora = hora; }

    public int getIdEstado() { return idEstado; }
    public void setIdEstado(int idEstado) { this.idEstado = idEstado; }

    public String getEstadoNombre() { return estadoNombre; }
    public void setEstadoNombre(String estadoNombre) { this.estadoNombre = estadoNombre; }

    public String getNombrePaciente() { return nombrePaciente; }
    public void setNombrePaciente(String nombrePaciente) { this.nombrePaciente = nombrePaciente; }

    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

    // Obras del paciente
    public List<Integer> getObrasIds() { return obrasIds; }
    public void setObrasIds(List<Integer> obrasIds) { this.obrasIds = obrasIds; }

    // CSV para JSP
    public String getObrasIdsCsv() {
        if (obrasIds == null || obrasIds.isEmpty()) return "";
        return obrasIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
    }
}
