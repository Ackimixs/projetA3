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

if (!isset($_POST['username']) || !isset($_POST['email']) || !isset($_POST['password'])) {
    echo json_encode(array('error' => 'Missing parameters', 'status' => 'error'));
    exit();
}

if (User::getUserByEmail($_POST['email'])) {
    echo json_encode(array('error' => 'Email already exists', 'status' => 'error'));
    exit();
}

if (User::getUserByUsername($_POST['username'])) {
    echo json_encode(array('error' => 'Username already exists', 'status' => 'error'));
    exit();
}

if (User::addUser($_POST['username'], $_POST['email'], $_POST['password'])) {

    echo json_encode(array('status' => 'success', 'data' => User::getUserWithoutPassword($_POST['email'])));

    exit();
}

echo json_encode(array('error' => 'An error occurred', 'status' => 'error'));
