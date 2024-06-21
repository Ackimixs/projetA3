import pandas as pd
from CLParser import CLParser
import sys
import json
import pickle

from sklearn.cluster import KMeans

from sklearn.preprocessing import OrdinalEncoder


def distance_with_centroid(data, centroid):
    return sum((data - centroid) ** 2)


def parse_string_data(data):
    for col in data.columns:
        if data[col].dtype == "object":
            data_to = data[[col]]
            print(col)
            encoder = pickle.load(open("encoders/" + col + "_encoder.pkl", 'rb'))

            data.loc[:, col] = encoder.transform(data_to)
    return data


def load_models(filename):
    with open(filename, 'rb') as file:
        return pickle.load(file)


def main():
    parser = CLParser(sys.argv)

    if parser.has_option("f2"):
        func = "f2"
    elif parser.has_option("f3"):
        func = "f3"
    elif parser.has_option("f1"):
        func = "f1"
    else:
        func = "f2"

    if func == "f2" or func == "f3":
        models_name = parser.get_one_option("model", "MLPClassifier")
        grid_search = parser.has_option("grid_search")
        if grid_search:
            model = load_models("models/" + func + "_" + models_name + "_grid_search.pkl")
        else:
            model = load_models("models/" + func + "_" + models_name + ".pkl")

        file = parser.get_one_option("input_json", "")
        output_file = parser.get_one_option("output_json", "output.json")

        if file == "":
            sys.exit()

        data = pd.DataFrame(json.load(open(file)))

        data = parse_string_data(data)

        result = model.predict(data).tolist()

        to_save = []

        if func == "f2":
            for i in result:
                to_save.append({"class": i, "min_age": i * 10, "max_age": i * 10 + 9})
        elif func == "f3":
            for i in result:
                to_save.append({"class": i})

        json.dump(to_save, open(output_file, "w"))

    elif func == "f1":
        algo = parser.get_one_option("algo", "Kmeans")
        nb_clusters = int(parser.get_one_option("nb_clusters", "3"))

        with open(algo + "_" + str(nb_clusters) + ".csv", 'r') as file:
            data = pd.read_csv(file).sort_values(by=['moy_haut_tot'])[["Centroide_haut_tronc", "Centroide_tronc_diam",
                                                                       "Centroide_age_estim",
                                                                       "Centroide_fk_prec_estim"]].values

            file = parser.get_one_option("input_json", "")
            output_file = parser.get_one_option("output_json", "output.json")

            with open(file, 'r') as json_file:
                json_data = json.load(json_file)

                best = 0
                for i in range(nb_clusters):

                    if distance_with_centroid(json_data, data[i]) < distance_with_centroid(json_data, data[best]):
                        best = i

                to_save = {"cluster": best, "centroid": data[best].tolist(),
                           "distance": distance_with_centroid(json_data, data[best]), "algo": algo,
                           "nb_clusters": nb_clusters}

                json.dump(to_save, open(output_file, "w"))


if __name__ == "__main__":
    main()
