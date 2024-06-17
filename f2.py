import pandas as pd
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report
from CLParser import CLParser
import sys
import time
import pickle

from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier

from sklearn.model_selection import GridSearchCV

from sklearn.preprocessing import OrdinalEncoder
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split


def parse_string_data(data):
    for col in data.columns:
        if data[col].dtype == "object":
            data_to = data[[col]]  # Create a DataFrame with a single column
            encoder = OrdinalEncoder()
            data.loc[:, col] = encoder.fit_transform(data_to)  # Use .loc to modify original DataFrame
    return data


def parse_value(x):
    if x < 90:
        return int(x / 10)
    return 9


parser = CLParser(sys.argv)
file = parser.get_one_option("file", "Data_Arbre.csv")
models = parser.get_option("models", ["SGDClassifier", "RandomForestClassifier", "MLPClassifier"])

X_to_keep = parser.get_option("X", ["haut_tronc", "haut_tot", "tronc_diam"])
Y_to_keep = parser.get_one_option("Y", "age_estim")

print(file, X_to_keep, Y_to_keep)

data = pd.read_csv(file)

X = data[X_to_keep]
Y = data[Y_to_keep]

Y = Y.apply(parse_value)

X = parse_string_data(X)

X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)

if parser.has_option("no_model"):
    sys.exit()

# for mod in [SGDClassifier, RandomForestClassifier, MLPClassifier, KNeighborsClassifier, SVC, DecisionTreeClassifier]:
for model_name in models:
    model = eval(model_name)
    print("Using", model.__name__)
    if model.__name__ == "SGDClassifier":
        clf = model(max_iter=1000)
    elif model.__name__ == "MLPClassifier":
        clf = model(max_iter=1000)
    else:
        clf = model()
    start = time.time()
    clf = clf.fit(X_train, Y_train)
    end = time.time()
    print("score on train : ", clf.score(X_train, Y_train))
    print("score on test : ", clf.score(X_test, Y_test))

    if parser.has_option("save_model"):
        with open("models/f3_" + model.__name__ + ".pkl", 'wb') as file:
            pickle.dump(clf, file)

    # Calculer et afficher la matrice de confusion
    if parser.has_option("confusion_matrix"):
        Y_pred = clf.predict(X_test)
        conf_matrix = confusion_matrix(Y_test, Y_pred)
        disp = ConfusionMatrixDisplay(confusion_matrix=conf_matrix, display_labels=clf.classes_)
        disp.plot()
        plt.show()

        print(classification_report(Y_test, Y_pred))

    # Cross-validation
    res = cross_val_score(clf, X_train, Y_train, scoring="accuracy", cv=3)
    print("cross_val_score : ", res.mean())
    print("Time execution to train the model: ", end - start, "s")
    print()

    if parser.has_option("grid_search"):
        if model.__name__ == "RandomForestClassifier":
            param_grid = {
                'n_estimators': [3, 10, 30],
                'max_features': [2, 4, 6, 8],
                'max_depth': [None, 10, 20, 30]
            }
        elif model.__name__ == "SGDClassifier":
            param_grid = {
                'loss': ['hinge', 'log_loss'],
                'penalty': ['l2', 'l1'],
                'alpha': [0.0001, 0.001],
            }
        elif model.__name__ == "MLPClassifier":
            param_grid = {
                'hidden_layer_sizes': [(50,), (100,), (50, 50), (100, 100)],
                'activation': ['tanh', 'relu'],
                'alpha': [0.0001, 0.001],
            }
        else:
            param_grid = {}

        print("    GridSearchCV")
        if model.__name__ == "SGDClassifier":
            gs_model = model(max_iter=1000)
        elif model.__name__ == "MLPClassifier":
            gs_model = model(max_iter=1000)
        else:
            gs_model = model()
        grid_search = GridSearchCV(estimator=gs_model, param_grid=param_grid, cv=5, scoring="accuracy")
        grid_search.fit(X_train, Y_train)

        # Print the best parameters and best score
        best_model = grid_search.best_estimator_
        train_score = best_model.score(X_train, Y_train)
        test_score = best_model.score(X_test, Y_test)
        print("        Best Parameters: ", grid_search.best_params_)
        print("        Best score on training set: ", train_score)
        print("        Best score on test set: ", test_score)
        print("        Best Cross-Validation Score: ", grid_search.best_score_)
        print()

        if parser.has_option("save_model"):
            with open("models/f3_" + model.__name__ + "_grid_search.pkl", 'wb') as file:
                pickle.dump(clf, file)
