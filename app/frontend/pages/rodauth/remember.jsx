import { Form } from '@inertiajs/react'

export default function Remember() {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Remember Me</h1>
      <Form action="/remember" method="post" className="space-y-4">
        {({ processing }) => (
          <>
            <fieldset className="space-y-2">
              <div className="flex items-center space-x-2">
                <input type="radio" id="remember-remember" name="remember" value="remember" />
                <label htmlFor="remember-remember" className="text-sm">Remember me on this computer</label>
              </div>
              <div className="flex items-center space-x-2">
                <input type="radio" id="remember-forget" name="remember" value="forget" />
                <label htmlFor="remember-forget" className="text-sm">Forget me on this computer</label>
              </div>
              <div className="flex items-center space-x-2">
                <input type="radio" id="remember-disable" name="remember" value="disable" />
                <label htmlFor="remember-disable" className="text-sm">Disable Remember Me</label>
              </div>
            </fieldset>
            <button
              type="submit"
              disabled={processing}
              className="w-full px-8 py-3 font-semibold text-sm rounded-md text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
            >
              Update
            </button>
          </>
        )}
      </Form>
    </div>
  )
}
