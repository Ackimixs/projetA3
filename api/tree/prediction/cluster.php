<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\Tree;

require_once '../../../database/Models/Tree.php';

$id = $_GET['id'] ?? null;

$model = $_GET['model'] ?? 'Kmeans';

$nb_clusters = $_GET['nb_clusters'] ?? 3;

if (isset($id)) {
    $tree = Tree::getTreeById($id);

    if ($tree) {
        $data = array($tree['haut_tronc'], $tree['haut_tot'], $tree['tronc_diam'], $tree['age_estim']);

        file_put_contents('../../../IA/f1.json', json_encode($data));

        exec('cd ../../../IA && python3 load_models.py --nb_clusters '. $nb_clusters .' --algo '. $model .' --f1 --input_json f1.json');

        $out = json_decode(file_get_contents('../../../IA/output.json'));

        echo json_encode($out);
    } else {
        echo json_encode(array('status' => 'error', 'message' => 'Tree not found'));
    }
} else {
    $trees = Tree::getNotNullAgeTrees();

    $data = array_map(function($tree) {
        return array($tree['haut_tronc'], $tree['tronc_diam'], $tree['age_estim'], $tree['prec_estim']);
    }, $trees);

    file_put_contents('../../../IA/f1.json', json_encode($data));

    exec('cd ../../../IA && python3 load_models.py --nb_clusters '. $nb_clusters .' --algo '. $model .' --f1 --input_json f1.json');

    $out = json_decode(file_get_contents('../../../IA/output.json'));

    $res_array = array();

    for ($i = 0; $i < count($trees); $i++) {
        $res_array[] = array('tree' => $trees[$i], 'cluster' => $out[$i]->cluster);
    }

    echo json_encode($res_array);
}