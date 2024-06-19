from sklearn.cluster import KMeans
from sklearn import datasets, model_selection, metrics
import numpy as np
import pandas as pd
import plotly.express as px
from sklearn.metrics import davies_bouldin_score
from copy import deepcopy
from sklearn.cluster import Birch
import csv

print("Fin des import")

# Chemin vers fichier CSV
fichier_csv = 'Data_Arbre.csv'

data_complete = pd.read_csv(fichier_csv)

print("Fin du read de fichier")

# Sélection des colonnes spécifiques
colonnes_voulues = ['haut_tronc', 'tronc_diam', 'age_estim', 'fk_prec_estim']#'longitude', 'latitude',
data_selection = deepcopy(data_complete[colonnes_voulues])


#Methode (1 -> Kmeans, 2->Birch, 3->)
def Visualisation(methode, data_select, data_complete):
    var = ' '
    if methode == 1:
        var = 'Kmeans '
    elif methode == 2:
        var = 'Birch '
    else:
        print("Option non reconnu")
        return 0

    print("Test 1 :")

    data_selection_2c = deepcopy(data_select)
    data_selection_3c = deepcopy(data_select)

    print("Test 1 : validé")

    #Kmeans 2----------------------------------------------------------------------------------------------------

    print("Test 2 :")
    if methode == 1:
        print("KMeans method utilisé")
        # Création du modèle KMeans avec 2 clusters
        kmeans = KMeans(n_clusters=2, random_state=42)
        data_selection_2c['cluster'] = kmeans.fit_predict(data_selection_2c)
    elif methode == 2:
        print("Birch method utilisé")
        brc = Birch(n_clusters=2).fit(data_selection_2c)
        data_selection_2c['cluster'] = brc.predict(data_selection_2c)
    else:
        print("Option non reconnu")

    noms_clusters_2c = {
        0: 'cluster 1',
        1: 'cluster 2'
    }

    #On a deja transformer grace au clustering les donnée en 0 ou 1 si on a 2 clusters et la on
    # creer une nouvelle colone dans
    # notre data_selection qui en fonction du 0 ou 1  la transforme en grand ou petit
    data_selection_2c_b = deepcopy(data_selection_2c)
    data_selection_2c_b['noms_clusters_2c'] = data_selection_2c['cluster'].map(noms_clusters_2c)

    fig = px.scatter_3d(data_complete,
                        x='longitude',
                        y='latitude',
                        z='haut_tot',
                        color=data_selection_2c_b['noms_clusters_2c'])
    fig.update_traces(marker=dict(size=3))

    # Définition des plages d'axes pour figer les échelles
    fig.update_layout(scene=dict(
        xaxis=dict(range=[3.25, 3.31]),
        yaxis=dict(range=[49.82, 49.87]),
        zaxis=dict(range=[0, 40])
    ))
    # Show the plot
    fig.show()

    fig_2d = px.scatter_mapbox(data_complete, lon='longitude', lat='latitude',
                               color=data_selection_2c_b['noms_clusters_2c'],
                               title=f'Clustering en 2 clusters avec {var}',
                               labels={'longitude': 'Longitude', 'latitude': 'Latitude'},
                               hover_data=[data_selection_2c_b['cluster'], 'haut_tronc', 'tronc_diam', 'age_estim', 'fk_prec_estim', 'haut_tot'],
                               zoom=12)

    fig_2d.update_layout(mapbox_style="open-street-map")
    fig_2d.update_layout(margin={"r": 0, "t": 40, "l": 0, "b": 0})
    fig_2d.show()

    print("Test 2 : validé")

    #Kmeans 3--------------------------------------------------------------------------------------------------

    print("Test 3 :")

    if methode == 1:
        print("KMeans method utilisé")
        # Création du modèle KMeans avec 3 clusters
        kmeans = KMeans(n_clusters=3, random_state=42)
        data_selection_3c['cluster'] = kmeans.fit_predict(data_selection_3c)
    elif methode == 2:
        print("Birch method utilisé")
        brc = Birch(n_clusters=3).fit(data_selection_3c)
        data_selection_3c['cluster'] = brc.predict(data_selection_3c)
    else:
        print("Option non reconnu")

    noms_clusters_3c = {
        0: 'cluster 1',
        1: 'cluster 2',
        2: 'cluster 3'
    }

    #On a deja transformer grace au clustering les donnée en 0 ou 1 si on a 2 clusters et la on
    # creer une nouvelle colone dans
    # notre data_selection qui en fonction du 0 ou 1  la transforme en grand ou petit
    data_selection_3c_b = deepcopy(data_selection_3c)
    data_selection_3c_b['noms_clusters_3c'] = data_selection_3c['cluster'].map(noms_clusters_3c)

    fig = px.scatter_3d(data_complete,
                        x='longitude',
                        y='latitude',
                        z='haut_tot',
                        color=data_selection_3c_b['noms_clusters_3c'])
    fig.update_traces(marker=dict(size=3))

    # Définition des plages d'axes pour figer les échelles
    fig.update_layout(scene=dict(
        xaxis=dict(range=[3.25, 3.31]),
        yaxis=dict(range=[49.82, 49.87]),
        zaxis=dict(range=[0, 40])
    ))
    # Show the plot
    fig.show()

    fig_2d = px.scatter_mapbox(data_complete, lon='longitude', lat='latitude',
                               color=data_selection_3c_b['noms_clusters_3c'],
                               title=f'Clustering en 3 clusters avec {var}',
                               labels={'longitude': 'Longitude', 'latitude': 'Latitude'},
                               hover_data=[data_selection_3c_b['cluster'], 'haut_tronc', 'tronc_diam', 'age_estim', 'fk_prec_estim', 'haut_tot'],
                               zoom=12)

    fig_2d.update_layout(mapbox_style="open-street-map")
    fig_2d.update_layout(margin={"r": 0, "t": 40, "l": 0, "b": 0})
    fig_2d.show()

    print("Test 3 : validé")


