import { notFound } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { getQuizWithQuestions } from '@/modules/quiz/queries'
import { QuizForm } from '@/modules/quiz/components/QuizForm'

export default async function QuizPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const quiz = await getQuizWithQuestions(supabase, id)

  if (!quiz) notFound()

  return (
    <div className="mx-auto w-full max-w-3xl px-6 py-10">
      <div className="mb-8">
        <p className="text-xs font-medium uppercase tracking-widest text-muted-foreground">
          {quiz.quiz_type} quiz
        </p>
        <h1 className="mt-1 text-2xl font-semibold tracking-tight text-foreground">{quiz.title}</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Passing score: {quiz.pass_score}% · {quiz.questions.length} questions
        </p>
      </div>

      {quiz.questions.length === 0 ? (
        <div className="rounded-xl border border-border bg-card p-8 text-center text-sm text-muted-foreground">
          This quiz has no questions yet.
        </div>
      ) : (
        <QuizForm quizId={quiz.id} questions={quiz.questions} />
      )}
    </div>
  )
}
