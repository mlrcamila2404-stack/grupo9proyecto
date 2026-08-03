<?php
session_start();
header('Content-Type: application/json; charset=utf-8');

require_once("../config/conexion.php");

$correo = trim($_POST['correo'] ?? '');
$password = $_POST['password'] ?? '';

if ($correo === '' || $password === '') {
    echo json_encode(["success" => false, "message" => "Correo y contraseña son obligatorios."]);
    exit;
}

try {
    $database = new Database();
    $db = $database->getConnection();

    $sql = "SELECT id_usuario, nombre, apellido, correo, password_hash
            FROM usuarios
            WHERE correo = :correo
            LIMIT 1";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(':correo', $correo);
    $stmt->execute();

    $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($usuario && password_verify($password, $usuario['password_hash'])) {
        $_SESSION['id_usuario'] = $usuario['id_usuario'];
        $_SESSION['nombre'] = $usuario['nombre'];
        $_SESSION['correo'] = $usuario['correo'];

        echo json_encode(["success" => true, "message" => "Inicio de sesión exitoso."]);
    } else {
        echo json_encode(["success" => false, "message" => "Correo o contraseña incorrectos."]);
    }
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error del servidor: " . $e->getMessage()]);
}