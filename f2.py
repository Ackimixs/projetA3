import pandas as pd
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report
from CLParser import CLParser
import sys
import time
import pickle
import json

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
from sklearn.metrics import root_mean_squared_error


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

param_grid = {
    'SGDClassifier': {
        'loss': ['hinge', 'log_loss'],
        'alpha': [0.0001, 0.001, 0.01],
        'max_iter': [1000, 2000, 3000],
    },
    'RandomForestClassifier': {
        'n_estimators': [50, 100, 200],
        'max_depth': [None, 10, 20, 30],
        'max_features': ['sqrt', 'log2'],
    },
    'MLPClassifier': {
        'hidden_layer_sizes': [(50,), (100,), (50, 50), (100, 50)],
        'max_iter': [1000, 2000],
        'solver': ['adam', 'sgd'],
    },
    'KNeighborsClassifier': {
        'n_neighbors': [5, 10, 15],
        'weights': ['uniform', 'distance'],
        'algorithm': ['auto', 'ball_tree', 'kd_tree'],
        'p': [1, 2],
    },
    'SVC': {
        'kernel': ['linear', 'poly', 'rbf', 'sigmoid'],
        'C': [0.1, 1, 10],
        'gamma': ['scale', 'auto'],
        'degree': [2, 3, 4],
    },
    'DecisionTreeClassifier': {
        'criterion': ['gini', 'entropy'],
        'splitter': ['best', 'random'],
        'max_depth': [None, 10, 20, 30],
        'max_features': ['sqrt', 'log2'],
    }
}

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
    print("    score on train : ", clf.score(X_train, Y_train))
    print("    score on test : ", clf.score(X_test, Y_test))

    # RMSE
    rmse_train = root_mean_squared_error(Y_train, clf.predict(X_train))
    rmse_test = root_mean_squared_error(Y_test, clf.predict(X_test))
    print("    RMSE on train : ", rmse_train)
    print("    RMSE on test : ", rmse_test)

    # Cross-validation
    res = cross_val_score(clf, X_train, Y_train, scoring="accuracy", cv=3)
    print("    cross_val_score : ", res.mean())
    print("    Time execution to train the model: ", end - start, "s")
    print()

    if parser.has_option("save_model"):
        with open("models/f2_" + model.__name__ + ".pkl", 'wb') as file:
            pickle.dump(clf, file)
        with open("models/f2_" + model.__name__ + ".json", 'w', encoding='utf-8') as file:
            to_write = {
                "X": X_to_keep,
                "Y": Y_to_keep,
                "score": {
                    "train": clf.score(X_train, Y_train),
                    "test": clf.score(X_test, Y_test),
                    "cross_val": res.mean(),
                    "time": end - start,
                    "RMSE": {
                        "train": rmse_train,
                        "test": rmse_test,
                    }
                },
                "params": clf.get_params()
            }
            json.dump(to_write, file, ensure_ascii=False, indent=4)

    # Calculer et afficher la matrice de confusion
    if parser.has_option("confusion_matrix"):
        Y_pred = clf.predict(X_test)
        conf_matrix = confusion_matrix(Y_test, Y_pred)
        disp = ConfusionMatrixDisplay(confusion_matrix=conf_matrix, display_labels=clf.classes_)
        disp.plot()
        plt.show()

        print(classification_report(Y_test, Y_pred))

    if parser.has_option("grid_search"):
        print("    GridSearchCV : " + model.__name__)
        if model.__name__ == "SGDClassifier":
            gs_model = model(max_iter=1000)
        elif model.__name__ == "MLPClassifier":
            gs_model = model(max_iter=1000)
        else:
            gs_model = model()
        grid_search = GridSearchCV(estimator=gs_model, param_grid=param_grid[model.__name__], cv=5, scoring="accuracy")
        grid_search.fit(X_train, Y_train)

        # Print the best parameters and best score
        best_model = grid_search.best_estimator_
        train_score = best_model.score(X_train, Y_train)
        test_score = best_model.score(X_test, Y_test)
        rmse_train = root_mean_squared_error(Y_train, best_model.predict(X_train))
        rmse_test = root_mean_squared_error(Y_test, best_model.predict(X_test))
        print("        Best Parameters: ", grid_search.best_params_)
        print("        Best score on training set: ", train_score)
        print("        Best score on test set: ", test_score)
        print("        Best Cross-Validation Score: ", grid_search.best_score_)
        print("        RMSE on training set: ", rmse_train)
        print("        RMSE on test set: ", rmse_test)

        if parser.has_option("save_model"):
            with open("models/f2_" + model.__name__ + "_grid_search.pkl", 'wb') as file:
                pickle.dump(best_model, file)
            with open("models/f2_" + model.__name__ + "_grid_search.json", 'w', encoding='utf-8') as file:
                to_write = {
                    "X": X_to_keep,
                    "Y": Y_to_keep,
                    "score": {
                        "train": train_score,
                        "test": test_score,
                        "cross_val": grid_search.best_score_,
                        "RMSE": {
                            "train": rmse_train,
                            "test": rmse_test,
                        }
                    },
                    "best_params": grid_search.best_params_,
                    "params": best_model.get_params()
                }
                json.dump(to_write, file, ensure_ascii=False, indent=4)
