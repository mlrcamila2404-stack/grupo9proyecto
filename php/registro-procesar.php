<?php
require 'db.php';
 
$nombre    = trim($_POST['nombre'] ?? '');
$apellido  = trim($_POST['apellido'] ?? '');
$correo    = trim($_POST['correo'] ?? '');
$password  = $_POST['password'] ?? '';
$password2 = $_POST['password2'] ?? '';
 
if ($nombre === '' || $apellido === '' || $correo === '' || $password === '') {
    die("Por favor completa todos los campos.");
}
 
if ($password !== $password2) {
    die("Las contraseñas no coinciden.");
}
 
if (strlen($password) < 6) {
    die("La contraseña debe tener al menos 6 caracteres.");
}
 
$check = $pdo->prepare("SELECT id_usuario FROM usuarios WHERE correo = ?");
$check->execute([$correo]);
 
if ($check->fetch()) {
    die("Ya existe una cuenta registrada con ese correo.");
}
 
$password_hash = password_hash($password, PASSWORD_DEFAULT);
 
$stmt = $pdo->prepare(
    "INSERT INTO usuarios (nombre, apellido, correo, password_hash) VALUES (?, ?, ?, ?)"
);
$stmt->execute([$nombre, $apellido, $correo, $password_hash]);
 
header("Location: ../login.html");
exit;