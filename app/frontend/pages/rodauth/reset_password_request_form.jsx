import { Form } from '@inertiajs/react'

// Rodauth renders its `reset-password-request` template in two places: as the
// reset password request page, and in the login form header after a failed
// login, with the entered login filled in.
export default function ResetPasswordRequestForm({ login }) {
  return (
    <Form action="/reset-password-request" method="post" className="space-y-4">
      {({ processing, errors }) => (
        <>
          <p className="text-sm">If you have forgotten your password, you can request a password reset:</p>
          {login && !errors.email ? (
            <input type="hidden" name="email" value={login} />
          ) : (
            <div>
              <label className="block text-sm font-semibold">Email</label>
              <input
                type="email"
                name="email"
                className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300"
                autoComplete="email"
              />
              {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email}</p>}
            </div>
          )}
          <button
            type="submit"
            disabled={processing}
            className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
          >
            Send Reset Email
          </button>
        </>
      )}
    </Form>
  )
}
