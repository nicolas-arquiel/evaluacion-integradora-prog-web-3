package com.app.models;

public class Paciente {

    private int id;
    private String nombre;
    private String email;
    private String numeroTelefono;
    private String documento;
    private int obraSocialId;
    private String obraSocialNombre;  // Para mostrar en vistas
    private boolean activo;

    public Paciente() {}

    public Paciente(int id, String nombre, String email, String numeroTelefono, 
                    String documento, int obraSocialId, boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.email = email;
        this.numeroTelefono = numeroTelefono;
        this.documento = documento;
        this.obraSocialId = obraSocialId;
        this.activo = activo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getNumeroTelefono() { return numeroTelefono; }
    public void setNumeroTelefono(String numeroTelefono) { this.numeroTelefono = numeroTelefono; }

    public String getDocumento() { return documento; }
    public void setDocumento(String documento) { this.documento = documento; }

    public int getObraSocialId() { return obraSocialId; }
    public void setObraSocialId(int obraSocialId) { this.obraSocialId = obraSocialId; }

    public String getObraSocialNombre() { return obraSocialNombre; }
    public void setObraSocialNombre(String obraSocialNombre) { 
        this.obraSocialNombre = obraSocialNombre; 
    }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
}