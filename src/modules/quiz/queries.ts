import type { SupabaseClient } from '@supabase/supabase-js'
import type { QuizWithQuestions, QuizAttempt } from './types'

// Answers are selected WITHOUT is_correct so correct answers never reach the client.
export async function getQuizWithQuestions(
  supabase: SupabaseClient,
  quizId: string
): Promise<QuizWithQuestions | null> {
  const { data: quiz, error } = await supabase
    .from('quizzes')
    .select('id, title, quiz_type, pass_score, is_required')
    .eq('id', quizId)
    .single()

  if (error || !quiz) return null

  const { data: questions } = await supabase
    .from('questions')
    .select('id, quiz_id, question_text, question_type, order_index, answers(id, question_id, answer_text, order_index)')
    .eq('quiz_id', quizId)
    .order('order_index', { ascending: true })
    .order('order_index', { referencedTable: 'answers', ascending: true })

  return { ...quiz, questions: questions ?? [] }
}

export async function getLatestAttempt(
  supabase: SupabaseClient,
  quizId: string,
  userId: string
): Promise<QuizAttempt | null> {
  const { data } = await supabase
    .from('quiz_attempts')
    .select('id, user_id, quiz_id, score, passed, attempt_number, submitted_at')
    .eq('quiz_id', quizId)
    .eq('user_id', userId)
    .order('submitted_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  return data
}
