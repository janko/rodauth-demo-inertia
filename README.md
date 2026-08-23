# Rodauth Inertia Demo

Rails app that demonstrates rendering [Rodauth] authentication pages as
[Inertia.js] React components instead of server-rendered ERB templates,
using the [inertia_rails] gem.

It implements the following authentication features:

* creating an account with verification and a grace period
* multi-phase login, asking for the email and the password on separate pages
* remember me
* reset and change password
* change email with verification
* close account

Rodauth's routing, validation, flash messages and redirects are used unchanged
— only rendering is replaced. It also includes system tests for all
authentication pages.

## Rendering

Rodauth renders a page by calling a `*_view` method, so each one is overridden
in `RodauthMain` to render an Inertia component:

```ruby
change_password_view do
  inertia_component "change_password",
    requires_password: change_password_requires_password?,
    require_password_confirmation: require_password_confirmation?
end
```

where `inertia_component` is a private method on the configuration:

```ruby
def inertia_component(component, props = {})
  rails_render inertia: "rodauth/#{component}", props: { errors: @field_errors || {}, **props }
end
```

The props carry the decisions Rodauth's own templates make as they render:
which fields to include, which submitted values to echo back, and the links it
builds in Ruby around the login form. Field errors are passed as a single
`errors` hash rather than read back one at a time via `field_error`, because
that's the shape Inertia's form error tracking expects.

Inertia's middleware needs to run before Rodauth's, as it copies the
`X-XSRF-TOKEN` header into `X-CSRF-Token`, which Rodauth's CSRF check relies on
(the React forms carry no `authenticity_token` field). That's set in
`config/application.rb`.

## Frontend

Assets are bundled by [Vite] through [rails_vite], with [Tailwind CSS] for
styling. Pages live in `app/frontend/pages`, so Rodauth's `rodauth/login`
component is `app/frontend/pages/rodauth/login.jsx`.

`app/frontend/layouts/layout.jsx` is applied to every page as the default
layout, and renders the flash messages Rodauth sets. The signed-in account is
shared with all Inertia responses from `ApplicationController`, so any page can
read it from `usePage().props`.

## Tests

System tests run against real Chrome through [Cuprite]:

```sh
bin/rails test:system
```

Set `CHROME_PATH` if Chrome isn't found on the default path.

[Rodauth]: https://github.com/jeremyevans/rodauth
[rodauth-rails]: https://github.com/janko/rodauth-rails
[Inertia.js]: https://inertiajs.com
[inertia_rails]: https://github.com/inertiajs/inertia-rails
[Vite]: https://vite.dev
[rails_vite]: https://github.com/skryukov/rails_vite
[Tailwind CSS]: https://tailwindcss.com
[Cuprite]: https://github.com/rubycdp/cuprite
