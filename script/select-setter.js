let hasError = false;

document.querySelectorAll("select").forEach(select => {
    select.addEventListener("click", () => {
        if (hasError) {
            document.querySelector("#error").hidden = true;
            hasError = false;
        }
    })

    if (select.getAttribute("data-to-fetch") === "1") {
        id = select.id;

        fetch(`/api/tree/type/${id}.php`, {
            method: "GET"
        }).then(response => response.json())
            .then(data => {

                data.data.forEach(item => {
                    let option = document.createElement("option");
                    option.value = item.id;
                    option.innerText = item.value.charAt(0).toUpperCase() + item.value.slice(1);

                    select.appendChild(option);
                });
            })
            .catch(err => {
                console.log(err);
            });
    }
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
                window.location.href = "/index.html";
            }
            else {
                document.querySelector("#error").innerText = data.message;
                document.querySelector("#error").hidden = false;
                hasError = true;
            }
        });
})

document.querySelectorAll("input").forEach(input => {
    input.addEventListener("click", () => {
        if (hasError) {
            document.querySelector("#error").hidden = true;
            hasError = false;
        }
    })
})
