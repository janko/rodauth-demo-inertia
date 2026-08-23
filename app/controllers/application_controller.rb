class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Share the signed-in account with all Inertia responses
  # see https://inertia-rails.dev/guide/shared-data
  # Gated on `logged_in?` because `rails_account` is also set for the account
  # a request is acting on — e.g. the one a failed login attempt looked up.
  inertia_share account: -> {
    rodauth.rails_account&.as_json(only: [ :id, :email ]) if rodauth.logged_in?
  }
end
