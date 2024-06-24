<?php
require_once '../database/database.php';
require_once '../database/User.php';

$db = dbConnect();

if (isset($_POST['username'])) {
    $email = getUserEmailByUsername($db, $_POST['username']);
} else if (isset($_POST['email'])) {
    $email = $_POST['email'];
} else {
    echo json_encode(false);
    exit();
}

echo json_encode(getUserWithoutPassword($db, $email));