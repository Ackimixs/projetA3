<?php

namespace database\Models;

use database\database;
use PDO;
use PDOException;

require_once __DIR__ . '/../database.php';

class User
{
    static function auth($username, $mdp)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "user" WHERE "user".username = :username';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':username', $username);
            $stmt->execute();
            $data = $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
        return ($data && password_verify($mdp, $data['password']));
    }

    static function addUser($username, $password)
    {
        try {
            $db = database::connectionDB();
            $request = 'INSERT INTO "user" (password, username) VALUES (:password, :username)';
            $stmt = $db->prepare($request);
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt->bindParam(':password', $password_hash);
            $stmt->bindParam(':username', $username);
            $stmt->execute();
            return true;
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function getUserById($id) {
        try {
            $db = database::connectionDB();
            $request = 'SELECT id, username FROM "user" WHERE id = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function getUserWithoutPassword($username) {
        try {
            $db = database::connectionDB();
            $request = 'SELECT id, username FROM "user" WHERE username = :username';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':username', $username);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function updatePassword($id, $password)
    {
        try {
            $db = database::connectionDB();
            $request = 'UPDATE "user" SET password = :password WHERE id = :id';
            $stmt = $db->prepare($request);
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt->bindParam(':password', $password_hash);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return true;
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function updateUsername($id, $username)
    {
        try {
            $db = database::connectionDB();
            $request = 'UPDATE "user" SET username = :username WHERE id = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return true;
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }
}