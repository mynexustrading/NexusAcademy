'use server'

import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export async function submitQuiz(
  quizId: string,
  selections: Record<string, string>
): Promise<{ error: string }> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return { error: 'Not authenticated' }
  }

  const { data: quiz } = await supabase
    .from('quizzes')
    .select('id, pass_score')
    .eq('id', quizId)
    .single()

  if (!quiz) {
    return { error: 'Quiz not found' }
  }

  const { data: questions } = await supabase
    .from('questions')
    .select('id, answers(id, is_correct)')
    .eq('quiz_id', quizId)

  if (!questions || questions.length === 0) {
    return { error: 'This quiz has no questions' }
  }

  const unanswered = questions.filter((q) => !selections[q.id])
  if (unanswered.length > 0) {
    return { error: 'Please answer every question before submitting' }
  }

  const correctCount = questions.filter((q) =>
    q.answers.some((a) => a.id === selections[q.id] && a.is_correct)
  ).length

  const score = Math.round((correctCount / questions.length) * 10000) / 100
  const passed = score >= quiz.pass_score

  const { count } = await supabase
    .from('quiz_attempts')
    .select('id', { count: 'exact', head: true })
    .eq('quiz_id', quizId)
    .eq('user_id', user.id)

  const { error: insertError } = await supabase.from('quiz_attempts').insert({
    user_id: user.id,
    quiz_id: quizId,
    score,
    passed,
    attempt_number: (count ?? 0) + 1,
  })

  if (insertError) {
    return { error: insertError.message }
  }

  redirect(`/quiz/${quizId}/result`)
}
