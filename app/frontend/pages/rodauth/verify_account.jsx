import { Form, Link } from '@inertiajs/react'

export default function VerifyAccount({ set_password = true, require_password_confirmation = true }) {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Verify Account</h1>
      {!set_password && <p className="text-sm">Click the button below to verify your account.</p>}
      <Form action="/verify-account" method="post" className="space-y-4">
        {({ processing, errors }) => (
          <>
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
            <button
              type="submit"
              disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
            >
              Verify Account
            </button>
          </>
        )}
      </Form>
      <p className="text-sm">
        <Link href="/verify-account-resend" className="text-blue-600 hover:underline">Resend verification email</Link>
      </p>
    </div>
  )
}
