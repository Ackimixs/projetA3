body_table = document.querySelector(".body-table-arbre")

let page = 0

function display_tree(limit = 10, offset = 0) {
    body_table.innerHTML = ""

    fetch(`/api/tree.php?limit=${limit}&offset=${offset}`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json"
        }
    })
        .then(response => response.json())
        .then(data => {
            data.data.forEach(tree => {
                console.log(tree)

                let child = document.createElement("tr");

                child.innerHTML = `
            <td>${tree.id}</td>
            <td>${tree.haut_tronc}</td>
            <td>${tree.haut_tot}</td>
            <td>${tree.tronc_diam}</td>
            <td>${tree.prec_estim}</td>
            <td>${tree.clc_nbr_diag}</td>
            <td>${tree.age_estim}</td>
            <td>${tree.remarquable}</td>
            <td>${parseFloat(tree.longitude).toFixed(2).toString()}</td>
            <td>${parseFloat(tree.latitude).toFixed(2).toString()}</td>
            <td>${tree.risque_deracinement ?? "Non prédit"}</td>
            <td>${tree.nom}</td>
            <td>${tree.etat_arbre}</td>
            <td>${tree.pied}</td>
            <td>${tree.port}</td>
            <td>${tree.stade_dev}</td>
            <td>${tree.username ?? "Admin"}</td>
        `

                body_table.appendChild(child)
            })
        })
}


document.querySelector("#prev").addEventListener("click", () => {
    if (page > 0) {
        page --
    }
    display_tree(10, page*10)
    document.querySelector("#page").innerHTML = page.toString()
})

document.querySelector("#next").addEventListener("click", () => {
    page ++
    display_tree(10, page*10)
    document.querySelector("#page").innerHTML = page.toString()
})

display_tree(10, page)