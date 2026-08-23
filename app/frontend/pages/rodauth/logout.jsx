import { Form, Link } from '@inertiajs/react'

export default function Logout() {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Logout</h1>
      <p className="text-sm">Are you sure you want to log out?</p>
      <Form action="/logout" method="post">
        {({ processing }) => (
          <button
            type="submit"
            disabled={processing}
            className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-red-600 hover:bg-red-700 disabled:opacity-50"
          >
            Logout
          </button>
        )}
      </Form>
      <p className="text-sm">
        <Link href="/" className="text-blue-600 hover:underline">Cancel</Link>
      </p>
    </div>
  )
}
