import pandas as pd
from CLParser import CLParser
import sys
from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split

parser = CLParser(sys.argv)
file = parser.get_option("file", ["Data_Arbre.csv"])[0]

X_to_keep = parser.get_option("X", ["haut_tronc", "haut_tot", "tronc_diam"])
Y_to_keep = parser.get_one_option("Y", "age_estim")

# print(file, X_to_keep, Y_to_keep)

data = pd.read_csv(file)

X = data[X_to_keep]
Y = data[Y_to_keep]


# print(X.shape, Y.shape)

def parse_value(x):
    if x < 90:
        return int(x / 10)
    return 9


Y = Y.apply(parse_value)

# print(Y.head())

# print(Y.value_counts())

X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)

# print(X_train.shape, X_test.shape, Y_train.shape, Y_test.shape)

sgd_clf = SGDClassifier().fit(X_train, Y_train)

res = cross_val_score(sgd_clf, X_train, Y_train, scoring="accuracy", cv=3)

# print(res)
print(res.mean())

rdf = RandomForestClassifier().fit(X_train, Y_train)

res = cross_val_score(rdf, X_train, Y_train, scoring="accuracy", cv=3)

# print(res)
print(res.mean())

neural = MLPClassifier().fit(X_train, Y_train)

res = cross_val_score(neural, X_train, Y_train, scoring="accuracy", cv=3)

# print(res)
print(res.mean())
