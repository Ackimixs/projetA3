document.querySelector(".login-form").addEventListener("submit", (e) => {
    e.preventDefault();
    let formData = new FormData(e.target);
    fetch(`http://localhost:8080/api/${document.querySelector('.btn-login').hidden === true ? 'signup' : 'login'}.php`, {
        method: "POST",
        body: formData
    }).then(response => response.json())
        .then(data => {
            console.log(data);
            if (data.status === "success") {
                localStorage.setItem("user", JSON.stringify(data.data));
                window.location.href = "http://localhost:8080/";
            }
        });
});

document.querySelector('.btn-to-signup').addEventListener('click', () => {
    document.querySelector('.btn-login').hidden = true;
    document.querySelector('.btn-signup').hidden = false;

    document.querySelector('.btn-to-login').hidden = false;
    document.querySelector('.btn-to-signup').hidden = true;

    document.querySelector('.no_account').hidden = true;
    document.querySelector('.have_account').hidden = false;
});

document.querySelector('.btn-to-login').addEventListener('click', () => {
    document.querySelector('.btn-login').hidden = false;
    document.querySelector('.btn-signup').hidden = true;

    document.querySelector('.btn-to-login').hidden = true;
    document.querySelector('.btn-to-signup').hidden = false;

    document.querySelector('.no_account').hidden = false;
    document.querySelector('.have_account').hidden = true;
})