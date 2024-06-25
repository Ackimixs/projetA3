INSERT INTO etat_arbre (value) VALUES
('abattu'),
('en place'),
('essouché'),
('non essouché'),
('supprimé'),
('remplacé');

INSERT INTO pied (value) VALUES
('bac de plantation'),
('terre'),
('fosse arbre'),
('gazon'),
('revetement non permeable');

INSERT INTO port (value) VALUES
('couronne'),
('libre'),
('semi libre'),
('architecturé'),
('cépée'),
('rideau'),
('réduit'),
('réduit relâché'),
('têtard'),
('têtard relâché'),
('tête de chat'),
('tête de chat relaché'),
('étêté');

INSERT INTO stade_dev (value) VALUES
('adulte'),
('jeune'),
('senescent'),
('vieux');

INSERT INTO tree (haut_tronc, haut_tot, tronc_diam, prec_estim, clc_nbr_diag, age_estim, remarquable, longitude, latitude, nom, id_etat_arbre, id_pied, id_port, id_stade_dev) VALUES
(2, 4, 20, 0, 0, 5, FALSE, 3.299956459148723, 49.86422808474744, 'acki', 2, 4, 3, 2)
