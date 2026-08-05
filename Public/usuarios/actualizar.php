<?php
require_once("../auth/verificar_acceso.php");
verificarSesion();

header('Content-Type: application/json; charset=utf-8');
require_once("../config/conexion.php");

$nombre = trim($_POST['nombre'] ?? '');
$apellido = trim($_POST['apellido'] ?? '');
$correo = trim($_POST['correo'] ?? '');
$password = $_POST['password'] ?? '';

if ($nombre === '' || $apellido === '' || $correo === '') {
    echo json_encode(["success" => false, "message" => "Nombre, apellido y correo son obligatorios."]);
    exit;
}

if (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["success" => false, "message" => "El correo no tiene un formato válido."]);
    exit;
}

if ($password !== '' && strlen($password) < 6) {
    echo json_encode(["success" => false, "message" => "La contraseña debe tener al menos 6 caracteres."]);
    exit;
}

try {
    $database = new Database();
    $db = $database->getConnection();

    if ($password !== '') {
        $password_hash = password_hash($password, PASSWORD_DEFAULT);

        $sql = "UPDATE usuarios
                SET nombre = :nombre, apellido = :apellido, correo = :correo, password_hash = :password_hash
                WHERE id_usuario = :id_usuario";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':password_hash', $password_hash);
    } else {
        $sql = "UPDATE usuarios
                SET nombre = :nombre, apellido = :apellido, correo = :correo
                WHERE id_usuario = :id_usuario";
        $stmt = $db->prepare($sql);
    }

    $stmt->bindParam(':nombre', $nombre);
    $stmt->bindParam(':apellido', $apellido);
    $stmt->bindParam(':correo', $correo);
    $stmt->bindParam(':id_usuario', $_SESSION['id_usuario']);
    $stmt->execute();

    $_SESSION['nombre'] = $nombre;
    $_SESSION['correo'] = $correo;

    echo json_encode(["success" => true, "message" => "Perfil actualizado correctamente."]);
} catch (PDOException $e) {
    if ($e->getCode() === '23000') {
        echo json_encode(["success" => false, "message" => "Ese correo ya está en uso por otra cuenta."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error del servidor: " . $e->getMessage()]);
    }
}