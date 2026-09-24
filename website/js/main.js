// Tema chiaro / scuro

const themeToggle = document.getElementById("theme-toggle");

function updateThemeButton() {

    const currentTheme =
        document.documentElement.getAttribute("data-theme");

    if (currentTheme === "light") {

        themeToggle.textContent = "☾";

        themeToggle.setAttribute(
            "aria-label",
            "Attiva tema scuro"
        );

    } else {

        themeToggle.textContent = "☀";

        themeToggle.setAttribute(
            "aria-label",
            "Attiva tema chiaro"
        );
    }
}


function updateThemeColor(theme) {

    const oldThemeColor =
        document.querySelector('meta[name="theme-color"]');

    if (oldThemeColor) {
        oldThemeColor.remove();
    }

    const newThemeColor =
        document.createElement("meta");

    newThemeColor.name = "theme-color";

    newThemeColor.content =
        theme === "light"
            ? "#f8fafc"
            : "#0f172a";

    document.head.appendChild(newThemeColor);
}


updateThemeButton();


themeToggle.addEventListener("click", () => {

    const currentTheme =
        document.documentElement.getAttribute("data-theme");

    const newTheme =
        currentTheme === "light"
            ? "dark"
            : "light";

    document.documentElement.setAttribute(
        "data-theme",
        newTheme
    );

    localStorage.setItem(
        "theme",
        newTheme
    );

    updateThemeColor(newTheme);

    updateThemeButton();

});

// Menu Mobile
const menuToggle = document.querySelector(".menu-toggle");
const menu = document.querySelector(".menu");
const menuLinks = document.querySelectorAll(".menu a");


// Apri / Chiudi Menu

menuToggle.addEventListener("click", () => {

    menu.classList.toggle("active");
    menuToggle.classList.toggle("active");
    const aperto = menu.classList.contains("active");
    menuToggle.setAttribute("aria-expanded", aperto);

});


// Chiudi il menu dopo aver selezionato una voce
menuLinks.forEach((link) => {

    link.addEventListener("click", () => {
        menu.classList.remove("active");
        menuToggle.classList.remove("active");
        menuToggle.setAttribute("aria-expanded", "false");
    });

});


// Anno Dinamico
document.getElementById("anno").textContent = new Date().getFullYear();
