import { Form } from '@inertiajs/react'

export default function ChangePassword({ requires_password = true, require_password_confirmation = true }) {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Change Password</h1>
      <Form action="/change-password" method="post" className="space-y-4">
        {({ processing, errors }) => (
          <>
            {requires_password && (
              <div>
                <label className="block text-sm font-semibold">Current Password</label>
                <input type="password" name="password"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="current-password" />
                {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password}</p>}
              </div>
            )}
            <div>
              <label className="block text-sm font-semibold">New Password</label>
              <input type="password" name="new-password"
                className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="new-password" />
              {errors['new-password'] && <p className="mt-1 text-xs text-red-600">{errors['new-password']}</p>}
            </div>
            {require_password_confirmation && (
              <div>
                <label className="block text-sm font-semibold">Confirm New Password</label>
                <input type="password" name="password-confirm"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300" autoComplete="new-password" />
                {errors['password-confirm'] && <p className="mt-1 text-xs text-red-600">{errors['password-confirm']}</p>}
              </div>
            )}
            <button type="submit" disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50">
              Change Password
            </button>
          </>
        )}
      </Form>
    </div>
  )
}
