// Entry point for the Vite build. Bundled into public/vite for production.
//
// Inertia pages are mounted by entrypoints/inertia.jsx; keep app-wide,
// non-Inertia JavaScript here.

// Include images in the Vite manifest so `vite_image_tag` / `vite_asset_path` can resolve them.
import.meta.glob("../images/**/*.{png,jpg,jpeg,gif,svg,webp,avif,ico}", { eager: true })
