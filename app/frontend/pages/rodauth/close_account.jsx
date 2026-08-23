import { Form } from '@inertiajs/react'

export default function CloseAccount({ requires_password = true }) {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold text-red-600">Close Account</h1>
      <p className="text-sm">This action is permanent and cannot be undone.</p>
      <Form action="/close-account" method="post" className="space-y-4">
        {({ processing, errors }) => (
          <>
            {requires_password && (
              <div>
                <label className="block text-sm font-semibold">Password</label>
                <input type="password" name="password"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="current-password" />
                {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password}</p>}
              </div>
            )}
            <button type="submit" disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-red-600 hover:bg-red-700 disabled:opacity-50">
              Close Account Permanently
            </button>
          </>
        )}
      </Form>
    </div>
  )
}
