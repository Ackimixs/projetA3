<?php

namespace database;

use PDO;
use PDOException;

require_once('database.php');

class Tree
{
    static function getTrees($limit = 10, $offset = 0, $sort = 'id', $order = 'ASC')
    {
        try {
            $db = database::connectionDB();
            $request = 'SELECT t.id, t.haut_tronc, t.haut_tot, t.tronc_diam, t.prec_estim, t.clc_nbr_diag, t.age_estim, t.remarquable, t.longitude, t.latitude, t.risque_deracinement, t.nom, ea.value as etat_arbre, p.value as pied, p2.value as port, sd.value as stade_dev, u.username FROM tree t
                          LEFT JOIN public.etat_arbre ea on ea.id = t.id_etat_arbre
                          LEFT JOIN public.pied p on p.id = t.id_pied
                          LEFT JOIN public.port p2 on p2.id = t.id_port
                          LEFT JOIN public.stade_dev sd on sd.id = t.id_stade_dev
                          LEFT JOIN public."user" u on u.id = t.id_user
                        ORDER BY ' . $sort . ' ' . $order . '
                        LIMIT :limit OFFSET :offset;';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
            $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
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

    static function createArbre($haut_tronc, $haut_tot, $tronc_diam, $prec_estim, $clc_nbr_diag, $remarquable, $longitude, $latitude, $nom, $id_etat_arbre, $id_pied, $id_port, $id_stade_dev, $id_user)
    {
        try {
            $db = database::connectionDB();
            $request = 'INSERT INTO "tree" (haut_tronc, haut_tot, tronc_diam, prec_estim, clc_nbr_diag, remarquable, longitude, latitude, nom, id_etat_arbre, id_pied, id_port, id_stade_dev, id_user) VALUES (:haut_tronc, :haut_tot, :tronc_diam, :prec_estim, :clc_nbr_diag, :remarquable, :longitude, :latitude, :nom, :id_etat_arbre, :id_pied, :id_port, :id_stade_dev, :id_user) RETURNING *';
            $stmt = $db->prepare($request);
            $stmt->bindParam(':haut_tronc', $haut_tronc);
            $stmt->bindParam(':haut_tot', $haut_tot);
            $stmt->bindParam(':tronc_diam', $tronc_diam);
            $stmt->bindParam(':prec_estim', $prec_estim);
            $stmt->bindParam(':clc_nbr_diag', $clc_nbr_diag);
            $stmt->bindParam(':remarquable', $remarquable);
            $stmt->bindParam(':longitude', $longitude);
            $stmt->bindParam(':latitude', $latitude);
            $stmt->bindParam(':nom', $nom);
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

    static function listName() {
        try {
            $db = database::connectionDB();
            $request = 'SELECT t.nom FROM tree t GROUP BY t.nom;';
            $stmt = $db->prepare($request);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $exception) {
            error_log("[" . basename(__FILE__) . "][" . __LINE__ . "] " . 'Request error: ' . $exception->getMessage());
            return false;
        }
    }
}