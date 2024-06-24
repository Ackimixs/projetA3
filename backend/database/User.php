<?php

namespace database;

use PDO;
use PDOException;

require_once('database.php');

class User
{
    static function auth($email, $mdp)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "user" WHERE "user".email = :email';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            $data = $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
        return ($data && password_verify($mdp, $data['password']));
    }

    static function getUserByEmail($email)
    {
        try {
            $db = $db = database::connectionDB();
            $request = 'SELECT * FROM "user"
                        WHERE "user".email = :email';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function getUserByUsername($username)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "user"
                        WHERE "user".username = :username';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':username', $username);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function addUser($username, $email, $password)
    {
        try {
            $db = database::connectionDB();
            $request = 'INSERT INTO "user" (email, password, username) VALUES (:email, :password, :username)';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':email', $email);
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

    static function getUserWithoutPassword($email)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT id, email, username FROM "user" WHERE email = :email';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function getUserEmailWithUsername($username)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT email FROM "user" WHERE username = :username';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':username', $username);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }
}