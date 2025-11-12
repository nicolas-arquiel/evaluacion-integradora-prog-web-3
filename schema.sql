DROP TABLE IF EXISTS turnos CASCADE;
DROP TABLE IF EXISTS pacientes_obras_sociales CASCADE;
DROP TABLE IF EXISTS medicos_obras_sociales CASCADE;
DROP TABLE IF EXISTS estados_turno CASCADE;
DROP TABLE IF EXISTS obras_sociales CASCADE;
DROP TABLE IF EXISTS pacientes CASCADE;
DROP TABLE IF EXISTS medicos CASCADE;

CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    matricula VARCHAR(50) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    telefono VARCHAR(30),
    documento VARCHAR(20) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE obras_sociales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE estados_turno (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE medicos_obras_sociales (
    id_medico INT NOT NULL,
    id_obra_social INT NOT NULL,
    PRIMARY KEY (id_medico, id_obra_social),
    FOREIGN KEY (id_medico) REFERENCES medicos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_obra_social) REFERENCES obras_sociales(id) ON DELETE CASCADE
);

CREATE TABLE pacientes_obras_sociales (
    id_paciente INT NOT NULL,
    id_obra_social INT NOT NULL,
    PRIMARY KEY (id_paciente, id_obra_social),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (id_obra_social) REFERENCES obras_sociales(id) ON DELETE CASCADE
);

CREATE TABLE turnos (
    id SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_estado INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medicos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_estado) REFERENCES estados_turno(id),
    CONSTRAINT turno_unico UNIQUE (id_medico, fecha, hora)
);

INSERT INTO estados_turno (nombre) VALUES
('activo'),
('cancelado'),
('completado'),
('reprogramado');

INSERT INTO medicos (nombre_completo, especialidad, matricula) VALUES
('Dr. Juan Perez', 'Cardiologia', 'CAR-1024'),
('Dra. Maria Gomez', 'Pediatria', 'PED-2091'),
('Dr. Carlos Lopez', 'Dermatologia', 'DER-3178');

INSERT INTO pacientes (nombre_completo, telefono, documento) VALUES
('Ana Torres', '1122334455', '30123456'),
('Luis Fernandez', '1198765432', '28999888');

INSERT INTO obras_sociales (nombre) VALUES
('OSDE'),
('Swiss Medical'),
('IOMA'),
('PAMI');

INSERT INTO medicos_obras_sociales (id_medico, id_obra_social) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 4),
(3, 3);

INSERT INTO pacientes_obras_sociales (id_paciente, id_obra_social) VALUES
(1, 1),
(2, 4);

INSERT INTO turnos (id_paciente, id_medico, fecha, hora, id_estado) VALUES
(1, 1, '2025-11-14', '10:00', 1),
(2, 2, '2025-11-15', '11:30', 1);
