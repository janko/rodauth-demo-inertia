import { Form } from '@inertiajs/react'

export default function VerifyAccountResend({ login }) {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Resend Verification Email</h1>
      <p className="text-sm">If you no longer have the email to verify the account, you can request that it be resent to you:</p>
      <Form action="/verify-account-resend" method="post" className="space-y-4">
        {({ processing, errors }) => (
          <>
            {login ? (
              <input type="hidden" name="email" value={login} />
            ) : (
              <div>
                <label className="block text-sm font-semibold">Email</label>
                <input type="email" name="email"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="email" />
              </div>
            )}
            {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email}</p>}
            <button type="submit" disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50">
              Send Verification Email
            </button>
          </>
        )}
      </Form>
    </div>
  )
}
