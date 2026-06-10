import Link from 'next/link'
import { ChevronRight } from 'lucide-react'
import { createClient } from '@/lib/supabase/server'
import { getStages } from '@/modules/academy/queries'

export const metadata = { title: 'Academy — Nexus Academy' }

export default async function AcademyPage() {
  const supabase = await createClient()
  const stages = await getStages(supabase)

  return (
    <div className="mx-auto w-full max-w-3xl px-6 py-10">
      <div className="mb-8">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground">Academy</h1>
        <p className="mt-1 text-sm text-muted-foreground">Your trader transformation journey</p>
      </div>

      {stages.length === 0 ? (
        <div className="rounded-xl border border-border bg-card p-8 text-center text-sm text-muted-foreground">
          No stages available yet.
        </div>
      ) : (
        <div className="space-y-3">
          {stages.map((stage) => (
            <Link
              key={stage.id}
              href={`/academy/stage/${stage.id}`}
              className="flex items-center justify-between rounded-xl border border-border bg-card px-5 py-4 transition-colors hover:bg-muted/50"
            >
              <div>
                <p className="text-xs font-medium uppercase tracking-widest text-muted-foreground">
                  Stage {stage.order_index}
                </p>
                <p className="mt-0.5 font-medium text-foreground">{stage.title}</p>
              </div>
              <ChevronRight className="shrink-0 size-4 text-muted-foreground" />
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
