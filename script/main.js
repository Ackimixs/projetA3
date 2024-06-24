window.addEventListener('pageshow', () => {
    if (!window.location.pathname.includes('auth')) {
        if (localStorage.getItem('user') === null) {
            window.location.href = 'http://localhost:8080/auth.html';
        }
    }
});