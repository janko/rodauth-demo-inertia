import { usePage } from '@inertiajs/react'

const flashClasses = 'rounded-md border px-4 py-3 text-sm'

// Default layout applied to every page by entrypoints/inertia.jsx.
export default function Layout({ children }) {
  // inertia_rails only sets the top-level `flash` key when something is in the
  // Rails flash, so it's absent on most responses.
  const { flash = {} } = usePage()

  return (
    <div className="max-w-2xl mx-auto p-6 space-y-4">
      {flash.notice && (
        <p className={`${flashClasses} border-green-200 bg-green-50 text-green-800`}>
          {flash.notice}
        </p>
      )}
      {flash.alert && (
        <p className={`${flashClasses} border-red-200 bg-red-50 text-red-800`}>
          {flash.alert}
        </p>
      )}
      {children}
    </div>
  )
}
