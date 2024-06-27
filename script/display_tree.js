body_table = document.querySelector(".body-table-arbre")

let page = 0
let sort = "id"
let order = "ASC"
let filterCol = ""
let filterValue = ""

function display_tree(limit = 10, offset = 0, sort = 'id', order = 'ASC', filter_col = "", filter_value = "") {
    console.log(limit, offset, sort, order)

    fetch(`/api/tree.php?limit=${limit}&offset=${offset}&sort=${sort}&order=${order}&filter_col=${filter_col}&filter_value=${filter_value}`, {
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

                child.addEventListener("click", () => {
                    window.location.href = `/pred.html?id=${tree.id}`
                })
            })
        })
}

document.querySelectorAll(".filter-select").forEach(select => {
    fetch(`/api/${select.getAttribute("data-value")}/list.php`, {
        method: "GET"
    })
        .then(response => response.json())
        .then(data => {
            data.data.forEach(item => {
                let option = document.createElement("option");
                option.value = item.value;
                option.innerText = item.value.charAt(0).toUpperCase() + item.value.slice(1);

                select.appendChild(option);
            });
    })

    select.addEventListener("change", () => {

        document.querySelectorAll(".filter-select").forEach(s => {
            if (s !== select) s.selectedIndex = 0;
        })

        filterCol = select.getAttribute("data-value-db")
        filterValue = select.value

        if (filterValue === "") filterCol = "";

        display_tree(10, page*10, sort, order, filterCol, filterValue)
    })
})

document.querySelector("#prev").addEventListener("click", () => {
    if (page > 0) {
        page --
    }
    display_tree(10, page*10, sort, order, filterCol, filterValue)
    document.querySelector("#page").innerHTML = page.toString()
})

document.querySelector("#next").addEventListener("click", () => {
    page ++
    display_tree(10, page*10, sort, order, filterCol, filterValue)
    document.querySelector("#page").innerHTML = page.toString()
})

display_tree(10, page)

document.querySelectorAll("th").forEach(th => {
    th.addEventListener("click", (e) => {
        if (e.target.classList.contains("filter-select")) {
            return;
        }

        let new_sort = th.getAttribute("data-value")
        if (sort === new_sort) {
            order = order === "ASC" ? "DESC" : "ASC"
        } else {
            order = "ASC"
        }
        sort = new_sort
        addNewIcon(th, order)

        display_tree(10, page*10, sort, order, filterCol, filterValue)
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
