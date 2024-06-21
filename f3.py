import pandas as pd
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report, roc_curve, auc
from sklearn.preprocessing import label_binarize
from CLParser import CLParser
import sys
import time
import pickle
import json
import numpy as np

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
from sklearn.metrics import f1_score, recall_score


def parse_string_data(data):
    for col in data.columns:
        if data[col].dtype == "object":
            data_to = data[[col]]  # Create a DataFrame with a single column
            encoder = OrdinalEncoder()
            data.loc[:, col] = encoder.fit_transform(data_to)  # Use .loc to modify original DataFrame
            pickle.dump(encoder, open("encoders/" + col + "_encoder.pkl", 'wb'))
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

# Binarize the output labels for multiclass ROC curve
Y_train_bin = label_binarize(Y_train, classes=np.unique(Y))
Y_test_bin = label_binarize(Y_test, classes=np.unique(Y))

if parser.has_option("no_model"):
    sys.exit()

param_grid = {
    'SGDClassifier': {
        'loss': ['hinge', 'log_loss'],
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

    model_param = {}

    if hasattr(model().get_params(), "max_iter"):
        model_param["max_iter"] = 3000
    if hasattr(model().get_params(), "random_state"):
        model_param["random_state"] = 42

    clf = model(**model_param)

    start = time.time()
    clf = clf.fit(X_train, Y_train)
    end = time.time()
    train_score = clf.score(X_train, Y_train)
    test_score = clf.score(X_test, Y_test)

    # Cross-validation
    res = cross_val_score(clf, X_train, Y_train, scoring="accuracy", cv=5)

    # Other score
    f1 = f1_score(Y_test, clf.predict(X_test), average="weighted")
    recall = recall_score(Y_test, clf.predict(X_test), average="weighted")

    print("    score on training set: ", train_score)
    print("    score on test set: ", test_score)
    print("    Cross-Validation Score: ", res.mean())
    print("    F1 score: ", f1)
    print("    Recall score: ", recall)
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
                    "f1": f1,
                    "recall": recall,
                    "time": end - start,
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

    # Calculer et afficher la courbe ROC
    if parser.has_option("roc_curve"):
        plt.figure()
        for i in range(Y_test_bin.shape[1]):
            if hasattr(clf, "decision_function"):
                y_score = clf.decision_function(X_test)[:, i]
            else:
                y_score = clf.predict_proba(X_test)[:, i]

            fpr, tpr, _ = roc_curve(Y_test_bin[:, i], y_score)
            roc_auc = auc(fpr, tpr)

            plt.plot(fpr, tpr, lw=2, label=f'ROC curve of class {i} (area = {roc_auc:0.2f})')

        plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
        plt.xlim([0.0, 1.0])
        plt.ylim([0.0, 1.05])
        plt.xlabel('False Positive Rate')
        plt.ylabel('True Positive Rate')
        plt.title(f'Receiver Operating Characteristic for {model.__name__}')
        plt.legend(loc="lower right")
        plt.show()

    if parser.has_option("grid_search"):
        print("    GridSearchCV : " + model.__name__)

        start = time.time()
        grid_search = GridSearchCV(estimator=clf, param_grid=param_grid[model.__name__], cv=5, scoring="accuracy")
        grid_search.fit(X_train, Y_train)
        end = time.time()

        # Print the best parameters and best score
        best_model = grid_search.best_estimator_
        train_score = best_model.score(X_train, Y_train)
        test_score = best_model.score(X_test, Y_test)

        # Other score
        f1 = f1_score(Y_test, best_model.predict(X_test), average="weighted")
        recall = recall_score(Y_test, best_model.predict(X_test), average="weighted")

        print("        Best Parameters: ", grid_search.best_params_)
        print("        Best score on training set: ", train_score)
        print("        Best score on test set: ", test_score)
        print("        Best Cross-Validation Score: ", grid_search.best_score_)
        print("        F1 score: ", f1)
        print("        Recall score: ", recall)
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
                        "f1": f1,
                        "recall": recall,
                        "time": end - start,
                    },
                    "best_params": grid_search.best_params_,
                    "params": best_model.get_params()
                }
                json.dump(to_write, file, ensure_ascii=False, indent=4)

        # Calculer et afficher la courbe ROC pour le meilleur modèle
        if parser.has_option("roc_curve"):
            plt.figure()
            for i in range(Y_test_bin.shape[1]):
                if hasattr(best_model, "decision_function"):
                    y_score = best_model.decision_function(X_test)[:, i]
                else:
                    y_score = best_model.predict_proba(X_test)[:, i]

                fpr, tpr, _ = roc_curve(Y_test_bin[:, i], y_score)
                roc_auc = auc(fpr, tpr)

                plt.plot(fpr, tpr, lw=2, label=f'ROC curve of class {i} (area = {roc_auc:0.2f})')

            plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
            plt.xlim([0.0, 1.0])
            plt.ylim([0.0, 1.05])
            plt.xlabel('False Positive Rate')
            plt.ylabel('True Positive Rate')
            plt.title(f'Receiver Operating Characteristic for {model.__name__} grid search')
            plt.legend(loc="lower right")
            plt.show()