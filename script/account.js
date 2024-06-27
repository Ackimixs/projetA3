document.querySelector("#username-text").innerHTML = JSON.parse(localStorage.getItem("user")).username;

document.querySelector(".btn-username").addEventListener("click", () => {
    let newUsername = document.querySelector("#modify-username").value;
    if (newUsername === "") return;
    fetch(`/api/account.php?username=${newUsername}&id=${JSON.parse(localStorage.getItem('user')).id}`, {
        method: "PUT"
    })
        .then(response => response.json())
        .then(({data}) => {

            document.getElementById("text-modif-username").style.color = 'green';
            document.getElementById("text-modif-username").innerHTML = "Modification pris en compte";
            setTimeout(() => {
                document.getElementById("text-modif-username").innerHTML = "";
            }, 3000)

            localStorage.setItem("user", JSON.stringify(data));
            document.querySelector("#modify-username").value = "";
            document.querySelector("#username-text").innerHTML = data.username;
        })
})

document.querySelector(".btn-password").addEventListener("click", () => {
    let password = document.querySelector("#modify-password").value;
    if (password === "") return;
    let newPassword = document.querySelector("#modify-password-check").value;

    let username = JSON.parse(localStorage.getItem('user')).username

    let formData = new FormData();
    formData.append("username", username);
    formData.append("password", password);

    fetch(`/api/login.php`, {
        method: "POST",
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === "success") {
                fetch(`/api/account.php?password=${newPassword}&id=${JSON.parse(localStorage.getItem('user')).id}`, {
                    method: "PUT"
                })
                    .then(response => response.json())
                    .then(({data}) => {
                        document.getElementById("text-modif-password").style.color = 'green';
                        document.getElementById("text-modif-password").innerHTML = "Modification pris en compte";

                        setTimeout(() => {
                            document.getElementById("text-modif-password").innerHTML = "";
                        }, 3000)

                        document.querySelector("#modify-password").value = "";
                        document.querySelector("#modify-password-check").value = "";
                        localStorage.setItem("user", JSON.stringify(data));
                    })
            }
            else{
                document.getElementById("text-modif-password").style.color = 'red';
                document.getElementById("text-modif-password").innerHTML = "Modification non pris en compte veuillez reésayer";
                setTimeout(() => {
                    document.getElementById("text-modif-password").innerHTML = "";
                }, 3000)
            }
        })
})


let body_table = document.querySelector(".body-table-arbre");

fetch('/api/tree/user.php?id=' + JSON.parse(localStorage.getItem('user')).id, {
    method: "GET"
})
    .then(response => response.json())
    .then(({data}) => {
        if (!data) return;

        body_table.innerHTML = ""

        data.forEach(tree => {
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

            child.addEventListener("click", () => {
                window.location.href = `/pred.html?id=${tree.id}`
            })

            body_table.appendChild(child)
        })
    })
