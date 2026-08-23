# frozen_string_literal: true

InertiaRails.configure do |config|
  # rails_vite's equivalent of the generator's `ViteRuby.digest`.
  config.version = RailsVite.digest
  config.encrypt_history = true
  config.always_include_errors_hash = true
  config.use_script_element_for_initial_page = true
  config.use_data_inertia_head_attribute = true

  # Not stock: every page in this app is Inertia-rendered.
  config.default_render = true
end
