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
    $data = [array('haut_tronc' => $tree['haut_tronc'], 'tronc_diam' => $tree['tronc_diam'], 'haut_tot' => $tree['haut_tot'], 'age_estim' => $tree['age_estim'])];

    file_put_contents('../../../IA/f3.json', json_encode($data));

    if ($gridSearch) {
        exec('cd ../../../IA && python3 load_models.py --model '. $model .' --f3 --input_json f3.json --grid_search');
    } else {
        exec('cd ../../../IA && python3 load_models.py --model '. $model .' --f3 --input_json f3.json');
    }

    $out = json_decode(file_get_contents('../../../IA/output.json'))[0];

    Tree::updateDeracinement($id, $out->class === 1 ? 'true' : 'false');

    echo json_encode(array('status' => 'success', 'deracinement' => $out->class));
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Tree not found'));
}