def Courbe(n, data_select):
    #Silouette-----------------------------------------------------------------------------------------------

    print("Test 4 :")
    tab = []
    score_1 = []

    for i in range(n):
        kmeans = KMeans(n_clusters=i + 2, random_state=42)
        labels = kmeans.fit_predict(data_select)
        sil_score = metrics.silhouette_score(data_select, labels, metric='euclidean')
        score_1.append(sil_score)
        tab.append(i + 2)
        print(i + 2, "/", end=' ')
    print()

    # Créer un DataFrame à partir des listes tab et score
    data_score = pd.DataFrame({'tab': tab, 'score_1': score_1})

    fig = px.line(data_score, x="tab", y="score_1", title='Score de Silhouette K:')
    fig.show()

    tab = []
    score_2 = []

    for i in range(n):
        brc = Birch(n_clusters=i + 2).fit(data_select)
        labels = brc.predict(data_select)
        sil_score = metrics.silhouette_score(data_select, labels, metric='euclidean')
        score_2.append(sil_score)
        tab.append(i + 2)
        print(i + 2, "/", end=' ')
    print()

    # Créer un DataFrame à partir des listes tab et score
    data_score = pd.DataFrame({'tab': tab, 'score_2': score_2})

    fig = px.line(data_score, x="tab", y="score_2", title='Score de Silhouette B:')
    fig.show()
    print("Test 4 : validé")

    #Calinski-----------------------------------------------------------------------------------------------------

    print("Test 5 :")
    tab = []
    score_3 = []

    for i in range(n):
        kmeans = KMeans(n_clusters=i + 2, random_state=42).fit(data_select)
        labels = kmeans.fit_predict(data_select)
        calinski_harabasz_score = metrics.calinski_harabasz_score(data_select, labels)
        score_3.append(calinski_harabasz_score)
        tab.append(i + 2)
        print(".", end=' ')
    print()

    # Créer un DataFrame à partir des listes tab et score
    data_score = pd.DataFrame({'tab': tab, 'score_3': score_3})

    fig = px.line(data_score, x="tab", y="score_3", title='Score de Calinski Harabasz K:')
    fig.show()

    tab = []
    score_4 = []
    for i in range(n):
        brc = Birch(n_clusters=i + 2).fit(data_select)
        labels = brc.predict(data_select)
        calinski_harabasz_score = metrics.calinski_harabasz_score(data_select, labels)
        score_4.append(calinski_harabasz_score)
        tab.append(i + 2)
        print(".", end=' ')
    print()

    # Créer un DataFrame à partir des listes tab et score
    data_score = pd.DataFrame({'tab': tab, 'score_4': score_4})

    fig = px.line(data_score, x="tab", y="score_4", title='Score de Calinski Harabasz B:')
    fig.show()

    print("Test 5 : validé")

    #Davies bouldin-------------------------------------------------------------------------------------------
    print("Test 6 :")
    tab = []
    score_5 = []

    for i in range(n):
        kmeans = KMeans(n_clusters=i + 2, random_state=42).fit(data_select)
        labels = kmeans.fit_predict(data_select)
        db_score = davies_bouldin_score(data_select, labels)
        score_5.append(db_score)
        tab.append(i + 2)
        print(".", end=' ')
    print()

    # Créer un DataFrame à partir des listes tab et score
    data_score = pd.DataFrame({'tab': tab, 'score_5': score_5})

    fig = px.line(data_score, x="tab", y="score_5", title='Score de Davies Bouldin K:')
    fig.show()

    tab = []
    score_6 = []

    for i in range(n):
        brc = Birch(n_clusters=i+2).fit(data_select)
        labels = brc.predict(data_select)
        db_score = davies_bouldin_score(data_select, labels)
        score_6.append(db_score)
        tab.append(i + 2)
        print(".", end=' ')
    print()

    # Créer un DataFrame à partir des listes tab et score
    data_score = pd.DataFrame({'tab': tab, 'score_6': score_6})

    fig = px.line(data_score, x="tab", y="score_6", title='Score de Davies Bouldin B:')
    fig.show()
    print("Test 6 : validé")
    #Comparaisons-----------------------------------------------------------------------------------------------------

    print("Test 7 :")

    data_comp = pd.DataFrame({
        'tab': tab,
        'Silhouette kmeans': score_1,
        'Silhouette birch': score_2,
        'Calinski Harabasz kmeans': score_3,
        'Calinski Harabasz birch': score_4,
        'Davies Bouldin kmeans': score_5,
        'Davies Bouldin birch': score_6
    })

    fig = px.line(data_comp, x="tab", y=["Silhouette kmeans", "Silhouette birch", "Calinski Harabasz kmeans",
                                         'Calinski Harabasz birch', 'Davies Bouldin kmeans', 'Davies Bouldin birch'],
                  title='Comparaison des scores')
    fig.show()
    print("Test 7 : validé")

