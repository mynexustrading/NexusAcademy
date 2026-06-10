import { notFound } from 'next/navigation'
import Link from 'next/link'
import { ChevronRight } from 'lucide-react'
import { createClient } from '@/lib/supabase/server'
import { getStageWithModules } from '@/modules/academy/queries'

export default async function StagePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const stage = await getStageWithModules(supabase, id)

  if (!stage) notFound()

  return (
    <div className="mx-auto w-full max-w-3xl px-6 py-10">
      <nav className="mb-6 flex items-center gap-2 text-sm text-muted-foreground">
        <Link href="/academy" className="hover:text-foreground">Academy</Link>
        <span>/</span>
        <span className="text-foreground">{stage.title}</span>
      </nav>

      <div className="mb-8">
        <p className="text-xs font-medium uppercase tracking-widest text-muted-foreground">
          Stage {stage.order_index}
        </p>
        <h1 className="mt-1 text-2xl font-semibold tracking-tight text-foreground">{stage.title}</h1>
      </div>

      {stage.modules.length === 0 ? (
        <div className="rounded-xl border border-border bg-card p-8 text-center text-sm text-muted-foreground">
          No modules available yet.
        </div>
      ) : (
        <div className="space-y-3">
          {stage.modules.map((module, idx) => (
            <Link
              key={module.id}
              href={`/academy/module/${module.id}`}
              className="flex items-center justify-between rounded-xl border border-border bg-card px-5 py-4 transition-colors hover:bg-muted/50"
            >
              <div>
                <p className="text-xs font-medium uppercase tracking-widest text-muted-foreground">
                  Module {idx + 1}
                </p>
                <p className="mt-0.5 font-medium text-foreground">{module.title}</p>
                {module.description && (
                  <p className="mt-0.5 text-sm text-muted-foreground">{module.description}</p>
                )}
              </div>
              <ChevronRight className="shrink-0 size-4 text-muted-foreground" />
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
