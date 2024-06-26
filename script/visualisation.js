// Fonction pour déballer les données
function unpack(rows, ...key) {
    return rows.map(function(row) {
        return key.map(function(k) {
            return row[k];
        }).join(", ");
    });
}

function unpackWithKeys(rows, ...key) {
    return rows.map(function(row) {
        return key.map(function(k) {
            return k[1] + ": " + row[k[0]];
        }).join("<br>");
    });
}


function unpackColor(rows) {
    return rows.map(function(row) {
        return row.cluster === -1 ? "black" : row.cluster === 0 ? "blue" : row.cluster === 1 ? "red" : "green";
    });
}

async function getClusters(method = "Kmeans", nb_clusters = 3) {
    let response = await fetch(`/api/tree/prediction/cluster.php?method=${method}&nb_clusters=${nb_clusters}`);
    return response.json();
}

function drawMap(clustering = false, method = "Kmeans", nb_clusters = 3) {
    // Utilisation de fetch pour récupérer les données JSON
    fetch("/api/tree.php?all=true", {
        method: "GET"
    })
        .then(response => response.json())
        .then(async rows => {
            rows = rows.data

            const clusteredData = (await getClusters(method, nb_clusters));

            let j = 0;
            for (let i = 0; i < rows.length; i++) {
                if (rows[i].id === clusteredData[j]?.tree.id) {
                    rows[i].cluster = clusteredData[j].cluster;
                } else {
                    rows[i].cluster = -1;
                    j--;
                }

                j++;
            }

            let data = [
                {
                    type: "scattermapbox",
                    text: unpackWithKeys(rows, ["nom", "Nom"], ["haut_tronc", "Hauteur Tronc"], ["haut_tot", "Hauteur Totale"], ["tronc_diam", "Diametre du tronc"], ["prec_estim", "Precision estimé"], ["clc_nbr_diag", "Nombre de diagnostique"], ['age_estim', "Age Estimé"]),
                    lon: unpack(rows, "longitude"),
                    lat: unpack(rows, "latitude"),
                    hoverinfo: unpack(rows, "nom", "haut_tronc", "haut_tot"),
                    marker: {
                        color: clustering ? unpackColor(rows) : "blue",
                        size: 12
                    }
                }
            ];

            let layout = {
                dragmode: "zoom",
                mapbox: { style: "open-street-map", center: { lat: 49.85, lon: 3.30 }, zoom: 11 },
                margin: { r: 10, t: 30, b: 30, l: 10 }
            };

            Plotly.newPlot("simple-visualisation", data, layout);
        })
        .catch(error => console.error('Error fetching the JSON data:', error));
}

let btn1 = document.getElementById('btn-choise-map');
let btn2 = document.getElementById('btn-choise-tab');

let map = document.getElementById('simple-visualisation');
let tab = document.getElementById('simple-tab');
let tab_btn = document.getElementById('tab-btn');
let choix = document.getElementById('choose');

btn1.addEventListener("click", updateBtn1);
btn2.addEventListener("click", updateBtn2);

btn1.addEventListener("click", changemaptab);
btn2.addEventListener("click", changemaptab);

function updateBtn1() {
    if(btn1.value === "select"){

    }
    else{
        btn1.style.backgroundColor = '#C38D9E';
        btn1.style.color = 'white';
        btn1.value = "select"
        map.setAttribute('data-status', 'visible');
        choix.setAttribute('data-status', 'visible');
        tab.setAttribute('data-status', 'hidden');
        tab_btn.setAttribute('data-status', 'hidden');

        btn2.style.backgroundColor = 'lightgray';
        btn2.style.color = 'black';
        btn2.value = "not-select"

    }

}
function updateBtn2() {

    if(btn2.value === "select"){

    }
    else{
        btn2.style.backgroundColor ='#C38D9E';
        btn2.style.color = 'white';
        btn2.value = "select"
        tab.setAttribute('data-status', 'visible');
        tab_btn.setAttribute('data-status', 'hidden');
        map.setAttribute('data-status', 'hidden');
        choix.setAttribute('data-status', 'hidden');
        console.log("changé")

        btn1.style.backgroundColor = 'lightgray';
        btn1.style.color = 'black';
        btn1.value = "not-select"

    }
}

function changemaptab(){
    if (map.getAttribute('data-status') === 'visible'){
        map.style.display = 'block';
        choix.style.display = 'flex';
        tab.style.display = 'none';
        tab_btn.style.display = 'none';
    }
    else{
        map.style.display = 'none';
        choix.style.display = 'none';
        tab.style.display = 'block';
        tab_btn.style.display = 'flex';
    }
}

let select = document.getElementById('options');
select.addEventListener("change", clustermap);

function clustermap(){
    if(select.value === "nc"){
        drawMap(false);
    }
    else if(select.value === "Km2")
    {
        drawMap(true,"Kmeans", 2);
    }
    else if(select.value === "Km3")
    {
        drawMap(true,"Kmeans", 3);
    }
    else if(select.value === "B2")
    {
        drawMap(true,"Birch", 2);
    }
    else if(select.value === "B3")
    {
        drawMap(true,"Birch", 3);
    }
}

drawMap(false);