<?php
session_start();
header('Content-Type: application/json; charset=utf-8');

require_once("../config/conexion.php");

$nombre = trim($_POST['nombre'] ?? '');
$apellido = trim($_POST['apellido'] ?? '');
$correo = trim($_POST['correo'] ?? '');
$password = $_POST['password'] ?? '';
$password2 = $_POST['password2'] ?? '';

if ($nombre === '' || $apellido === '' || $correo === '' || $password === '' || $password2 === '') {
    echo json_encode(["success" => false, "message" => "Todos los campos son obligatorios."]);
    exit;
}

if (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["success" => false, "message" => "El correo no tiene un formato válido."]);
    exit;
}

if (strlen($password) < 6) {
    echo json_encode(["success" => false, "message" => "La contraseña debe tener al menos 6 caracteres."]);
    exit;
}

if ($password !== $password2) {
    echo json_encode(["success" => false, "message" => "Las contraseñas no coinciden."]);
    exit;
}

try {
    $database = new Database();
    $db = $database->getConnection();

    $sql = "INSERT INTO usuarios (nombre, apellido, correo, password_hash)
            VALUES (:nombre, :apellido, :correo, :password_hash)";
    $stmt = $db->prepare($sql);

    $password_hash = password_hash($password, PASSWORD_DEFAULT);

    $stmt->bindParam(':nombre', $nombre);
    $stmt->bindParam(':apellido', $apellido);
    $stmt->bindParam(':correo', $correo);
    $stmt->bindParam(':password_hash', $password_hash);
    $stmt->execute();

    $_SESSION['id_usuario'] = $db->lastInsertId();
    $_SESSION['nombre'] = $nombre;
    $_SESSION['correo'] = $correo;

    echo json_encode(["success" => true, "message" => "Cuenta creada exitosamente."]);
} catch (PDOException $e) {
    if ($e->getCode() === '23000') {
        echo json_encode(["success" => false, "message" => "Ese correo ya está registrado."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error del servidor: " . $e->getMessage()]);
    }
}