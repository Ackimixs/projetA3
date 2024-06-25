<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Tree;

require_once '../../database/Tree.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (!isset($_POST['haut_tronc']) || !isset($_POST['haut_tot']) || !isset($_POST['tronc_diam']) || !isset($_POST['prec_estim']) || !isset($_POST['clc_nbr_diag']) || !isset($_POST['remarquable']) || !isset($_POST['longitude']) || !isset($_POST['latitude']) || !isset($_POST['nom']) || !isset($_POST['id_etat_arbre']) || !isset($_POST['id_pied']) || !isset($_POST['id_port']) || !isset($_POST['id_stade_dev']) || !isset($_POST['id_user'])) {
        echo json_encode(array('status' => 'error', 'message' => 'Missing parameters'));
        exit();
    }

    if ($_POST['haut_tot'] < $_POST['haut_tronc']) {
        echo json_encode(array('status' => 'error', 'message' => 'La hauteur totale doit être supérieure à la hauteur du tronc'));
        exit();
    }

    $data = Tree::createArbre($_POST['haut_tronc'], $_POST['haut_tot'], $_POST['tronc_diam'], $_POST['prec_estim'], $_POST['clc_nbr_diag'], $_POST['remarquable'], $_POST['longitude'], $_POST['latitude'], $_POST['nom'], $_POST['id_etat_arbre'], $_POST['id_pied'], $_POST['id_port'], $_POST['id_stade_dev'], $_POST['id_user']);

    echo json_encode(array('status' => 'success', 'data' => $data));
    exit();
}

echo json_encode(array('status' => 'error', 'message' => 'Invalid request method'));