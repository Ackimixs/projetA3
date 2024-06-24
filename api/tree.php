<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Tree;

require_once '../database/Tree.php';

if (isset($_GET['id'])) {
    echo json_encode(array('status' => 'success', 'data' => Tree::getTreeById($_GET['id'])));
} else {
    $offset = isset($_GET['offset']) ? $_GET['offset'] : 0;
    $limit = isset($_GET['limit']) ? $_GET['limit'] : 10;
    $sort = isset($_GET['sort']) ? $_GET['sort'] : 'id';
    $order = isset($_GET['order']) ? $_GET['order'] : 'ASC';

    echo json_encode(array('status' => 'success', 'data' => Tree::getTrees($limit, $offset, $sort, $order)));
}
