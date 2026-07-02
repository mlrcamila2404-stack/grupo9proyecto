CREATE DATABASE usuarios;

CREATE TABLE usuarios(
 id_usuario INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 apellido VARCHAR(100) NOT NULL,
 correo VARCHAR(100),
 password_hash VARCHAR(100)
 
 );
 