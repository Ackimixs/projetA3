<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\StadeDev;

require_once '../../database/Models/StadeDev.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' AND isset($_POST['value'])) {
    echo json_encode(array('status' => 'success', 'data' => StadeDev::create($_POST['value'])));
    exit();
}

echo json_encode(array('status' => 'error', 'message' => 'Invalid request method'));
