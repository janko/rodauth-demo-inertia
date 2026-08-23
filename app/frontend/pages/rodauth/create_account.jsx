import { Form, Link } from '@inertiajs/react'

export default function CreateAccount({
  login,
  login_confirm,
  set_password = true,
  require_login_confirmation = true,
  require_password_confirmation = true,
}) {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Create Account</h1>
      <Form action="/create-account" method="post" className="space-y-4">
        {({ processing, errors }) => (
          <>
            <div>
              <label className="block text-sm font-semibold">Email</label>
              <input type="email" name="email" defaultValue={login}
                className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="email" />
              {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email}</p>}
            </div>
            {require_login_confirmation && (
              <div>
                <label className="block text-sm font-semibold">Confirm Email</label>
                <input type="email" name="email-confirm" defaultValue={login_confirm}
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" />
                {errors['email-confirm'] && <p className="mt-1 text-xs text-red-600">{errors['email-confirm']}</p>}
              </div>
            )}
            {set_password && (
              <div>
                <label className="block text-sm font-semibold">Password</label>
                <input type="password" name="password"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="new-password" />
                {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password}</p>}
              </div>
            )}
            {set_password && require_password_confirmation && (
              <div>
                <label className="block text-sm font-semibold">Confirm Password</label>
                <input type="password" name="password-confirm"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="new-password" />
                {errors['password-confirm'] && <p className="mt-1 text-xs text-red-600">{errors['password-confirm']}</p>}
              </div>
            )}
            <button type="submit" disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50">
              Create Account
            </button>
          </>
        )}
      </Form>
      <p className="text-sm">
        <Link href="/login" className="text-blue-600 hover:underline">Already have an account?</Link>
      </p>
    </div>
  )
}
