<?php

namespace database\Models;

use database\database;
use PDO;
use PDOException;

require_once __DIR__ . '/../database.php';

class Pied
{
    static function list()
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "pied"';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function find($value)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "pied" WHERE value = :value';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':value', $value);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function create($value)
    {
        try {
            $db = database::connectionDB();
            $request = 'INSERT INTO pied (value) VALUES (:value) RETURNING *';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':value', $value);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }
}