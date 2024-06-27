async function fetchData(id) {
    let response = await fetch(`/api/tree.php?id=${id}`);
    return response.json();
}

async function loadData(id) {
    const data = (await fetchData(id)).data

    for (const [key, value] of Object.entries(data)) {
        if (key !== "age_estim" && key !== "risque_deracinement" && key !== "username") {
            document.querySelector(`#${key}`).innerText = value;
        }
    }
}

(async () => {
    const id = (new URLSearchParams(window.location.search)).get("id") ?? 1;
    document.querySelector("#tree-id").value = id;
    await loadData(id);
})()

document.querySelector("#btn-search-id").addEventListener("click", async () => {
    const id = document.querySelector("#tree-id").value;
    await loadData(id);
    window.location.search = `?id=${id}`;
})

document.querySelector("#btn-predict").addEventListener("click", () => {
    const model_grid = document.querySelector('#prediction-model').value;
    if (model_grid === "") return;
    const gridSearch = model_grid.split('-').length === 2;
    const model = model_grid.split('-')[0];
    const id = document.querySelector("#tree-id").value;
    fetch(`/api/tree/prediction/age.php?model=${model}&grid_search=${gridSearch}&id=${id}`, {
        method: "GET"
    })
        .then(response => response.json())
        .then(data => {
            document.querySelector("#predict-age").value = data.age;
        })

    fetch(`/api/tree/prediction/risque_deracinement.php?model=${model}&grid_search=${gridSearch}&id=${id}`, {
        method: "GET"
    })
        .then(response => response.json())
        .then(data => {
            document.querySelector("#predict-uproot").value = data.deracinement ? "Oui" : "Non";
        })

    /*fetch(`/api/tree/prediction/cluster.php?model=Kmean&nb_clusters=3&id=${id}`, {
        method: "GET"
    })
        .then(response => response.json())
        .then(data => {
            document.querySelector("#predict-height").value = data[0].class;
        })*/
})