<?php
header('Content-Type: application/json');
require_once("../config/conexion.php");

$database = new Database();
$db = $database->getConnection();

$id_prueba = isset($_GET['id_prueba']) ? (int)$_GET['id_prueba'] : 0;

if ($id_prueba <= 0) {
    echo json_encode(["success" => false, "message" => "id_prueba requerido"]);
    exit;
}

try {
    $stmtSecciones = $db->prepare(
        "SELECT id_seccion, titulo, tipo, descripcion, orden FROM secciones WHERE id_prueba = ? ORDER BY orden ASC"
    );
    $stmtSecciones->execute([$id_prueba]);
    $secciones = $stmtSecciones->fetchAll(PDO::FETCH_ASSOC);

    foreach ($secciones as &$seccion) {
        $stmtRecursos = $db->prepare(
            "SELECT id_recurso, tipo_recurso, archivo, descripcion, orden FROM recursos WHERE id_seccion = ? ORDER BY orden ASC"
        );
        $stmtRecursos->execute([$seccion['id_seccion']]);
        $recursos = $stmtRecursos->fetchAll(PDO::FETCH_ASSOC);

        foreach ($recursos as &$recurso) {
            $stmtPreguntas = $db->prepare(
                "SELECT id_pregunta, numero_pregunta, texto_pregunta FROM preguntas WHERE id_recurso = ? ORDER BY numero_pregunta ASC"
            );
            $stmtPreguntas->execute([$recurso['id_recurso']]);
            $preguntas = $stmtPreguntas->fetchAll(PDO::FETCH_ASSOC);

            foreach ($preguntas as &$pregunta) {
                $stmtOpciones = $db->prepare(
                    "SELECT letra, texto_opcion FROM opciones_texto WHERE id_pregunta = ? ORDER BY letra ASC"
                );
                $stmtOpciones->execute([$pregunta['id_pregunta']]);
                $pregunta['opciones'] = $stmtOpciones->fetchAll(PDO::FETCH_ASSOC);
            }

            $recurso['preguntas'] = $preguntas;
        }

        $seccion['recursos'] = $recursos;
    }

    echo json_encode(["success" => true, "secciones" => $secciones]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}