# Build Vite assets once up front via `test:prepare` rather than on the first
# request, so parallel test workers don't race each other running the build.
Rails.application.config.rails_vite.auto_build = false if Rails.env.test?
