<?php

namespace database;
use PDO;
use PDOException;

extension_loaded('pdo_pgsql') or die('The PDO PostgreSQL extension is not enabled.');

require_once('constants.php');

class database
{
    static $db = null;

    static function connectionDB()
    {
        if (self::$db != null) {
            return self::$db;
        }
        try {
            $db = new PDO('pgsql:host=' . DB_SERVER . ';port=' . DB_PORT . ';dbname=' . DB_NAME, DB_USER, DB_PASSWORD);
        } catch (PDOException $exception) {
            echo "in the catch";
            error_log('Connection error: ' . $exception->getMessage());
            echo 'Connection error: ' . $exception->getMessage();
            return false;
        }
        self::$db = $db;
        return $db;
    }
}
