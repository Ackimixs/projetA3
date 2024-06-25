------------------------------------------------------------
--        Script Postgre
------------------------------------------------------------

DROP table if exists public.User cascade;
DROP table if exists public.pied cascade;
DROP table if exists public.etat_arbre cascade;
DROP table if exists public.port cascade;
DROP table if exists public.stade_dev cascade;
DROP table if exists public.Tree cascade;

------------------------------------------------------------
-- Table: User
------------------------------------------------------------
CREATE TABLE public.User(
                            id         SERIAL NOT NULL ,
                            password   VARCHAR (255) NOT NULL ,
                            username   VARCHAR (50) NOT NULL  ,
                            CONSTRAINT User_PK PRIMARY KEY (id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: pied
------------------------------------------------------------
CREATE TABLE public.pied(
                            id      SERIAL NOT NULL ,
                            value   VARCHAR (50) NOT NULL  ,
                            CONSTRAINT pied_PK PRIMARY KEY (id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: etat_arbre
------------------------------------------------------------
CREATE TABLE public.etat_arbre(
                                  id      SERIAL NOT NULL ,
                                  value   VARCHAR (50) NOT NULL  ,
                                  CONSTRAINT etat_arbre_PK PRIMARY KEY (id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: port
------------------------------------------------------------
CREATE TABLE public.port(
                            id      SERIAL NOT NULL ,
                            value   VARCHAR (50) NOT NULL  ,
                            CONSTRAINT port_PK PRIMARY KEY (id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: stade_dev
------------------------------------------------------------
CREATE TABLE public.stade_dev(
                                 id      SERIAL NOT NULL ,
                                 value   VARCHAR (50) NOT NULL  ,
                                 CONSTRAINT stade_dev_PK PRIMARY KEY (id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: Tree
------------------------------------------------------------
CREATE TABLE public.Tree(
                            id                    SERIAL NOT NULL ,
                            haut_tronc            INT  NOT NULL ,
                            haut_tot              INT  NOT NULL ,
                            tronc_diam            INT  NOT NULL ,
                            prec_estim            INT  NOT NULL ,
                            clc_nbr_diag          INT  NOT NULL ,
                            age_estim             INT  ,
                            remarquable           BOOL  NOT NULL ,
                            longitude             FLOAT8  NOT NULL ,
                            latitude              FLOAT8  NOT NULL ,
                            risque_deracinement   BOOL   ,
                            nom                   VARCHAR (255) NOT NULL ,
                            id_etat_arbre         INT  NOT NULL ,
                            id_pied               INT  NOT NULL ,
                            id_port               INT  NOT NULL ,
                            id_stade_dev          INT  NOT NULL ,
                            id_User               INT    ,
                            CONSTRAINT Tree_PK PRIMARY KEY (id)

    ,CONSTRAINT Tree_etat_arbre_FK FOREIGN KEY (id_etat_arbre) REFERENCES public.etat_arbre(id)
    ,CONSTRAINT Tree_pied0_FK FOREIGN KEY (id_pied) REFERENCES public.pied(id)
    ,CONSTRAINT Tree_port1_FK FOREIGN KEY (id_port) REFERENCES public.port(id)
    ,CONSTRAINT Tree_stade_dev2_FK FOREIGN KEY (id_stade_dev) REFERENCES public.stade_dev(id)
    ,CONSTRAINT Tree_User3_FK FOREIGN KEY (id_User) REFERENCES public.User(id)
)WITHOUT OIDS;
