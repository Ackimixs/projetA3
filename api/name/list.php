<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\Name;

require_once '../../database/Models/Name.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    echo json_encode(array('status' => 'success', 'data' => Name::list()));
}