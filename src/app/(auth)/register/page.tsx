import { RegisterForm } from '@/modules/auth/components/RegisterForm'

export const metadata = { title: 'Create account — Nexus Academy' }

export default function RegisterPage() {
  return (
    <div className="rounded-xl border border-border bg-card px-8 py-10 shadow-sm">
      <div className="mb-8 space-y-1">
        <h1 className="text-xl font-semibold tracking-tight text-foreground">Create account</h1>
        <p className="text-sm text-muted-foreground">
          Start your trader transformation journey
        </p>
      </div>
      <RegisterForm />
    </div>
  )
}
