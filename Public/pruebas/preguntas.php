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
        // 1. Fetch ALL questions for this section, regardless of resource
        $stmtPreguntas = $db->prepare(
            "SELECT id_pregunta, numero_pregunta, texto_pregunta, id_recurso FROM preguntas WHERE id_seccion = ? ORDER BY numero_pregunta ASC"
        );
        $stmtPreguntas->execute([$seccion['id_seccion']]);
        $preguntas_all = $stmtPreguntas->fetchAll(PDO::FETCH_ASSOC);

        foreach ($preguntas_all as &$pregunta) {
            $stmtOpciones = $db->prepare(
                "SELECT letra, texto_opcion FROM opciones_texto WHERE id_pregunta = ? ORDER BY letra ASC"
            );
            $stmtOpciones->execute([$pregunta['id_pregunta']]);
            $pregunta['opciones'] = $stmtOpciones->fetchAll(PDO::FETCH_ASSOC);
        }

        // 2. Get resources for this section to group questions
        $stmtRecursos = $db->prepare(
            "SELECT id_recurso, tipo_recurso, archivo, descripcion, orden FROM recursos WHERE id_seccion = ? ORDER BY orden ASC"
        );
        $stmtRecursos->execute([$seccion['id_seccion']]);
        $recursos = $stmtRecursos->fetchAll(PDO::FETCH_ASSOC);

        // Group questions by their resource
        foreach ($recursos as &$recurso) {
            $recurso['preguntas'] = array_filter($preguntas_all, function($p) use ($recurso) {
                return $p['id_recurso'] == $recurso['id_recurso'];
            });
            // Re-index array for JSON (avoid objects in JS)
            $recurso['preguntas'] = array_values($recurso['preguntas']);
        }

        // Handle questions with NO resource (e.g., Reading 1)
        $no_resource_questions = array_filter($preguntas_all, function($p) {
            return is_null($p['id_recurso']);
        });

        if (!empty($no_resource_questions)) {
            $recursos[] = [
                'id_recurso' => null,
                'tipo_recurso' => 'text',
                'archivo' => null,
                'descripcion' => 'General Questions',
                'orden' => 0,
                'preguntas' => array_values($no_resource_questions)
            ];
        }

        $seccion['recursos'] = $recursos;
    }

    echo json_encode(["success" => true, "secciones" => $secciones]);

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}
