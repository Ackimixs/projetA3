<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Tree;

require_once '../../database/Tree.php';

/*
 * haut_tronc
 * haut_tot
 * tronc_diam
 * prec_estim
 * clc_nbr_diag
 * age_estim
 * remarquable
 * longitude
 * latitude
 *
 * id_etat_arbre
 * id_pied
 * id_port
 * id_state_dev
 * id_uesr
 * */

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    echo json_encode(array('status' => 'success', 'data' => Tree::listPied()));
}