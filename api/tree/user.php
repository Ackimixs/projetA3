<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\Tree;

require_once '../../database/Models/Tree.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET' AND isset($_GET['id'])) {
    echo json_encode(array('status' => 'success', 'data' => Tree::getTreeByUserId($_GET['id'])));
    exit();
}

echo json_encode(array('status' => 'error', 'message' => 'Invalid request method or missing parameters'));
