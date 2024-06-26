<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

use database\Models\Tree;

require_once '../../../database/Models/Tree.php';

$id = $_GET['id'];

$model = $_GET['model'] ?? 'MLPClassifier';

$tree = Tree::getTreeById($id);

$gridSearch = isset($_GET['gridSearch']) && $_GET['gridSearch'];

if ($tree) {
    $data = [array('haut_tronc' => $tree['haut_tronc'], 'haut_tot' => $tree['haut_tot'], 'tronc_diam' => $tree['tronc_diam'], 'fk_prec_estim' => $tree['prec_estim'], 'clc_nbr_diag' => $tree['clc_nbr_diag'])];

    file_put_contents('../../../IA/f2.json', json_encode($data));

    if ($gridSearch) {
        exec('cd ../../../IA && python3 load_models.py --model '. $model .' --f2 --input_json f2.json --grid_search');
    } else {
        exec('cd ../../../IA && python3 load_models.py --model '. $model .' --f2 --input_json f2.json');
    }

    $out = json_decode(file_get_contents('../../../IA/output.json'))[0];

    $age = $out->class * 10 + 5;

    Tree::updateAge($id, $age);

    echo json_encode(array('status' => 'success', 'age' => $age));
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Tree not found'));
}
