import asyncio
import asyncpg
from pandas import read_csv

async def main():
    csv_data = read_csv('Data_Arbre.csv', encoding='utf-8')

    try:
        # Establishing a connection
        conn = await asyncpg.connect(
            database="tree",
            user="tree",
            password="tree",
            host="127.0.0.1",
            port=5432
        )

        # Iterate through each row in the CSV data
        for i, row in csv_data.iterrows():
            print(row)

            # Executing the insert statement
            await conn.execute("""
                INSERT INTO tree (haut_tronc, haut_tot, tronc_diam, prec_estim, clc_nbr_diag, age_estim, remarquable, 
                                  longitude, latitude, id_etat_arbre, id_pied, id_port, id_stade_dev, nom) 
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 
                        (SELECT id FROM etat_arbre WHERE value = $10), 
                        (SELECT id FROM pied WHERE value = $11), 
                        (SELECT id FROM port WHERE value = $12), 
                        (SELECT id FROM stade_dev WHERE value = $13), $14)
                """,
                int(row['haut_tronc']), int(row['haut_tot']), int(row['tronc_diam']), int(row['fk_prec_estim']), int(row['clc_nbr_diag']),
                int(row['age_estim']), True if row['remarquable'].lower() == "oui" else False, float(row['longitude']), float(row['latitude']),
                row['fk_arb_etat'].lower(), row['fk_pied'].lower(), row['fk_port'].lower(), row['fk_stadedev'].lower(),
                row['fk_nomtech'].lower()
            )

        await conn.close()

    except Exception as e:
        print(e)

# Run the asyncio event loop with the main coroutine
if __name__ == '__main__':
    asyncio.run(main())
