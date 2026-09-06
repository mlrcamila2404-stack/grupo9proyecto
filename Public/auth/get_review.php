<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
require_once("../config/conexion.php");

if (!isset($_SESSION['id_usuario'])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Unauthorized"]);
    exit;
}

$id_intento = (int)($_GET['id'] ?? 0);

if ($id_intento <= 0) {
    echo json_encode(["success" => false, "message" => "Invalid attempt ID"]);
    exit;
}

try {
    $database = new Database();
    $db = $database->getConnection();

    $stmtIntento = $db->prepare("SELECT i.*, p.titulo as prueba_titulo FROM intentos i JOIN pruebas p ON i.id_prueba = p.id_prueba WHERE i.id_intento = ? AND i.id_usuario = ?");
    $stmtIntento->execute([$id_intento, $_SESSION['id_usuario']]);
    $intento = $stmtIntento->fetch(PDO::FETCH_ASSOC);

    if (!$intento) {
        echo json_encode(["success" => false, "message" => "Attempt not found"]);
        exit;
    }

    $stmtResumen = $db->prepare("
        SELECT ru.id_pregunta, ru.respuesta_usuario, p.respuesta_correcta, p.numero_pregunta, p.texto_pregunta,
               r.archivo as recurso_archivo, r.tipo_recurso, ot.texto_opcion
        FROM respuestas_usuario ru
        JOIN preguntas p ON ru.id_pregunta = p.id_pregunta
        JOIN recursos r ON p.id_recurso = r.id_recurso
        JOIN opciones_texto ot ON p.id_pregunta = ot.id_pregunta AND ot.letra = ru.respuesta_usuario
        WHERE ru.id_intento = ?
        ORDER BY p.numero_pregunta
    ");
    $stmtResumen->execute([$id_intento]);
    $respuestasUsuario = $stmtResumen->fetchAll(PDO::FETCH_ASSOC);

    $stmtCorrectas = $db->prepare("
        SELECT ot.letra, ot.texto_opcion
        FROM opciones_texto ot
        JOIN preguntas p ON ot.id_pregunta = p.id_pregunta
        WHERE p.id_pregunta IN (
            SELECT id_pregunta FROM respuestas_usuario WHERE id_intento = ?
        ) AND ot.letra = p.respuesta_correcta
    ");
    $stmtCorrectas->execute([$id_intento]);
    $correctasMap = [];
    foreach ($stmtCorrectas->fetchAll(PDO::FETCH_ASSOC) as $row) {
        $correctasMap[$row['letra']] = $row['texto_opcion'];
    }

    // a better way to map correct answers per question
    $stmtAllCorrect = $db->prepare("
        SELECT p.id_pregunta, ot.texto_opcion
        FROM preguntas p
        JOIN opciones_texto ot ON p.id_pregunta = ot.id_pregunta AND ot.letra = p.respuesta_correcta
        WHERE p.id_pregunta IN (
            SELECT id_pregunta FROM respuestas_usuario WHERE id_intento = ?
        )
    ");
    $stmtAllCorrect->execute([$id_intento]);
    $correctAnswers = [];
    foreach ($stmtAllCorrect->fetchAll(PDO::FETCH_ASSOC) as $row) {
        $correctAnswers[$row['id_pregunta']] = $row['texto_opcion'];
    }

    echo json_encode([
        "success" => true,
        "intento" => $intento,
        "detalles" => $respuestasUsuario,
        "correctas" => $correctAnswers
    ]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Server error: " . $e->getMessage()]);
}
