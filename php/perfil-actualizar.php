<?php
require 'auth-check.php';
require 'db.php';

header('Content-Type: application/json');
  
$nombre   = trim($_POST['nombre'] ?? '');
$apellido = trim($_POST['apellido'] ?? '');
$correo   = trim($_POST['correo'] ?? '');
$password = $_POST['password'] ?? '';
  
if ($nombre === '' || $apellido === '' || $correo === '') {
    echo json_encode(["success" => false, "message" => "Nombre, apellido y correo son obligatorios."]);
    exit;
}
  
try {
    if ($password !== '') {
        if (strlen($password) < 6) {
            echo json_encode(["success" => false, "message" => "La nueva contraseña debe tener al menos 6 caracteres."]);
            exit;
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
    
    echo json_encode(["success" => true, "message" => "Perfil actualizado correctamente."]);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error al actualizar (el correo podría estar duplicado)."]);
}