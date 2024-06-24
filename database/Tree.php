<?php

namespace database;

use PDO;
use PDOException;

require_once('database.php');

class Tree
{
    static function getTrees()
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "tree"';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function getTreeById($id)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "tree" WHERE "tree".id = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function getTreeByUserId($id)
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "tree" WHERE "tree".id_user = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function updateAge($id, $age) {
        try {
            $db = database::connectionDB();
            $request = 'UPDATE "tree" SET age_estim = :age WHERE id = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':id', $id);
            $stmt->bindParam(':age', $age);
            $stmt->execute();
            return true;
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function updateDeracinement($id, $deracinement) {
        try {
            $db = database::connectionDB();
            $request = 'UPDATE "tree" SET risque_deracinement = :deracinement WHERE id = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':id', $id);
            $stmt->bindParam(':deracinement', $deracinement);
            $stmt->execute();
            return true;
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function updateCluster($id, $cluster) {
        try {
            $db = database::connectionDB();
            $request = 'UPDATE "tree" SET cluster = :cluster WHERE id = :id';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':id', $id);
            $stmt->bindParam(':cluster', $cluster);
            $stmt->execute();
            return true;
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function createArbre($haut_tronc, $haut_tot, $tronc_diam, $prec_estim, $clc_nbr_diag, $remarquable, $longitude, $latitude, $id_etat_arbre, $id_pied, $id_port, $id_stade_dev, $id_user)
    {
        try {
            $db = database::connectionDB();
            $request = 'INSERT INTO "tree" (haut_tronc, haut_tot, tronc_diam, prec_estim, clc_nbr_diag, remarquable, longitude, latitude, id_etat_arbre, id_pied, id_port, id_stade_dev, id_user) VALUES (:haut_tronc, :haut_tot, :tronc_diam, :prec_estim, :clc_nbr_diag, :remarquable, :longitude, :latitude, :id_etat_arbre, :id_pied, :id_port, :id_stade_dev, :id_user) RETURNING *';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':haut_tronc', $haut_tronc);
            $stmt->bindParam(':haut_tot', $haut_tot);
            $stmt->bindParam(':tronc_diam', $tronc_diam);
            $stmt->bindParam(':prec_estim', $prec_estim);
            $stmt->bindParam(':clc_nbr_diag', $clc_nbr_diag);
            $stmt->bindParam(':remarquable', $remarquable);
            $stmt->bindParam(':longitude', $longitude);
            $stmt->bindParam(':latitude', $latitude);
            $stmt->bindParam(':id_etat_arbre', $id_etat_arbre);
            $stmt->bindParam(':id_pied', $id_pied);
            $stmt->bindParam(':id_port', $id_port);
            $stmt->bindParam(':id_stade_dev', $id_stade_dev);
            $stmt->bindParam(':id_user', $id_user);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function listEtatArbre() {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "etat_arbre"';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function listPied() {
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

    static function listPort() {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "port"';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }

    static function listStadeDev() {
        try {
            $db = database::connectionDB();
            $request = 'SELECT * FROM "stade_dev"';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }
}