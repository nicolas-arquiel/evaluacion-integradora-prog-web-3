DROP TABLE IF EXISTS turnos CASCADE;
DROP TABLE IF EXISTS pacientes_obras_sociales CASCADE;
DROP TABLE IF EXISTS medicos_obras_sociales CASCADE;
DROP TABLE IF EXISTS estados CASCADE;
DROP TABLE IF EXISTS especialidades CASCADE;
DROP TABLE IF EXISTS obras_sociales CASCADE;
DROP TABLE IF EXISTS pacientes CASCADE;
DROP TABLE IF EXISTS medicos CASCADE;

-- Tabla de Especialidades
CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(255) UNIQUE NOT NULL
);

-- Tabla de Obras Sociales
CREATE TABLE obras_sociales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de Estados
CREATE TABLE estados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL
);

-- Tabla de Médicos (con especialidad_id como FK)
CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    especialidad_id INTEGER NOT NULL,
    matricula VARCHAR(50) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id)
);

-- Tabla de Pacientes (con obra_social_id como FK)
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    numero_telefono VARCHAR(20),
    documento VARCHAR(20) UNIQUE NOT NULL,
    obra_social_id INTEGER NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (obra_social_id) REFERENCES obras_sociales(id)
);

-- Tabla de Relación Médicos - Obras Sociales (muchos a muchos)
CREATE TABLE medicos_obras_sociales (
    medico_id INTEGER NOT NULL,
    obra_social_id INTEGER NOT NULL,
    PRIMARY KEY (medico_id, obra_social_id),
    FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE CASCADE,
    FOREIGN KEY (obra_social_id) REFERENCES obras_sociales(id) ON DELETE CASCADE
);

-- Tabla de Turnos
CREATE TABLE turnos (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado_id INTEGER NOT NULL DEFAULT 1,
    notas TEXT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estados(id),
    CONSTRAINT turno_unico UNIQUE (medico_id, fecha, hora)
);

-- Insertar Estados
INSERT INTO estados (nombre) VALUES 
('programado'), 
('cancelado'), 
('completado');

-- Insertar Obras Sociales
INSERT INTO obras_sociales (nombre) VALUES 
('Salud Unida'), 
('Solidaridad Protege'), 
('Vida Integral'), 
('Bienestar Comunitario'), 
('Protección Activa'), 
('Sin obra social');

-- Insertar Especialidades
INSERT INTO especialidades (descripcion) VALUES 
('Cardiología'), 
('Dermatología'), 
('Pediatría');

-- Insertar Médicos
INSERT INTO medicos (nombre, especialidad_id, matricula) VALUES
('Dr. Juan Perez', 1, 'CAR-1024'),
('Dra. Maria Gomez', 3, 'PED-2091'),
('Dr. Carlos Lopez', 2, 'DER-3178');

-- Insertar Pacientes
INSERT INTO pacientes (nombre, email, numero_telefono, documento, obra_social_id) VALUES
('Ana Torres', 'ana.torres@email.com', '1122334455', '30123456', 1),
('Luis Fernandez', 'luis.fernandez@email.com', '1198765432', '28999888', 6);

-- Insertar relación Médicos - Obras Sociales
INSERT INTO medicos_obras_sociales (medico_id, obra_social_id) VALUES
(1, 1),  -- Dr. Juan Perez con Salud Unida
(1, 2),  -- Dr. Juan Perez con Solidaridad Protege
(2, 1),  -- Dra. Maria Gomez con Salud Unida
(2, 6),  -- Dra. Maria Gomez con Sin obra social
(3, 3);  -- Dr. Carlos Lopez con Vida Integral

-- Insertar Turnos
INSERT INTO turnos (paciente_id, medico_id, fecha, hora, estado_id) VALUES
(1, 1, '2025-11-14', '10:00', 1),
(2, 2, '2025-11-15', '11:30', 1);