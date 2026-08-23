// Import and register all controllers matching controllers/**/*_controller.js
import { registerControllers } from "stimulus-vite-helpers"
import { application } from "./application"

const controllers = import.meta.glob("./**/*_controller.js", { eager: true })
registerControllers(application, controllers)
