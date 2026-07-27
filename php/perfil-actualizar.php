<?php
require 'auth-check.php';
require 'db.php';
 
$nombre   = trim($_POST['nombre'] ?? '');
$apellido = trim($_POST['apellido'] ?? '');
$correo   = trim($_POST['correo'] ?? '');
$password = $_POST['password'] ?? '';
 
if ($nombre === '' || $apellido === '' || $correo === '') {
    die("Nombre, apellido y correo son obligatorios.");
}
 
if ($password !== '') {
    if (strlen($password) < 6) {
        die("La nueva contraseña debe tener al menos 6 caracteres.");
    }
    $hash = password_hash($password, PASSWORD_DEFAULT);
 
    $stmt = $pdo->prepare(
        "UPDATE usuarios SET nombre = ?, apellido = ?, correo = ?, password_hash = ? WHERE id_usuario = ?"
    );
    $stmt->execute([$nombre, $apellido, $correo, $hash, $_SESSION['id_usuario']]);
} else {
    $stmt = $pdo->prepare(
        "UPDATE usuarios SET nombre = ?, apellido = ?, correo = ? WHERE id_usuario = ?"
    );
    $stmt->execute([$nombre, $apellido, $correo, $_SESSION['id_usuario']]);
}
 
header("Location: perfil.php");
exit;