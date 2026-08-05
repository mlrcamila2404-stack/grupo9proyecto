<?php
session_start();
header('Content-Type: application/json');
require_once("../config/conexion.php");

if (!isset($_SESSION['id_usuario'])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "No autenticado"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);

$id_prueba = isset($data['id_prueba']) ? (int)$data['id_prueba'] : 0;
$respuestas = isset($data['respuestas']) ? $data['respuestas'] : [];

if ($id_prueba <= 0 || empty($respuestas)) {
    echo json_encode(["success" => false, "message" => "Datos incompletos"]);
    exit;
}

$database = new Database();
$db = $database->getConnection();

try {
    $db->beginTransaction();

    $stmtIntento = $db->prepare(
        "INSERT INTO intentos (id_usuario, id_prueba, fecha_inicio, fecha_fin) VALUES (?, ?, NOW(), NOW())"
    );
    $stmtIntento->execute([$_SESSION['id_usuario'], $id_prueba]);
    $id_intento = $db->lastInsertId();

    $correctas = 0;
    $total = count($respuestas);

    $stmtCorrecta = $db->prepare("SELECT respuesta_correcta FROM preguntas WHERE id_pregunta = ?");
    $stmtRespuesta = $db->prepare(
        "INSERT INTO respuestas_usuario (id_intento, id_pregunta, respuesta_usuario, es_correcta) VALUES (?, ?, ?, ?)"
    );

    foreach ($respuestas as $respuesta) {
        $id_pregunta = (int)$respuesta['id_pregunta'];
        $respuesta_usuario = $respuesta['respuesta'];

        $stmtCorrecta->execute([$id_pregunta]);
        $correcta = $stmtCorrecta->fetchColumn();

        $es_correcta = ($correcta === $respuesta_usuario) ? 1 : 0;
        if ($es_correcta) {
            $correctas++;
        }

        $stmtRespuesta->execute([$id_intento, $id_pregunta, $respuesta_usuario, $es_correcta]);
    }

    $porcentaje = $total > 0 ? round(($correctas / $total) * 100, 2) : 0;

    $stmtActualizar = $db->prepare("UPDATE intentos SET puntaje = ?, porcentaje = ? WHERE id_intento = ?");
    $stmtActualizar->execute([$correctas, $porcentaje, $id_intento]);

    $db->commit();

    echo json_encode([
        "success" => true,
        "correct" => $correctas,
        "wrong" => $total - $correctas,
        "total" => $total,
        "score" => $porcentaje
    ]);

} catch (PDOException $e) {
    $db->rollBack();
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}