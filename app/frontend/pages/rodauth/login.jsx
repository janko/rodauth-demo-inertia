import { Form, Link } from '@inertiajs/react'
import ResetPasswordRequestForm from './reset_password_request_form'

export default function Login({ skip_password_field, login, reset_password_request, footer_links = [] }) {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Login</h1>
      {reset_password_request && (
        <div className="p-4 border rounded-md border-gray-300">
          <ResetPasswordRequestForm login={login} />
        </div>
      )}
      <Form action="/login" method="post" className="space-y-4">
        {({ processing, errors }) => (
          <>
            <div>
              <label className="block text-sm font-semibold">Email</label>
              <input
                type="email"
                name="email"
                defaultValue={login}
                className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300"
                autoComplete="email"
              />
              {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email}</p>}
            </div>
            {!skip_password_field && (
              <div>
                <label className="block text-sm font-semibold">Password</label>
                <input
                  type="password"
                  name="password"
                  className="mt-2 text-sm w-full px-3 py-2 border rounded-md border-gray-300"
                  autoComplete="current-password"
                />
                {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password}</p>}
              </div>
            )}
            <button
              type="submit"
              disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
            >
              Login
            </button>
          </>
        )}
      </Form>
      {footer_links.length > 0 && (
        <>
          <h2 className="text-sm font-semibold">Other Options</h2>
          <ul className="text-sm space-y-1">
            {footer_links.map(({ href, text }) => (
              <li key={href}>
                <Link href={href} className="text-blue-600 hover:underline">{text}</Link>
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  )
}
