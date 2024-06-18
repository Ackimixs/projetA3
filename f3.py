import pandas as pd
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report, roc_curve, RocCurveDisplay, roc_auc_score
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


def parse_arb_etat(x):
    if x == "Essouché" or x == "Non essouché":
        return 1
    return 0


parser = CLParser(sys.argv)
file = parser.get_one_option("file", "Data_Arbre.csv")
models = parser.get_option("models", ["SGDClassifier", "RandomForestClassifier", "MLPClassifier"])

X_to_keep = parser.get_option("X", ["haut_tronc"])
Y_to_keep = parser.get_one_option("Y", "fk_arb_etat")

print(file, X_to_keep, Y_to_keep)

data = pd.read_csv(file)

X = data[X_to_keep]
Y = data[Y_to_keep]

Y = Y.apply(parse_arb_etat)

X = parse_string_data(X)

X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)

if parser.has_option("no_model"):
    sys.exit()

param_grid = {
    'SGDClassifier': {
        'loss': ['hinge', 'log'],
        'penalty': ['l2', 'l1'],
        'alpha': [0.0001, 0.001, 0.01],
        'max_iter': [2000, 3000],
        'tol': [1e-3, 1e-4]
    },
    'RandomForestClassifier': {
        'n_estimators': [50, 100],
        'max_depth': [None, 10, 20],
        'min_samples_split': [2, 5],
        'min_samples_leaf': [1, 2],
        'max_features': ['sqrt', 'log2']
    },
    'MLPClassifier': {
        'hidden_layer_sizes': [(50,), (100,)],
        'solver': ['adam', 'sgd'],
        'max_iter': [1000, 2000],
        'learning_rate': ['constant', 'adaptive']
    },
    'KNeighborsClassifier': {
        'n_neighbors': [5, 10],
        'weights': ['uniform', 'distance'],
        'algorithm': ['auto', 'ball_tree'],
        'p': [1, 2]
    },
    'SVC': {
        'C': [0.1, 1, 10],
        'kernel': ['linear', 'rbf'],
        'gamma': ['scale']
    },
    'DecisionTreeClassifier': {
        'criterion': ['gini', 'entropy'],
        'max_depth': [None, 10, 20],
        'min_samples_split': [2, 5],
        'min_samples_leaf': [1, 2],
        'max_features': ['sqrt', 'log2']
    }
}

# for mod in [SGDClassifier, RandomForestClassifier, MLPClassifier, KNeighborsClassifier, SVC, DecisionTreeClassifier]:
for model_name in models:
    model = eval(model_name)
    print("Using", model.__name__)

    if hasattr(model().get_params(), "max_iter"):
        clf = model(max_iter=1000)
    else:
        clf = model()

    start = time.time()
    clf = clf.fit(X_train, Y_train)
    end = time.time()
    train_score = clf.score(X_train, Y_train)
    test_score = clf.score(X_test, Y_test)

    # RMSE
    rmse_train = root_mean_squared_error(Y_train, clf.predict(X_train))
    rmse_test = root_mean_squared_error(Y_test, clf.predict(X_test))

    # Cross-validation
    res = cross_val_score(clf, X_train, Y_train, scoring="accuracy", cv=5)

    print("    score on training set: ", train_score)
    print("    score on test set: ", test_score)
    print("    Cross-Validation Score: ", res.mean())
    print("    RMSE on training set: ", rmse_train)
    print("    RMSE on test set: ", rmse_test)
    print("    Time execution to train the model: ", end - start, "s")
    print()

    if parser.has_option("save_model"):
        with open("models/f3_" + model.__name__ + ".pkl", 'wb') as file:
            pickle.dump(clf, file)
        with open("models/f3_" + model.__name__ + ".json", 'w', encoding='utf-8') as file:
            to_write = {
                "X": X_to_keep,
                "Y": Y_to_keep,
                "score": {
                    "train": clf.score(X_train, Y_train),
                    "test": clf.score(X_test, Y_test),
                    "cross_val": res.mean(),
                    "time": end - start,
                    "RMSE": {
                        "train": root_mean_squared_error(Y_train, clf.predict(X_train)),
                        "test": root_mean_squared_error(Y_test, clf.predict(X_test)),
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

        if hasattr(model().get_params(), "max_iter"):
            gs_model = model(max_iter=1000)
        else:
            gs_model = model()

        start = time.time()
        grid_search = GridSearchCV(estimator=gs_model, param_grid=param_grid[model.__name__], cv=5, scoring="accuracy")
        grid_search.fit(X_train, Y_train)
        end = time.time()

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
        print("        Time execution to train the model: ", end - start, "s")
        print()

        if parser.has_option("save_model"):
            with open("models/f3_" + model.__name__ + "_grid_search.pkl", 'wb') as file:
                pickle.dump(best_model, file)
            with open("models/f3_" + model.__name__ + "_grid_search.json", 'w', encoding='utf-8') as file:
                to_write = {
                    "X": X_to_keep,
                    "Y": Y_to_keep,
                    "score": {
                        "train": train_score,
                        "test": test_score,
                        "cross_val": grid_search.best_score_,
                        "time": end - start,
                        "RMSE": {
                            "train": rmse_train,
                            "test": rmse_test,
                        }
                    },
                    "best_params": grid_search.best_params_,
                    "params": best_model.get_params()
                }
                json.dump(to_write, file, ensure_ascii=False, indent=4)
