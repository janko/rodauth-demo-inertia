import { defineConfig } from 'vite'
import rails from 'rails-vite-plugin'
import inertia from '@inertiajs/vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    tailwindcss(),
    react(),
    inertia(),
    // Entry points are auto-discovered from app/frontend/entrypoints/
    rails({ sourceDir: 'app/frontend' }),
  ],
})
