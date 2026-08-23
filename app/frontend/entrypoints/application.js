// Entry point for the Vite build. Bundled into public/vite for production.
import "@hotwired/turbo-rails"

import "../controllers"

// Include images in the Vite manifest so `vite_image_tag` / `vite_asset_path` can resolve them.
import.meta.glob("../images/**/*.{png,jpg,jpeg,gif,svg,webp,avif,ico}", { eager: true })
