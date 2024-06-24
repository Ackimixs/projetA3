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
    $email = User::getUserEmailWithUsername($_POST['username'])['email'];
} else if (isset($_POST['email'])) {
    $email = $_POST['email'];
} else {
    echo json_encode(array('error' => 'Missing parameters', 'status' => 'error'));
    exit();
}

if (User::auth($email, $_POST['password'])) {
    echo json_encode(array('status' => 'success', 'data' => User::getUserWithoutPassword($email)));
    exit();
}

echo json_encode(array('error' => 'An error occurred', 'status' => 'error'));
