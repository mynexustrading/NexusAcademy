import { redirect } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import { getLatestAttempt } from '@/modules/quiz/queries'

export default async function QuizResultPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) redirect('/login')

  const attempt = await getLatestAttempt(supabase, id, user.id)

  if (!attempt) redirect(`/quiz/${id}`)

  return (
    <div className="mx-auto w-full max-w-md px-6 py-16">
      <div className="rounded-xl border border-border bg-card p-8 text-center">
        <p className="text-xs font-medium uppercase tracking-widest text-muted-foreground">
          Attempt {attempt.attempt_number}
        </p>

        <p className="mt-6 text-5xl font-semibold tracking-tight text-foreground">
          {Number(attempt.score)}%
        </p>

        <p
          className={[
            'mx-auto mt-4 inline-block rounded-full px-4 py-1 text-sm font-medium',
            attempt.passed
              ? 'bg-foreground text-background'
              : 'bg-destructive/10 text-destructive',
          ].join(' ')}
        >
          {attempt.passed ? 'Passed' : 'Not passed'}
        </p>

        <p className="mt-6 text-sm text-muted-foreground">
          {attempt.passed
            ? 'Well done. You can continue your journey.'
            : 'Your score is below the passing threshold. Review the lessons and try again.'}
        </p>

        <div className="mt-8 flex flex-col gap-3">
          {!attempt.passed && (
            <Link
              href={`/quiz/${id}`}
              className="rounded-lg bg-foreground px-4 py-2 text-sm font-medium text-background transition-colors hover:bg-foreground/85"
            >
              Retake quiz
            </Link>
          )}
          <Link
            href="/academy"
            className="text-sm text-muted-foreground underline-offset-4 hover:text-foreground hover:underline"
          >
            Back to Academy
          </Link>
        </div>
      </div>
    </div>
  )
}
