import { Link } from '@inertiajs/react'
import ResetPasswordRequestForm from './reset_password_request_form'

export default function ResetPasswordRequest() {
  return (
    <div className="max-w-sm mx-auto space-y-4">
      <h1 className="text-xl font-semibold">Reset Password</h1>
      <ResetPasswordRequestForm />
      <p className="text-sm">
        <Link href="/login" className="text-blue-600 hover:underline">Back to login</Link>
      </p>
    </div>
  )
}