def Centroide_and_cluster(methode, nb_clusters, data_select):
    data_use = deepcopy(data_select)
    var = ' '
    if methode == 1:
        var = 'Kmeans'
        print("KMeans method utilisé")

        # Chemin du fichier CSV
        file_path = var + '_' + str(nb_clusters) + '.csv'

        # Création du modèle KMeans avec nb_clusters clusters
        kmeans = KMeans(n_clusters=nb_clusters, random_state=42)
        data_use['cluster'] = kmeans.fit_predict(data_use)
        # Pour récupérer les centroïdes
        centroids = kmeans.cluster_centers_

        centroids_data = pd.DataFrame(centroids, columns=['Centroide_haut_tronc', 'Centroide_tronc_diam', 'Centroide_age_estim', 'Centroide_fk_prec_estim'])#'Centroide_long', 'Centroide_lat',

        # Écriture des données dans le fichier CSV
        centroids_data.to_csv(file_path, index=False)

        print(f"Fichier CSV créé à {file_path}")

    elif methode == 2:
        var = 'Birch'
        print("Birch method utilisé")

        # Chemin du fichier CSV
        file_path = var + '_' + str(nb_clusters) + '.csv'

        # Création du modèle KMeans avec nb_clusters clusters
        brc = Birch(n_clusters=nb_clusters).fit(data_use)
        data_use['cluster'] = brc.predict(data_use)
        # Pour récupérer les centroïdes
        centroids = brc.subcluster_centers_[np.unique(brc.labels_)]

        centroids_data = pd.DataFrame(centroids, columns=['Centroide_haut_tronc', 'Centroide_tronc_diam', 'Centroide_age_estim', 'Centroide_fk_prec_estim'])#'Centroide_long', 'Centroide_lat',

        # Écriture des données dans le fichier CSV
        centroids_data.to_csv(file_path, index=False)

        print(f"Fichier CSV créé à {file_path}")

    else:
        print("Methode non reconnu")
        return 0



#Visualisation(2, data_selection, data_complete)
#Visualisation(1, data_selection, data_complete)

Courbe(19, data_selection)

#Centroide_and_cluster(1, 2, data_selection)
#Centroide_and_cluster(1, 3, data_selection)
#Centroide_and_cluster(2, 2, data_selection)
#Centroide_and_cluster(2, 3, data_selection)
