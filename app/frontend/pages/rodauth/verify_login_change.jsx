import { Form } from '@inertiajs/react'

export default function VerifyLoginChange() {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Verify Email Change</h1>
      <p className="text-sm">Click below to confirm your new email address.</p>
      <Form action="/verify-login-change" method="post">
        {({ processing }) => (
          <button
            type="submit"
            disabled={processing}
            className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
          >
            Confirm Email Change
          </button>
        )}
      </Form>
    </div>
  )
}
