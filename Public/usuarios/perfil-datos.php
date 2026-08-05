<?php
require_once("../auth/verificar_acceso.php");
verificarSesion();

header('Content-Type: application/json; charset=utf-8');
require_once("../config/conexion.php");

try {
    $database = new Database();
    $db = $database->getConnection();

    $sql = "SELECT nombre, apellido, correo
            FROM usuarios
            WHERE id_usuario = :id_usuario
            LIMIT 1";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(':id_usuario', $_SESSION['id_usuario']);
    $stmt->execute();

    $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$usuario) {
        http_response_code(404);
        echo json_encode(["success" => false, "message" => "Usuario no encontrado."]);
        exit;
    }

    $sqlStats = "SELECT COUNT(*) AS total, AVG(porcentaje) AS promedio
                 FROM intentos
                 WHERE id_usuario = :id_usuario AND fecha_fin IS NOT NULL";
    $stmtStats = $db->prepare($sqlStats);
    $stmtStats->bindParam(':id_usuario', $_SESSION['id_usuario']);
    $stmtStats->execute();

    $stats = $stmtStats->fetch(PDO::FETCH_ASSOC);
    $totalExamenes = (int) $stats['total'];
    $promedio = $stats['promedio'] !== null ? (int) round($stats['promedio']) : 0;

    echo json_encode([
        "success" => true,
        "nombre" => $usuario['nombre'],
        "apellido" => $usuario['apellido'],
        "correo" => $usuario['correo'],
        "totalExamenes" => $totalExamenes,
        "promedio" => $promedio
    ]);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error del servidor: " . $e->getMessage()]);
}