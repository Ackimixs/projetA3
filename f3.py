import pandas as pd
from CLParser import CLParser
import sys
import time

from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier

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

for mod in [SGDClassifier, RandomForestClassifier, MLPClassifier, KNeighborsClassifier, SVC, DecisionTreeClassifier]:
    print("Using", mod.__name__)
    start = time.time()
    clf = mod().fit(X_train, Y_train)
    end = time.time()
    print("score on train : ", clf.score(X_train, Y_train))
    print("score on test : ", clf.score(X_test, Y_test))
    print("Time execution to train the model: ", end - start, "s")

    res = cross_val_score(clf, X_train, Y_train, scoring="accuracy", cv=5)
    print("cross_val_score : ", res.mean())
    print()
