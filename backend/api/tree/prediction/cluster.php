<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Tree;

require_once '../../../database/Tree.php';

$id = $_GET['id'];

$model = isset($_GET['model']) ? $_GET['model'] : 'Kmeans';

$nb_cluster = isset($_GET['nb_cluster']) ? $_GET['nb_cluster'] : 3;

$tree = Tree::getTreeById($id);

if ($tree) {
    $data = array($tree['haut_tronc'], $tree['haut_tot'], $tree['tronc_diam'], $tree['age_estim']);

    file_put_contents('../../../../IA/f1.json', json_encode($data));

    exec('cd ../../../../IA && python3 load_models.py --nb_clusters '. $nb_cluster .' --algo '. $model .' --f1 --input_json f1.json');

    $out = json_decode(file_get_contents('../../../../IA/output.json'));

    $cluster = $out->cluster;

    Tree::updateCluster($id, $cluster);

    echo json_encode($out);
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Tree not found'));
}
