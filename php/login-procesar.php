<?php
session_start();
require 'db.php';
 
$correo   = trim($_POST['correo'] ?? '');
$password = $_POST['password'] ?? '';
 
if ($correo === '' || $password === '') {
    die("Por favor completa todos los campos.");
}
 
$stmt = $pdo->prepare("SELECT * FROM usuarios WHERE correo = ?");
$stmt->execute([$correo]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);
 
if ($usuario && password_verify($password, $usuario['password_hash'])) {
    $_SESSION['id_usuario'] = $usuario['id_usuario'];
    $_SESSION['nombre']     = $usuario['nombre'];
    $_SESSION['apellido']   = $usuario['apellido'];
    $_SESSION['correo']     = $usuario['correo'];
    header("Location: perfil.php");
    exit;
} else {
    die("Correo o contraseña incorrectos.");
}

header("Location: ../examenes.html");