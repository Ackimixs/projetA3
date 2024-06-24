<?php
header("Access-Control-Allow-Origin: *"); // Allow from any origin
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow specific methods
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Allow specific headers

use database\User;

require_once '../database/User.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(array('error' => 'Invalid request method', 'status' => 'error'));
    exit();
}

if (isset($_POST['username'])) {
    if (User::auth($_POST['username'], $_POST['password'])) {
        echo json_encode(array('status' => 'success', 'data' => User::getUserWithoutPassword($_POST['username'])));
        exit();
    }
} else {
    echo json_encode(array('error' => 'Missing parameters', 'status' => 'error'));
    exit();
}

echo json_encode(array('error' => 'An error occurred', 'status' => 'error'));
