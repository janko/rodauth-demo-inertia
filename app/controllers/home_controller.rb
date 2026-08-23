# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render inertia: { links: authentication_links }
  end

  private

  # Built from Rodauth's own path helpers, so they follow the configuration
  # (a `prefix`, renamed routes) rather than hardcoding URLs.
  def authentication_links
    if rodauth.logged_in?
      [
        { href: rodauth.change_password_path, text: "Change Password" },
        { href: rodauth.change_login_path, text: "Change Email" },
        { href: rodauth.remember_path, text: "Remember Me" },
        { href: rodauth.close_account_path, text: "Close Account" },
        { href: rodauth.logout_path, text: "Logout" }
      ]
    else
      [
        { href: rodauth.login_path, text: "Login" },
        { href: rodauth.create_account_path, text: "Create Account" },
        { href: rodauth.reset_password_request_path, text: "Forgot Password?" },
        { href: rodauth.verify_account_resend_path, text: "Resend Verification Email" }
      ]
    end
  end
end
