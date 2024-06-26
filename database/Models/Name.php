<?php

namespace database\Models;

use database\database;
use PDO;
use PDOException;

require_once __DIR__ . '/../database.php';

class Name
{
    static function list() {
        try {
            $db = database::connectionDB();
            $request = 'SELECT nom as value FROM "tree" GROUP BY nom';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }
}