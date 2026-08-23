class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Share data with all Inertia responses
  # see https://inertia-rails.dev/guide/shared-data
  #   inertia_share user: -> { Current.user&.as_json(only: [ :id, :name, :email ]) }
end
