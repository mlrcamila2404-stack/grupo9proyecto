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

    // 1. Get attempt and test details
    $stmtIntento = $db->prepare("SELECT i.*, p.titulo as prueba_titulo FROM intentos i JOIN pruebas p ON i.id_prueba = p.id_prueba WHERE i.id_intento = ? AND i.id_usuario = ?");
    $stmtIntento->execute([$id_intento, $_SESSION['id_usuario']]);
    $intento = $stmtIntento->fetch(PDO::FETCH_ASSOC);

    if (!$intento) {
        echo json_encode(["success" => false, "message" => "Attempt not found"]);
        exit;
    }

    $id_prueba = $intento['id_prueba'];

    // 2. Get ALL questions for this test, LEFT JOIN with user answers
    // We need to join from preguntas -> recursos -> secciones -> pruebas
    $stmtReview = $db->prepare("
        SELECT
            p.id_pregunta,
            p.numero_pregunta,
            p.texto_pregunta,
            p.respuesta_correcta,
            ru.respuesta_usuario,
            r.archivo as recurso_archivo,
            r.tipo_recurso,
            ot.texto_opcion as user_option_text
        FROM preguntas p
        JOIN recursos r ON p.id_recurso = r.id_recurso
        JOIN secciones s ON r.id_seccion = s.id_seccion
        LEFT JOIN respuestas_usuario ru ON (ru.id_pregunta = p.id_pregunta AND ru.id_intento = ?)
        LEFT JOIN opciones_texto ot ON (ot.id_pregunta = p.id_pregunta AND ot.letra = ru.respuesta_usuario)
        WHERE s.id_prueba = ?
        ORDER BY p.numero_pregunta
    ");
    $stmtReview->execute([$id_intento, $id_prueba]);
    $detalles = $stmtReview->fetchAll(PDO::FETCH_ASSOC);

    // 3. Get a map of correct option texts for all questions in this test
    $stmtCorrects = $db->prepare("
        SELECT p.id_pregunta, ot.texto_opcion
        FROM preguntas p
        JOIN opciones_texto ot ON (ot.id_pregunta = p.id_pregunta AND ot.letra = p.respuesta_correcta)
        JOIN recursos r ON p.id_recurso = r.id_recurso
        JOIN secciones s ON r.id_seccion = s.id_seccion
        WHERE s.id_prueba = ?
    ");
    $stmtCorrects->execute([$id_prueba]);
    $correctAnswers = [];
    foreach ($stmtCorrects->fetchAll(PDO::FETCH_ASSOC) as $row) {
        $correctAnswers[$row['id_pregunta']] = $row['texto_opcion'];
    }

    echo json_encode([
        "success" => true,
        "intento" => $intento,
        "detalles" => $detalles,
        "correctas" => $correctAnswers
    ]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Server error: " . $e->getMessage()]);
}
