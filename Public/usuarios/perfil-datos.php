<?php
session_start();
header('Content-Type: application/json');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
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
    $stmtDatosUsuario = $db->prepare("SELECT nombre, apellido, correo FROM usuarios WHERE id_usuario = ?");
    $stmtDatosUsuario->execute([$id_usuario]);
    $usuario = $stmtDatosUsuario->fetch(PDO::FETCH_ASSOC);

    $stmtTotal = $db->prepare(
        "SELECT COUNT(*) AS total, AVG(i.porcentaje) AS promedio
         FROM intentos i
         JOIN pruebas p ON i.id_prueba = p.id_prueba
         WHERE i.id_usuario = ? AND i.fecha_fin IS NOT NULL
         AND p.titulo NOT LIKE '%Full%'"
    );
    $stmtTotal->execute([$id_usuario]);
    $resumen = $stmtTotal->fetch(PDO::FETCH_ASSOC);

    $totalExamenes = (int) $resumen['total'];
    $promedio = $resumen['promedio'] !== null ? (int) round($resumen['promedio']) : 0;

    $stmtAciertos = $db->prepare(
        "SELECT s.tipo,
                COUNT(*) AS total_respuestas,
                SUM(ru.es_correcta) AS correctas
         FROM respuestas_usuario ru
         JOIN intentos i ON ru.id_intento = i.id_intento
         JOIN preguntas p ON ru.id_pregunta = p.id_pregunta
         LEFT JOIN recursos r ON p.id_recurso = r.id_recurso
         JOIN secciones s ON (r.id_seccion = s.id_seccion OR (r.id_seccion IS NULL AND p.id_seccion = s.id_seccion))
         JOIN pruebas pr ON i.id_prueba = pr.id_prueba
         WHERE i.id_usuario = ? AND pr.titulo NOT LIKE '%Full%'
         GROUP BY s.tipo"
    );
    $stmtAciertos->execute([$id_usuario]);
    $aciertosRaw = $stmtAciertos->fetchAll(PDO::FETCH_ASSOC);

    $aciertosPorTipo = [];
    foreach ($aciertosRaw as $fila) {
        $aciertosPorTipo[$fila['tipo']] = $fila;
    }

    $stmtDisponibles = $db->prepare(
        "SELECT s.tipo, COUNT(DISTINCT s.id_prueba) AS total
         FROM secciones s
         JOIN pruebas p ON p.id_prueba = s.id_prueba
         WHERE p.activa = 1 AND p.titulo NOT LIKE '%Full%'
         GROUP BY s.tipo"
    );
    $stmtDisponibles->execute();
    $disponiblesRaw = $stmtDisponibles->fetchAll(PDO::FETCH_ASSOC);

    $disponiblesPorTipo = [];
    foreach ($disponiblesRaw as $fila) {
        $disponiblesPorTipo[strtolower($fila['tipo'])] = (int) $fila['total'];
    }

    $stmtCompletadas = $db->prepare(
        "SELECT
            (SELECT tipo FROM secciones WHERE id_prueba = p.id_prueba LIMIT 1) as tipo,
            COUNT(DISTINCT i.id_prueba) AS completadas
         FROM intentos i
         JOIN pruebas p ON i.id_prueba = p.id_prueba
         WHERE i.id_usuario = ? AND i.fecha_fin IS NOT NULL AND p.titulo NOT LIKE '%Full%'
         GROUP BY tipo"
    );
    $stmtCompletadas->execute([$id_usuario]);
    $completadasRaw = $stmtCompletadas->fetchAll(PDO::FETCH_ASSOC);

    $completadasPorTipo = [];
    foreach ($completadasRaw as $fila) {
        $completadasPorTipo[strtolower($fila['tipo'])] = (int) $fila['completadas'];
    }

    $skills = [];
    $totalDisponibles = 0;
    foreach (['listening', 'reading'] as $tipo) {
        $totalRespuestas = isset($aciertosPorTipo[$tipo]) ? (int) $aciertosPorTipo[$tipo]['total_respuestas'] : 0;
        $correctas = isset($aciertosPorTipo[$tipo]) ? (int) $aciertosPorTipo[$tipo]['correctas'] : 0;

        $disp = $disponiblesPorTipo[$tipo] ?? 0;
        $totalDisponibles += $disp;

        $completadas = $completadasPorTipo[$tipo] ?? 0;
        $progresoTipo = $disp > 0 ? round(($completadas / $disp) * 100) : 0;

        $skills[] = [
            "tipo" => $tipo,
            "completadas" => $completadas,
            "disponibles" => $disp,
            "porcentaje" => $progresoTipo
        ];
    }

    $porcentajeProgreso = $totalDisponibles > 0 ? (int) round(($totalExamenes / $totalDisponibles) * 100) : 0;

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
        "nombre" => $usuario['nombre'],
        "apellido" => $usuario['apellido'],
        "correo" => $usuario['correo'],
        "totalExamenes" => $totalExamenes,
        "promedio" => $promedio,
        "porcentajeProgreso" => $porcentajeProgreso,
        "skills" => $skills,
        "actividad" => $actividad
    ]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}
