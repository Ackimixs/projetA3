document.querySelector("#login").addEventListener("submit", (e) => {
    e.preventDefault();
    let formData = new FormData(e.target);
    fetch("http://localhost:8080/api/login.php", {
        method: "POST",
        body: formData
    }).then(response => response.json())
        .then(data => {
            console.log(data);
            if (data.status === "success") {
                localStorage.setItem("user", JSON.stringify(data.data));
            }
    });
});

document.querySelector("#signup").addEventListener("submit", (e) => {
    e.preventDefault();
    let formData = new FormData(e.target);
    fetch("http://localhost:8080/api/signup.php", {
        method: "POST",
        body: formData
    }).then(response => response.json())
        .then(data => {
            console.log(data);
            if (data.status === "success") {
                localStorage.setItem("user", JSON.stringify(data.data));
            }
    });
});
