import pandas as pd
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report
from CLParser import CLParser
import sys
import time

from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier

from sklearn.model_selection import GridSearchCV

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split


parser = CLParser(sys.argv)
file = parser.get_one_option("file", "Data_Arbre.csv")

X_to_keep = parser.get_option("X", ["haut_tronc"])
Y_to_keep = parser.get_one_option("Y", "fk_arb_etat")


def parse_arb_etat(x):
    if x == "Essouché" or x == "Non essouché":
        return 1
    return 0


print(file, X_to_keep, Y_to_keep)

data = pd.read_csv(file)

X = data[X_to_keep]
Y = data[Y_to_keep]

Y = Y.apply(parse_arb_etat)

X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)

# param_grid =[
#     {"n_estimators": [10, 100, 1000], "max_features": ["auto", "sqrt", "log2"]}
# ]

param_grid = [
    {'n_estimators': [3, 10, 30], 'max_features': [2, 4, 6, 8]}
]

# for mod in [SGDClassifier, RandomForestClassifier, MLPClassifier, KNeighborsClassifier, SVC, DecisionTreeClassifier]:
for mod in [SGDClassifier, RandomForestClassifier, MLPClassifier]:
    print("Using", mod.__name__)
    start = time.time()
    clf = mod().fit(X_train, Y_train)
    end = time.time()
    print("    score on train : ", clf.score(X_train, Y_train))
    print("    score on test : ", clf.score(X_test, Y_test))
    print("    Time execution to train the model: ", end - start, "s")


    # Calculer et afficher la matrice de confusion
    # Y_pred = clf.predict(X_test)
    # conf_matrix = confusion_matrix(Y_test, Y_pred)
    # disp = ConfusionMatrixDisplay(confusion_matrix=conf_matrix, display_labels=clf.classes_)
    # disp.plot()
    # plt.show()
    #
    # print(classification_report(Y_test, Y_pred))

    # Cross-validation
    res = cross_val_score(clf, X_train, Y_train, scoring="accuracy", cv=5)
    print("    cross_val_score : ", res.mean())
    print()

    if mod.__name__ == "RandomForestClassifier":
        print("    GridSearchCV")
        gscv = GridSearchCV(mod(), param_grid=param_grid, cv=5, scoring="accuracy")
        gscv.fit(X_train, Y_train)
        print("    Best parameters: ", gscv.best_params_)
        print()
