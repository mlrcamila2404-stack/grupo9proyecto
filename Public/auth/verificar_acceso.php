<?php
session_start();

function verificarSesion() {
    if (!isset($_SESSION['id_usuario'])) {
        http_response_code(401);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["success" => false, "message" => "No has iniciado sesión."]);
        exit;
    }
}