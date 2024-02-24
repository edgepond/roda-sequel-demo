/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./views/**/*.erb", "./assets/**/*.css"],
    theme: {
        extend: {},
    },
    plugins: [
        require('@tailwindcss/forms'),
    ],
}
