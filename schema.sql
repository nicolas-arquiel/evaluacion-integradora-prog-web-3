DROP TABLE IF EXISTS turnos CASCADE;
DROP TABLE IF EXISTS pacientes_obras_sociales CASCADE;
DROP TABLE IF EXISTS medicos_obras_sociales CASCADE;
DROP TABLE IF EXISTS estados CASCADE;
DROP TABLE IF EXISTS especialidades CASCADE;
DROP TABLE IF EXISTS obras_sociales CASCADE;
DROP TABLE IF EXISTS pacientes CASCADE;
DROP TABLE IF EXISTS medicos CASCADE;

CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE obras_sociales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE estados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    especialidad_id INTEGER NOT NULL,
    matricula VARCHAR(50) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id)
);

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

CREATE TABLE medicos_obras_sociales (
    medico_id INTEGER NOT NULL,
    obra_social_id INTEGER NOT NULL,
    PRIMARY KEY (medico_id, obra_social_id),
    FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE CASCADE,
    FOREIGN KEY (obra_social_id) REFERENCES obras_sociales(id) ON DELETE CASCADE
);

CREATE TABLE turnos (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado_id INTEGER NOT NULL DEFAULT 1,
    notas TEXT,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estados(id)
);

INSERT INTO estados (nombre) VALUES
('Programado'),
('Cancelado'),
('Completado');

INSERT INTO obras_sociales (nombre) VALUES
('Sin obra social'),
('Salud Unida'),
('Solidaridad Protege'),
('Vida Integral'),
('Bienestar Comunitario'),
('Proteccion Activa');

INSERT INTO especialidades (descripcion) VALUES
('Cardiologia'),
('Dermatologia'),
('Pediatria');

INSERT INTO medicos (nombre, especialidad_id, matricula) VALUES
('Juan Perez', 1, 'CAR-1024'),
('Maria Gomez', 3, 'PED-2091'),
('Carlos Lopez', 2, 'DER-3178');

INSERT INTO pacientes (nombre, email, numero_telefono, documento, obra_social_id) VALUES
('Ana Torres', 'ana.torres@testemail.com', '1122334455', '30123456', 2),
('Luis Fernandez', 'luis.fernandez@testemail.com', '1198765432', '28999888', 1);

INSERT INTO medicos_obras_sociales (medico_id, obra_social_id) VALUES
(1, 2),
(1, 3),
(2, 2),
(2, 1),
(3, 4);

INSERT INTO turnos (paciente_id, medico_id, fecha, hora, estado_id) VALUES
(1, 1, '2025-11-14', '10:00', 1),
(2, 2, '2025-11-15', '11:30', 1);
