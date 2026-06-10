import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { ChevronRight } from 'lucide-react'
import { createClient } from '@/lib/supabase/server'
import { getModuleWithLessons } from '@/modules/academy/queries'

export default async function ModulePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) redirect('/login')

  const module = await getModuleWithLessons(supabase, id, user.id)

  if (!module) notFound()

  return (
    <div className="mx-auto w-full max-w-3xl px-6 py-10">
      <nav className="mb-6 flex items-center gap-2 text-sm text-muted-foreground">
        <Link href="/academy" className="hover:text-foreground">Academy</Link>
        <span>/</span>
        <Link href={`/academy/stage/${module.stage.id}`} className="hover:text-foreground">
          {module.stage.title}
        </Link>
        <span>/</span>
        <span className="text-foreground">{module.title}</span>
      </nav>

      <div className="mb-8">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground">{module.title}</h1>
        {module.description && (
          <p className="mt-1 text-sm text-muted-foreground">{module.description}</p>
        )}
      </div>

      {module.lessons.length === 0 ? (
        <div className="rounded-xl border border-border bg-card p-8 text-center text-sm text-muted-foreground">
          No lessons available yet.
        </div>
      ) : (
        <div className="divide-y divide-border rounded-xl border border-border bg-card">
          {module.lessons.map((lesson, idx) => (
            <Link
              key={lesson.id}
              href={`/academy/lesson/${lesson.id}`}
              className="flex items-center gap-4 px-5 py-4 transition-colors hover:bg-muted/50 first:rounded-t-xl last:rounded-b-xl"
            >
              <div className={[
                'flex size-6 shrink-0 items-center justify-center rounded-full border text-xs font-medium',
                lesson.completed
                  ? 'border-transparent bg-foreground text-background'
                  : 'border-border text-muted-foreground',
              ].join(' ')}>
                {lesson.completed ? '✓' : idx + 1}
              </div>
              <div className="flex-1 min-w-0">
                <p className="truncate font-medium text-foreground">{lesson.title}</p>
                {lesson.is_required && (
                  <p className="text-xs text-muted-foreground">Required</p>
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
