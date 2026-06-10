import { LoginForm } from '@/modules/auth/components/LoginForm'

export const metadata = { title: 'Sign in — Nexus Academy' }

export default function LoginPage() {
  return (
    <div className="rounded-xl border border-border bg-card px-8 py-10 shadow-sm">
      <div className="mb-8 space-y-1">
        <h1 className="text-xl font-semibold tracking-tight text-foreground">Sign in</h1>
        <p className="text-sm text-muted-foreground">
          Welcome back to Nexus Academy
        </p>
      </div>
      <LoginForm />
    </div>
  )
}
