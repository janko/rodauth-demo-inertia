import { defineConfig } from 'vite'
import rails from 'rails-vite-plugin'

export default defineConfig({
  plugins: [
    // Entry points are auto-discovered from app/frontend/entrypoints/
    rails({ sourceDir: 'app/frontend' }),
  ],
})
