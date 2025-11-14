package com.app.models;

import java.sql.Date;
import java.sql.Time;

public class Turno {
    private int id;
    private int pacienteId;
    private int medicoId;
    private Date fecha;
    private Time hora;
    private int estadoId;
    private String notas;
    private boolean activo;

    // Para mostrar en vistas
    private String estadoNombre;
    private String nombrePaciente;
    private String nombreMedico;
    private int obraSocialId;  // Obra social del paciente

    public Turno() {}

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPacienteId() { return pacienteId; }
    public void setPacienteId(int pacienteId) { this.pacienteId = pacienteId; }

    public int getMedicoId() { return medicoId; }
    public void setMedicoId(int medicoId) { this.medicoId = medicoId; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public Time getHora() { return hora; }
    public void setHora(Time hora) { this.hora = hora; }

    public int getEstadoId() { return estadoId; }
    public void setEstadoId(int estadoId) { this.estadoId = estadoId; }

    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public String getEstadoNombre() { return estadoNombre; }
    public void setEstadoNombre(String estadoNombre) { this.estadoNombre = estadoNombre; }

    public String getNombrePaciente() { return nombrePaciente; }
    public void setNombrePaciente(String nombrePaciente) { this.nombrePaciente = nombrePaciente; }

    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

    public int getObraSocialId() { return obraSocialId; }
    public void setObraSocialId(int obraSocialId) { this.obraSocialId = obraSocialId; }
}