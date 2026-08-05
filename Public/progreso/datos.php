<?php
session_start();
header('Content-Type: application/json');
require_once("../config/conexion.php");

if (!isset($_SESSION['id_usuario'])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "No autenticado"]);
    exit;
}

$database = new Database();
$db = $database->getConnection();
$id_usuario = $_SESSION['id_usuario'];

try {
    $stmtTotal = $db->prepare(
        "SELECT COUNT(*) AS total, AVG(porcentaje) AS promedio
         FROM intentos WHERE id_usuario = ? AND fecha_fin IS NOT NULL"
    );
    $stmtTotal->execute([$id_usuario]);
    $resumen = $stmtTotal->fetch(PDO::FETCH_ASSOC);

    $totalExamenes = (int) $resumen['total'];
    $promedio = $resumen['promedio'] !== null ? (int) round($resumen['promedio']) : 0;

    $stmtSkills = $db->prepare(
        "SELECT s.tipo,
                COUNT(*) AS total_respuestas,
                SUM(ru.es_correcta) AS correctas
         FROM respuestas_usuario ru
         JOIN intentos i ON ru.id_intento = i.id_intento
         JOIN preguntas p ON ru.id_pregunta = p.id_pregunta
         JOIN recursos r ON p.id_recurso = r.id_recurso
         JOIN secciones s ON r.id_seccion = s.id_seccion
         WHERE i.id_usuario = ?
         GROUP BY s.tipo"
    );
    $stmtSkills->execute([$id_usuario]);
    $skillsRaw = $stmtSkills->fetchAll(PDO::FETCH_ASSOC);

    $skills = [];
    foreach ($skillsRaw as $fila) {
        $total = (int) $fila['total_respuestas'];
        $correctas = (int) $fila['correctas'];
        $skills[] = [
            "tipo" => $fila['tipo'],
            "total" => $total,
            "correctas" => $correctas,
            "porcentaje" => $total > 0 ? round(($correctas / $total) * 100) : 0
        ];
    }

    $stmtActividad = $db->prepare(
        "SELECT i.id_intento, pr.titulo, i.fecha_fin, i.porcentaje
         FROM intentos i
         JOIN pruebas pr ON i.id_prueba = pr.id_prueba
         WHERE i.id_usuario = ? AND i.fecha_fin IS NOT NULL
         ORDER BY i.fecha_fin DESC
         LIMIT 5"
    );
    $stmtActividad->execute([$id_usuario]);
    $actividad = $stmtActividad->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "success" => true,
        "totalExamenes" => $totalExamenes,
        "promedio" => $promedio,
        "skills" => $skills,
        "actividad" => $actividad
    ]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}