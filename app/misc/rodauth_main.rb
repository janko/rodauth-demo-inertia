require "sequel/core"

class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that are loaded.
    enable :create_account, :verify_account, :verify_account_grace_period,
      :login, :logout, :remember,
      :reset_password, :change_password, :change_login, :verify_login_change,
      :close_account

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # Initialize Sequel and have it reuse Active Record's database connection.
    db Sequel.sqlite(extensions: :activerecord_connection, keep_reference: false)
    # Avoid DB query that checks accounts table schema at boot time.
    convert_token_id_to_integer? { Account.columns_hash["id"].type == :integer }

    # Change prefix of table and foreign key column names from default "account"
    # accounts_table :users
    # verify_account_table :user_verification_keys
    # verify_login_change_table :user_login_change_keys
    # reset_password_table :user_password_reset_keys
    # remember_table :user_remember_keys

    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "fa08e3fc91171372657f8b2a729716ce97d1916e404e1a74195fe24c62df5d0f89db05f0a04d4c1b430758d6fe94849b89ca65e832719b2d2db1ec09b446bbfc"

    # Use path prefix for all routes.
    # prefix "/auth"

    # Specify the controller used for view rendering, CSRF, and callbacks.
    rails_controller { RodauthController }

    # Make built-in page titles accessible in your views via an instance variable.
    title_instance_variable :@page_title

    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    account_password_hash_column :password_hash

    # Set password when creating account instead of when verifying.
    verify_account_set_password? false

    # Change some default param keys.
    # Ask for the login and the password on separate pages, which is what
    # renders the `multi_phase_login` component. Rodauth still accepts a
    # single request carrying both.
    use_multi_phase_login? true

    login_param "email"
    login_confirm_param "email-confirm"
    # password_confirm_param "confirm_password"

    # Redirect back to originally requested location after authentication.
    # login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    # reset_password_autologin? true

    # Delete the account record when the user has closed their account.
    # delete_account_on_close? true

    # Redirect to the app from login and registration pages if already logged in.
    # already_logged_in { redirect login_redirect }

    # ==> Emails
    send_email do |email|
      # queue email delivery on the mailer after the transaction commits
      db.after_commit { email.deliver_later }
    end

    # ==> Flash
    # Match flash keys with ones already used in the Rails app.
    # flash_notice_key :success # default is :notice
    # flash_error_key :error # default is :alert

    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Passwords shorter than 8 characters are considered weak according to OWASP.
    password_minimum_length 8
    # bcrypt has a maximum input length of 72 bytes, truncating any extra bytes.
    password_maximum_bytes 72

    # Custom password complexity requirements (alternative to password_complexity feature).
    # password_meets_requirements? do |password|
    #   super(password) && password_complex_enough?(password)
    # end
    # auth_class_eval do
    #   def password_complex_enough?(password)
    #     return true if password.match?(/\d/) && password.match?(/[^a-zA-Z\d]/)
    #     set_password_requirement_error_message(:password_simple, "requires one number and one special character")
    #     false
    #   end
    # end

    # ==> Remember Feature
    # Remember all logged in users.
    after_login { remember_login }

    # Or only remember users that have ticked a "Remember Me" checkbox on login.
    # after_login { remember_login if param_or_nil("remember") }

    # Extend user's remember period when remembered via a cookie
    extend_remember_deadline? true

    # ==> Hooks
    # Validate custom fields in the create account form.
    # before_create_account do
    #   throw_error_status(422, "name", "must be present") if param("name").empty?
    # end

    # Perform additional actions after the account is created.
    # after_create_account do
    #   Profile.create!(account_id: account_id, name: param("name"))
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Profile.find_by!(account_id: account_id).destroy
    # end

    # ==> Redirects
    # Redirect to home page after logout.
    logout_redirect "/"

    # Redirect to wherever login redirects to after account verification.
    verify_account_redirect { login_redirect }

    # Redirect to login page after password reset.
    reset_password_redirect { login_path }

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days.to_i
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]

    # ==> Inertia views
    # Each Rodauth page renders an Inertia component instead of the built-in
    # Tilt template. The props carry the decisions Rodauth's own templates make
    # as they render: which fields to include, which submitted values to echo
    # back, and the markup it builds in Ruby around the login form.
    login_view do
      inertia_component "login",
        skip_password_field: skip_password_field_on_login?,
        login: param(login_param),
        reset_password_request: @reset_password_request,
        footer_links: login_form_footer_links.map { |_, href, text| { href:, text: } }
    end

    multi_phase_login_view do
      inertia_component "multi_phase_login",
        login: param(login_param),
        reset_password_request: @reset_password_request,
        footer_links: login_form_footer_links.map { |_, href, text| { href:, text: } }
    end

    # Rodauth's own login template embeds the password reset form in the page
    # header after a failed login (it assigns `@login_form_header`); flag it
    # here so the Inertia page can render the same thing.
    after_login_failure { @reset_password_request = true }

    logout_view { inertia_component "logout" }

    create_account_view do
      inertia_component "create_account",
        login: param(login_param),
        login_confirm: param(login_confirm_param),
        set_password: create_account_set_password?,
        require_login_confirmation: require_login_confirmation?,
        require_password_confirmation: require_password_confirmation?
    end

    verify_account_view do
      inertia_component "verify_account",
        set_password: verify_account_set_password?,
        require_password_confirmation: require_password_confirmation?
    end

    # Rodauth names this view after the feature, not the page.
    resend_verify_account_view do
      inertia_component "verify_account_resend", login: param(login_param)
    end

    reset_password_request_view { inertia_component "reset_password_request" }

    reset_password_view do
      inertia_component "reset_password",
        require_password_confirmation: require_password_confirmation?
    end

    change_password_view do
      inertia_component "change_password",
        requires_password: change_password_requires_password?,
        require_password_confirmation: require_password_confirmation?
    end

    change_login_view do
      inertia_component "change_login",
        login: param(login_param),
        login_confirm: param(login_confirm_param),
        requires_password: change_login_requires_password?,
        require_login_confirmation: require_login_confirmation?
    end

    close_account_view do
      inertia_component "close_account",
        requires_password: close_account_requires_password?
    end

    remember_view { inertia_component "remember" }

    verify_login_change_view { inertia_component "verify_login_change" }
  end

  private

  # Rodauth's templates read field errors back one at a time via `field_error`;
  # Inertia pages instead receive them all as an `errors` prop, the shape
  # Inertia's own success/error tracking expects.
  def inertia_component(component, props = {})
    rails_render inertia: "rodauth/#{component}", props: { errors: @field_errors || {}, **props }
  end
end
