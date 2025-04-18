<?php

header('Content-Type: application/json');

$request = $_SERVER['REQUEST_URI'];

switch ($request) {
    case '/':
        echo json_encode([
            'message' => 'Hello from PHP Docker!'
        ]);
        break;
    case '/health':
        echo json_encode([
            'status' => 'healthy'
        ]);
        break;
    default:
        http_response_code(404);
        echo json_encode([
            'error' => 'Not Found'
        ]);
        break;
}