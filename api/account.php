<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\User;

require_once '../database/Models/User.php';

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    if (!isset($_GET['id'])) {
        echo json_encode(array('error' => 'Missing parameters', 'status' => 'error'));
        exit();
    }

    if (isset($_GET['password'])) {
        if (User::updatePassword($_GET['id'], $_GET['password'])) {
            echo json_encode(array('status' => 'success', 'data' => User::getUserById($_GET['id'])));
            exit();
        }
    }

    else if (isset($_GET['username'])) {
        if (User::updateUsername($_GET['id'], $_GET['username'])) {
            echo json_encode(array('status' => 'success', 'data' => User::getUserById($_GET['id'])));
            exit();
        }
    }

    json_encode(array('error' => 'Une erreur est survenue', 'status' => 'error'));
}
