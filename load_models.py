import pandas as pd
from CLParser import CLParser
import sys

from sklearn.preprocessing import OrdinalEncoder
from sklearn.model_selection import train_test_split
import pickle


def parse_string_data(data):
    for col in data.columns:
        if data[col].dtype == "object":
            data_to = data[[col]]  # Create a DataFrame with a single column
            encoder = OrdinalEncoder()
            data.loc[:, col] = encoder.fit_transform(data_to)  # Use .loc to modify original DataFrame
    return data


def load_models(filename):
    with open(filename, 'rb') as file:
        return pickle.load(file)


def main():
    parser = CLParser(sys.argv)
    print(parser.get_one_option("model_file", "models.pkl"))
    model = load_models(parser.get_one_option("model_file", "model.pkl"))
    print(model)

    file = parser.get_one_option("file", "Data_Arbre.csv")

    X_to_keep = parser.get_option("X", ["haut_tronc", "haut_tot", "tronc_diam"])
    Y_to_keep = parser.get_one_option("Y", "age_estim")

    data = pd.read_csv(file)

    X = data[X_to_keep]
    Y = data[Y_to_keep]

    # print(X.shape, Y.shape)

    X = parse_string_data(X)

    # print(Y.head())

    # print(Y.value_counts())

    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)

    print("Models loaded")
    print(model.get_params())


if __name__ == "__main__":
    main()