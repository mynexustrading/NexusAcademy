import { createClient } from '@/lib/supabase/server'
import { signOut } from '@/modules/auth/actions'
import { Button } from '@/components/ui/button'

export const metadata = { title: 'Dashboard — Nexus Academy' }

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) return null

  const { data: profile } = await supabase
    .from('users')
    .select('name, role')
    .eq('id', user.id)
    .single()

  return (
    <div className="flex min-h-screen flex-col bg-muted/40">
      <header className="border-b border-border bg-background px-6 py-4">
        <div className="mx-auto flex max-w-5xl items-center justify-between">
          <span className="font-semibold tracking-tight text-foreground">Nexus Academy</span>
          <form action={signOut}>
            <Button type="submit" variant="ghost" size="sm">
              Sign out
            </Button>
          </form>
        </div>
      </header>

      <main className="mx-auto w-full max-w-5xl flex-1 px-6 py-10">
        <div className="mb-8">
          <h1 className="text-2xl font-semibold tracking-tight text-foreground">
            Welcome, {profile?.name ?? user.email}
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Role: <span className="font-medium text-foreground capitalize">{profile?.role ?? 'student'}</span>
          </p>
        </div>

        <div className="rounded-xl border border-border bg-card p-6">
          <p className="text-sm text-muted-foreground">
            Your dashboard is being built. Academy, Journal, and Progression modules coming next.
          </p>
        </div>
      </main>
    </div>
  )
}
