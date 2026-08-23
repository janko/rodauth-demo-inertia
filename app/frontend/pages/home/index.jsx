import { Head, Link } from '@inertiajs/react'

export default function Home({ account, links }) {
  return (
    <>
      <Head title="Rodauth + Inertia" />

      <h1 className="text-xl font-semibold">Rodauth + Inertia</h1>

      <p className="text-sm">
        {account ? (
          <>Signed in as <strong>{account.email}</strong></>
        ) : (
          'Not signed in.'
        )}
      </p>

      <ul className="text-sm space-y-1">
        {links.map(({ href, text }) => (
          <li key={href}>
            <Link href={href} className="text-blue-600 hover:underline">{text}</Link>
          </li>
        ))}
      </ul>
    </>
  )
}
