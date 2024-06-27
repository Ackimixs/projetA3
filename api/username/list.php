<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\User;

require_once '../../database/Models/User.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    echo json_encode(array('status' => 'success', 'data' => User::list()));
}