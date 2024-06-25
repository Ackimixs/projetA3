window.addEventListener('pageshow', () => {
    if (!window.location.pathname.includes('auth')) {
        if (localStorage.getItem('user') === null) {
            window.location.href = `/auth.html?redirect=${encodeURIComponent(window.location.pathname)}`;
        }
    }
});
