require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  # -- Create account --------------------------------------------------------

  test "successful account creation" do
    email = unique_email

    visit "/"
    click_on "Create Account"

    # The verify account feature confirms the email itself, so Rodauth's
    # `require_login_confirmation?` is false and the page omits the field.
    assert_no_field "email-confirm"

    fill_in "email", with: email
    fill_in "password", with: "secret123"
    fill_in "password-confirm", with: "secret123"
    click_on "Create Account"

    assert_text "An email has been sent to you with a link to verify your account"
    assert_current_path "/"
    assert_text email

    visit email_link
    click_on "Verify Account"

    assert_text "Your account has been verified"
    assert_current_path "/"
    assert_text email
  end

  test "account creation shows error for a duplicate email" do
    email = create_account(password: "secret123")
    logout

    visit "/"
    click_on "Create Account"

    fill_in "email", with: email
    fill_in "password", with: "secret123"
    fill_in "password-confirm", with: "secret123"
    click_on "Create Account"

    assert_text "invalid login, already an account with this login"
    assert_current_path "/create-account"
    # Rodauth redisplays submitted values in non-password fields.
    assert_field "email", with: email
  end

  # -- Verify account --------------------------------------------------------

  test "verify account shows error for an invalid key" do
    visit "/verify-account?key=0_invalidkey"

    assert_text "There was an error verifying your account: invalid verify account key"
    assert_current_path "/login"
  end

  test "verify account resend shows error when recently sent" do
    email = unique_email

    visit "/"
    click_on "Create Account"
    fill_in "email", with: email
    fill_in "password", with: "secret123"
    fill_in "password-confirm", with: "secret123"
    click_on "Create Account"

    visit "/verify-account-resend"
    fill_in "email", with: email
    click_on "Send Verification Email"

    assert_text "An email has recently been sent to you with a link to verify your account"
  end

  test "login with an unverified account shows the resend verification page" do
    email = unique_email

    visit "/"
    click_on "Create Account"
    fill_in "email", with: email
    fill_in "password", with: "secret123"
    fill_in "password-confirm", with: "secret123"
    click_on "Create Account"

    logout

    # Expire the verify-account grace period so login is blocked.
    Account.find_by!(email: email).verification_key.update!(requested_at: 2.days.ago)

    click_on "Login"
    fill_in "email", with: email
    click_on "Login"

    assert_text "The account you tried to login with is currently awaiting verification"
    assert_selector "h1", text: "Resend Verification Email"
    assert_button "Send Verification Email"
    assert_current_path "/login"

    # The login carries over from the login attempt, so it's a hidden field
    # here rather than one to fill in again.
    assert_no_field "email"
    click_on "Send Verification Email"

    assert_text "An email has recently been sent to you with a link to verify your account"
  end

  # -- Login / logout --------------------------------------------------------

  test "successful login" do
    email = create_account(password: "secret123")
    logout

    click_on "Login"
    login(email: email, password: "secret123")

    assert_text "You have been logged in"
    assert_current_path "/"
    assert_text email
  end

  test "login asks for the password on a page of its own" do
    email = create_account(password: "secret123")
    logout

    click_on "Login"
    assert_no_field "password"

    fill_in "email", with: email
    click_on "Login"

    assert_text "Login recognized, please enter your password"
    assert_text email
    assert_field "password"
    assert_current_path "/login"
  end

  test "login shows error for an invalid password" do
    email = create_account(password: "secret123")
    logout

    click_on "Login"
    login(email: email, password: "wrongpassword")

    assert_text "There was an error logging in"
    assert_text "invalid password"
    assert_text email
    assert_current_path "/login"
  end

  test "login page links to the pages the enabled features contribute" do
    visit "/login"

    assert_link "Create a New Account"
    assert_link "Forgot Password?"
    assert_link "Resend Verify Account Information"
  end

  test "failed login offers to reset the password for the entered login" do
    email = create_account(password: "secret123")
    logout

    click_on "Login"
    login(email: email, password: "wrongpassword")

    assert_text "If you have forgotten your password"
    click_on "Send Reset Email"

    assert_text "An email has been sent to you with a link to reset the password"
  end

  test "successful logout via the standalone confirmation page" do
    create_account

    visit "/logout"
    click_on "Logout"

    assert_text "You have been logged out"
    assert_current_path "/"
    assert_no_text "Signed in as"
  end

  # -- Reset password --------------------------------------------------------

  test "successful password reset" do
    email = create_account(password: "secret123")
    logout

    click_on "Login"
    click_on "Forgot Password?"
    fill_in "email", with: email
    click_on "Send Reset Email"

    assert_text "An email has been sent to you with a link to reset the password"

    visit email_link
    fill_in "password", with: "newsecret456"
    fill_in "password-confirm", with: "newsecret456"
    click_on "Reset Password"

    assert_text "Your password has been reset"
    assert_current_path "/login"

    login(email: email, password: "newsecret456")

    assert_text "You have been logged in"
  end

  test "password reset request shows error for an unknown email" do
    visit "/"
    click_on "Login"
    click_on "Forgot Password?"
    fill_in "email", with: unique_email
    click_on "Send Reset Email"

    assert_text "There was an error requesting a password reset"
  end

  test "password reset shows error for mismatched confirmation" do
    email = create_account(password: "secret123")
    logout

    click_on "Login"
    click_on "Forgot Password?"
    fill_in "email", with: email
    click_on "Send Reset Email"

    visit email_link
    fill_in "password", with: "newsecret456"
    fill_in "password-confirm", with: "somethingelse"
    click_on "Reset Password"

    assert_text "There was an error resetting your password"
    assert_text "passwords do not match"
  end

  # -- Change password -------------------------------------------------------

  test "successful password change" do
    email = create_account(password: "secret123")

    visit "/change-password"
    fill_in "password", with: "secret123"
    fill_in "new-password", with: "newsecret456"
    fill_in "password-confirm", with: "newsecret456"
    click_on "Change Password"

    assert_text "Your password has been changed"
    assert_current_path "/"

    logout

    click_on "Login"
    login(email: email, password: "newsecret456")

    assert_text "You have been logged in"
  end

  test "password change shows error for wrong current password" do
    create_account(password: "secret123")

    visit "/change-password"
    fill_in "password", with: "wrongpassword"
    fill_in "new-password", with: "newsecret456"
    fill_in "password-confirm", with: "newsecret456"
    click_on "Change Password"

    assert_text "There was an error changing your password"
    assert_text "invalid password"
    assert_current_path "/change-password"
  end

  # -- Change email ----------------------------------------------------------

  test "successful email change" do
    create_account(password: "secret123")
    new_email = unique_email

    visit "/change-login"
    fill_in "password", with: "secret123"
    fill_in "email", with: new_email
    click_on "Change Email"

    assert_text "An email has been sent to you with a link to verify your login change"

    visit email_link
    click_on "Confirm Email Change"

    assert_text "Your login change has been verified"
    assert_current_path "/"

    logout

    click_on "Login"
    login(email: new_email, password: "secret123")

    assert_text "You have been logged in"
  end

  test "email change shows error for wrong current password" do
    create_account(password: "secret123")

    visit "/change-login"
    fill_in "password", with: "wrongpassword"
    fill_in "email", with: unique_email
    click_on "Change Email"

    assert_text "There was an error changing your login"
    assert_text "invalid password"
    assert_current_path "/change-login"
  end

  test "verify login change shows error for an invalid key" do
    create_account(password: "secret123")

    visit "/verify-login-change?key=0_invalidkey"

    assert_text "There was an error verifying your login change: invalid verify login change key"
  end

  # -- Close account ---------------------------------------------------------

  test "successful account closure" do
    create_account(password: "secret123")

    visit "/close-account"
    fill_in "password", with: "secret123"
    click_on "Close Account Permanently"

    assert_text "Your account has been closed"
    assert_no_text "Signed in as"
  end

  test "account closure shows error for wrong password" do
    create_account(password: "secret123")

    visit "/close-account"
    fill_in "password", with: "wrongpassword"
    click_on "Close Account Permanently"

    assert_text "There was an error closing your account"
    assert_text "invalid password"
    assert_current_path "/close-account"
  end

  # -- Remember --------------------------------------------------------------

  test "successful remember setting update for both settings" do
    create_account(password: "secret123")

    visit "/remember"
    choose "remember-remember"
    click_on "Update"

    assert_text "Your remember setting has been updated"

    visit "/remember"
    choose "remember-forget"
    click_on "Update"

    assert_text "Your remember setting has been updated"
  end

  private

  def unique_email
    "#{SecureRandom.hex(8)}@example.com"
  end

  def create_account(email: unique_email, password: "secret123")
    visit "/"
    click_on "Create Account"
    fill_in "email", with: email
    fill_in "password", with: password
    fill_in "password-confirm", with: password
    click_on "Create Account"

    visit email_link
    click_on "Verify Account"

    email
  end

  # Starting on the login page. Multi-phase login is enabled, so the email and
  # the password are submitted from separate pages.
  def login(email:, password:)
    fill_in "email", with: email
    click_on "Login"
    fill_in "password", with: password
    click_on "Login"
  end

  # The home page links to Rodauth's logout confirmation page, which is where
  # the actual logout is submitted from.
  def logout
    visit "/logout"
    click_on "Logout"
  end

  def email_link
    perform_enqueued_jobs
    email = ActionMailer::Base.deliveries.last
    email.body.to_s[%r{https?://\S+}]
  end
end
