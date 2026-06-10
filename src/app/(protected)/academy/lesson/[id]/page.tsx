import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import { getLessonWithCompletion } from '@/modules/academy/queries'
import { markLessonComplete } from '@/modules/academy/actions'
import { Button } from '@/components/ui/button'

export default async function LessonPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) redirect('/login')

  const lesson = await getLessonWithCompletion(supabase, id, user.id)

  if (!lesson) notFound()

  return (
    <div className="mx-auto w-full max-w-3xl px-6 py-10">
      <nav className="mb-6 flex items-center gap-2 text-sm text-muted-foreground">
        <Link href="/academy" className="hover:text-foreground">Academy</Link>
        <span>/</span>
        <Link href={`/academy/module/${lesson.module.id}`} className="hover:text-foreground">
          {lesson.module.title}
        </Link>
        <span>/</span>
        <span className="text-foreground">{lesson.title}</span>
      </nav>

      <div className="mb-6 flex items-start justify-between gap-4">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground">{lesson.title}</h1>
        {lesson.completed && (
          <span className="shrink-0 rounded-full bg-foreground px-3 py-1 text-xs font-medium text-background">
            Completed
          </span>
        )}
      </div>

      <div className="space-y-6">
        {lesson.video_url && (
          <div className="rounded-xl border border-border bg-card p-5">
            <p className="mb-2 text-xs font-medium uppercase tracking-widest text-muted-foreground">Video</p>
            <a
              href={lesson.video_url}
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm font-medium text-foreground underline-offset-4 hover:underline"
            >
              Watch lesson video
            </a>
          </div>
        )}

        {lesson.pdf_url && (
          <div className="rounded-xl border border-border bg-card p-5">
            <p className="mb-2 text-xs font-medium uppercase tracking-widest text-muted-foreground">PDF</p>
            <a
              href={lesson.pdf_url}
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm font-medium text-foreground underline-offset-4 hover:underline"
            >
              Download PDF
            </a>
          </div>
        )}

        {lesson.notes && (
          <div className="rounded-xl border border-border bg-card p-5">
            <p className="mb-3 text-xs font-medium uppercase tracking-widest text-muted-foreground">Lesson Notes</p>
            <p className="whitespace-pre-wrap text-sm leading-relaxed text-foreground">{lesson.notes}</p>
          </div>
        )}

        {!lesson.video_url && !lesson.pdf_url && !lesson.notes && (
          <div className="rounded-xl border border-border bg-card p-8 text-center text-sm text-muted-foreground">
            Lesson content coming soon.
          </div>
        )}
      </div>

      {!lesson.completed && (
        <div className="mt-8">
          <form
            action={async () => {
              'use server'
              await markLessonComplete(id)
            }}
          >
            <Button type="submit" className="h-10 px-6">
              Mark as complete
            </Button>
          </form>
        </div>
      )}

      <div className="mt-8">
        <Link
          href={`/academy/module/${lesson.module.id}`}
          className="text-sm text-muted-foreground underline-offset-4 hover:text-foreground hover:underline"
        >
          ← Back to module
        </Link>
      </div>
    </div>
  )
}
