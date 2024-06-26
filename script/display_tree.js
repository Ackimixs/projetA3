body_table = document.querySelector(".body-table-arbre")

let page = 0
let sort = "id"
let order = "ASC"

function display_tree(limit = 10, offset = 0, sort = 'id', order = 'ASC') {
    console.log(limit, offset, sort, order)

    fetch(`/api/tree.php?limit=${limit}&offset=${offset}&sort=${sort}&order=${order}`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json"
        }
    })
        .then(response => response.json())
        .then(data => {
            body_table.innerHTML = ""

            data.data.forEach(tree => {
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
    display_tree(10, page*10, sort, order)
    document.querySelector("#page").innerHTML = page.toString()
})

document.querySelector("#next").addEventListener("click", () => {
    page ++
    display_tree(10, page*10, sort, order)
    document.querySelector("#page").innerHTML = page.toString()
})

display_tree(10, page)

document.querySelectorAll("th").forEach(th => {
    th.addEventListener("click", () => {
        console.log(th)
        let new_sort = th.getAttribute("data-value")
        if (sort === new_sort) {
            order = order === "ASC" ? "DESC" : "ASC"
        } else {
            order = "ASC"
        }
        sort = new_sort
        addNewIcon(th, order)

        display_tree(10, page*10, sort, order)
    })
})

function addNewIcon(target, order) {
    removeIcon()
    let icon_sort = document.createElement("div")
    icon_sort.className = "icon-sort"
    icon_sort.setAttribute("data-value", target.getAttribute("data-value"))

    let icon = document.createElement("span")
    icon.className = "material-symbols-outlined"
    icon.innerHTML = order === "ASC" ? "arrow_drop_down" : "arrow_drop_up"

    icon_sort.appendChild(icon)
    target.appendChild(icon_sort)
}

function removeIcon() {
    document.querySelectorAll(".icon-sort").forEach(icon => {
        icon.remove()
    })
}
