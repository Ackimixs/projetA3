<?php
header("Access-Control-Allow-Origin: *"); // Allow from any origin
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow specific methods
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Allow specific headers

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
    $all = isset($_GET['all']) && $_GET['all'];

    if ($all) {
        echo json_encode(array('status' => 'success', 'data' => Tree::getAllTrees()));
    } else {
        echo json_encode(array('status' => 'success', 'data' => Tree::getTrees($limit, $offset, $sort, $order)));
    }
}
