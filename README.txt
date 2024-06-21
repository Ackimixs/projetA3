Projet IA A3

Groupe 13 : Esteban Fanjul, Mathis Meunier, Killian Guichet

Comment l'utilisé

3 fichiers pour les differentes fonctionnalité,
f1 -> clustering en taille d'arbres
f2 -> classification en classe d'age
f3 -> classification binaire pour l'état de l'arbre
load modele -> permet de charger les modèle entrainné avec les fichier du dessus.

Utilisation des fichiers

f1 (f1.py) :
options :
- method : methode de clustering utilisé (Kmeans ou Birch) (default : Kmeans)
- nb_clusters : nombre de cluster a utilisé (2 ou 3) (default : 3)
- visual : visualisation des clusters sur des cartes (default : false)
- curve : courbe des methode pour visualiser leur performance (default : false)
- nb_clusters_to_test : nombre de cluster a testé pour la courbe (default : 10)

f2 (f2.py) :

options :
- file : lien vers le fichier de donnée (default : Data_Arbre.csv)
- models : modele a utilisé (SGDClassifier RandomForestClassifier MLPClassifier KNeighborsClassifier SVC DecisionTreeClassifier)  (default : SGDClassifier, RandomForestClassifier, MLPClassifier)
- X : features à utilisé (default : haut_tronc haut_tot tronc_diam)
- Y : class a utilisé (default : age_estim)
- no_model : lancé le programme sans run les modèle pour du debug (default : false)
- confusion_matrix : visualisation des matrices de confusion (default : false)
- roc_curve : visualisation des courbes ROC (default : false)
- grid_search : utilisation de grid search pour les differents modèles (default : false)

example de script :
python3 f2.py --X haut_tronc haut_tot tronc_diam fk_prec_estim clc_nbr_diag fk_situation --save_model --models SGDClassifier --roc_curve

f3 (f3.py) :

options :
- file : lien vers le fichier de donnée (default : Data_Arbre.csv)
- models : modele a utilisé (SGDClassifier RandomForestClassifier MLPClassifier KNeighborsClassifier SVC DecisionTreeClassifier)  (default : SGDClassifier, RandomForestClassifier, MLPClassifier)
- X : features à utilisé (default : haut_tronc tronc_diam haut_tot age_estim)
- Y : class a utilisé (default : fk_arb_etat)
- no_model : lancé le programme sans run les modèle pour du debug (default : false)
- confusion_matrix : visualisation des matrices de confusion (default : false)
- roc_curve : visualisation des courbes ROC (default : false)
- grid_search : utilisation de grid search pour les differents modèles (default : false)

example de script :
python3 f3.py --X haut_tronc haut_tot tronc_diam fk_revetement feuillage age_estim --save_model --models MLPClassifier --grid_search --roc_curve

load modele (load_modele.py) :

options :
- f1 : utilisation des clusters du script 1 / prediction du cluster d'appartenance de l'arbre
- f2 : utilisation des modèles du script 2 / prédiction sur l'age de l'arbre
- f3 : utilisation des modèles du script 3 / prédiction sur l'état de l'arbre
- input_json : ficher d'input avec les donnée de l'arbres servant à la prédiction
- output_json : fichier d'output avec la prédication sur l'arbre

si f1 est utilisé :
- algo : algorithme de clustering a utilisé (Kmeans ou Birch) (default : Kmeans)
- nb_clusters : nombre de cluster a utilisé (2 ou 3) (default : 3)

si f2 ou f3 utilisé :
- model : modèle a utilisé pour la prédiction (default : MLPClassifier)
- grid_search : utilisation des optimization des modèle avec grid search

example de script :
python3 load_models.py --model DecisionTreeClassifier --f2 --input_json to_predict_f2.json
