/** @type {import('tailwindcss').Config} */
module.exports = {
  // Use these exact paths to ensure no file is missed
  content: [
    "./app/**/*.{js,jsx,ts,tsx}",
    "./src/**/*.{js,jsx,ts,tsx}",
    "./src/screens/**/*.{js,jsx,ts,tsx}",
    "./src/components/**/*.{js,jsx,ts,tsx}",
  ],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        siplyLime: "#D0FF14",
        siplyMagenta: "#6C244C",
        siplyCharcoal: "#3C4044",
        siplyBrown: "#BF875D",
      },
    },
  },
  plugins: [],
};