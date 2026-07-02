CREATE DATABASE practify;

USE practify;

-- Tabla usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    password_hash VARCHAR(100)
);

-- Tabla pruebas
CREATE TABLE pruebas (
    id_prueba INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NULL,
    tiempo_minutos INT NOT NULL,
    activa BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla secciones
CREATE TABLE secciones (
    id_seccion INT AUTO_INCREMENT PRIMARY KEY,
    id_prueba INT NOT NULL,
    titulo VARCHAR(150),
    tipo ENUM('listening', 'reading') NOT NULL,
    descripcion TEXT NULL,
    orden INT NOT NULL,

    FOREIGN KEY (id_prueba)
        REFERENCES pruebas(id_prueba)
);

-- Tabla recursos
CREATE TABLE recursos (
    id_recurso INT AUTO_INCREMENT PRIMARY KEY,
    id_seccion INT NOT NULL,
    tipo_recurso ENUM('audio', 'imagen') NOT NULL,
    archivo VARCHAR(255) NOT NULL,
    descripcion TEXT NULL,
    orden INT NOT NULL,

    FOREIGN KEY (id_seccion)
        REFERENCES secciones(id_seccion)
);

-- Tabla preguntas
CREATE TABLE preguntas (
    id_pregunta INT AUTO_INCREMENT PRIMARY KEY,
    id_recurso INT NOT NULL,
    numero_pregunta INT NOT NULL,
    texto_pregunta VARCHAR(225) NULL,
    respuesta_correcta ENUM('A', 'B', 'C', 'D') NOT NULL,
    retroalimentacion TEXT NULL,

    FOREIGN KEY (id_recurso)
        REFERENCES recursos(id_recurso)
);

-- Tabla intentos
CREATE TABLE intentos (
    id_intento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_prueba INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NULL,
    puntaje DECIMAL(5,2),
    porcentaje DECIMAL(5,2),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),

    FOREIGN KEY (id_prueba)
        REFERENCES pruebas(id_prueba)
);

-- Tabla opciones_texto
CREATE TABLE opciones_texto (
    id_opcion INT AUTO_INCREMENT PRIMARY KEY,
    id_pregunta INT NOT NULL,
    letra ENUM('A', 'B', 'C', 'D') NOT NULL,
    texto_opcion VARCHAR(255) NOT NULL,

    FOREIGN KEY (id_pregunta)
        REFERENCES preguntas(id_pregunta)
);

-- Tabla respuestas_usuario
CREATE TABLE respuestas_usuario (
    id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
    id_intento INT NOT NULL,
    id_pregunta INT NOT NULL,
    respuesta_usuario ENUM('A', 'B', 'C', 'D') NOT NULL,
    es_correcta BOOLEAN NOT NULL,

    FOREIGN KEY (id_intento)
        REFERENCES intentos(id_intento),

    FOREIGN KEY (id_pregunta)
        REFERENCES preguntas(id_pregunta)
);