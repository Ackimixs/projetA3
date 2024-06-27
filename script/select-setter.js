let hasError = false;
let hasSuccess = false;
document.querySelectorAll("select").forEach(select => {
    if (select.getAttribute("data-to-fetch") === "1") {
        id = select.id;

        fetch(`/api/${id}/list.php`, {
            method: "GET"
        }).then(response => response.json())
            .then(data => {

                data.data.forEach(item => {
                    let option = document.createElement("option");
                    option.value = item.id;
                    option.innerText = item.value.charAt(0).toUpperCase() + item.value.slice(1);

                    option.selected = true;
                    select.insertBefore(option, select.firstChild);
                });
            })
            .catch(err => {
                console.log(err);
            });
    }
})

fetch('/api/name/list.php')
    .then(response => response.json())
    .then(data => {
        data.data.forEach(item => {
            let option = document.createElement("option");
            option.value = item.value;
            option.innerText = item.value.charAt(0).toUpperCase() + item.value.slice(1);
            option.selected = true;
            document.querySelector("#espece_arbre_list").appendChild(option);
        });
    })

document.querySelector("#create-arbre").addEventListener("submit", (e) => {
    e.preventDefault();
    let formData = new FormData(e.target);
    formData.set("id_user", JSON.parse(localStorage.getItem("user")).id);
    fetch(`/api/tree/add.php`, {
        method: "POST",
        body: formData
    }).then(response => response.json())
        .then(data => {
            if (data.status === "success") {
                document.querySelector("#success-message").innerText = "Arbre ajouté avec succès";
                document.querySelector("#success-message").hidden = false;
                hasSuccess = true;
                clearForm();
            }
            else {
                document.querySelector("#error-message").innerText = data.message;
                document.querySelector("#error-message").hidden = false;
                hasError = true;
            }
        });
})

document.querySelectorAll("input").forEach(input => {
    input.addEventListener("click", () => {
        if (hasError) {
            document.querySelector("#error-message").hidden = true;
            hasError = false;
        }
        if (hasSuccess) {
            document.querySelector("#success-message").hidden = true;
            hasSuccess = false;
        }
    })
})

document.querySelectorAll("select").forEach(select => {
    select.addEventListener("click", () => {
        if (hasError) {
            document.querySelector("#error-message").hidden = true;
            hasError = false;
        }
        if (hasSuccess) {
            document.querySelector("#success-message").hidden = true;
            hasSuccess = false;
        }
    })
});

/*
document.querySelectorAll("select").forEach(select => {
    select.addEventListener("change", () => {
        if (select.value === "other") {
            select.nextElementSibling.hidden = false;
        } else if (select.nextElementSibling.hidden === false) {
            select.nextElementSibling.hidden = true;
        }
    })
})*/

function clearForm() {
    document.querySelectorAll("input").forEach(input => {
        input.value = "";
    });
}
