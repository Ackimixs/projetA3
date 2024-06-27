SELECT t.id, t.haut_tronc, t.haut_tot, t.tronc_diam, t.prec_estim, t.clc_nbr_diag, t.age_estim, t.remarquable, t.longitude, t.latitude, t.risque_deracinement, t.nom, ea.value as etat_arbre, p.value as pied, p2.value as port, sd.value as stade_dev, u.username FROM tree t
    LEFT JOIN public.etat_arbre ea on ea.id = t.id_etat_arbre
    LEFT JOIN public.pied p on p.id = t.id_pied
    LEFT JOIN public.port p2 on p2.id = t.id_port
    LEFT JOIN public.stade_dev sd on sd.id = t.id_stade_dev
    LEFT JOIN public."user" u on u.id = t.id_user
ORDER BY t.id
LIMIT :limit OFFSET :offset;
