<?php
// Allow from any origin
if (isset($_SERVER['HTTP_ORIGIN'])) {
    // Adjust the allowed origin as necessary
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400'); // Cache for 1 day
}

// Handle OPTIONS requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD'])) {
        header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    }
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'])) {
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    }
    exit(0);
}

// Include the required class
use database\Tree;
require_once '../database/Tree.php';

// Set the Content-Type header for the response
header('Content-Type: application/json');

// Handle GET requests
if (isset($_GET['id'])) {
    echo json_encode(array('status' => 'success', 'data' => Tree::getTreeById($_GET['id'])));
} else {
    $offset = isset($_GET['offset']) ? $_GET['offset'] : 0;
    $limit = isset($_GET['limit']) ? $_GET['limit'] : 10;
    $sort = isset($_GET['sort']) ? $_GET['sort'] : 'id';
    $order = isset($_GET['order']) ? $_GET['order'] : 'ASC';

    echo json_encode(array('status' => 'success', 'data' => Tree::getTrees($limit, $offset, $sort, $order)));
}
