// Load theme preference first

const savedTheme = localStorage.getItem("theme");

const currentTheme = savedTheme || "dark";

document.documentElement.setAttribute(
    "data-theme",
    currentTheme
);


// Set browser theme color

const themeColor =
    document.querySelector('meta[name="theme-color"]');

if (themeColor) {

    themeColor.setAttribute(
        "content",
        currentTheme === "light"
            ? "#f8fafc"
            : "#0f172a"
    );

}
