<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
require_once("../config/conexion.php");

if (!isset($_SESSION['id_usuario'])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Unauthorized"]);
    exit;
}

$id_usuario = $_SESSION['id_usuario'];

try {
    $database = new Database();
    $db = $database->getConnection();

    $sql = "SELECT i.id_intento, p.titulo as prueba_titulo, i.fecha_fin, i.porcentaje
            FROM intentos i
            JOIN pruebas p ON i.id_prueba = p.id_prueba
            WHERE i.id_usuario = ? AND i.fecha_fin IS NOT NULL
            ORDER BY i.fecha_fin DESC";

    $stmt = $db->prepare($sql);
    $stmt->execute([$id_usuario]);
    $historial = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "success" => true,
        "data" => $historial
    ]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Server error: " . $e->getMessage()]);
}
