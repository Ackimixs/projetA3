import psycopg2

from pandas import read_csv

csv_data = read_csv('Data_Arbre.csv')

try:
    connection = psycopg2.connect(user="tree",
                                  password="tree",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="tree")

    cursor = connection.cursor()

    for i, row in csv_data.iterrows():

        cursor.execute("INSERT INTO tree (haut_tronc, haut_tot, tronc_diam, prec_estim, clc_nbr_diag, age_estim, "
                       "remarquable, longitude, latitude, id_etat_arbre, id_pied, id_port, id_stade_dev, nom) VALUES ("
                       "%s, %s, %s, %s, %s, %s, %s, %s, %s, (SELECT id FROM etat_arbre WHERE value = %s), (SELECT id FROM pied WHERE value = %s), (SELECT id FROM port WHERE value = %s), (SELECT id FROM stade_dev WHERE value = %s), %s)",
                       (row['haut_tronc'], row['haut_tot'], row['tronc_diam'], row['fk_prec_estim'], row['clc_nbr_diag'], row['age_estim'], '1' if row['remarquable'].lower() == "oui" else '0', row['longitude'], row['latitude'], row['fk_arb_etat'].lower(), row['fk_pied'].lower(), row['fk_port'].lower(), row['fk_stadedev'].lower(), row['fk_nomtech'].lower()))

        connection.commit()

    cursor.close()

    connection.close()
except (Exception, psycopg2.Error) as error:
    print(error)
