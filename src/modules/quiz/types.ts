export interface Quiz {
  id: string
  title: string
  quiz_type: 'lesson' | 'module' | 'stage'
  pass_score: number
  is_required: boolean
}

export interface AnswerOption {
  id: string
  question_id: string
  answer_text: string
  order_index: number
}

export interface Question {
  id: string
  quiz_id: string
  question_text: string
  question_type: string
  order_index: number
  answers: AnswerOption[]
}

export interface QuizWithQuestions extends Quiz {
  questions: Question[]
}

export interface QuizAttempt {
  id: string
  user_id: string
  quiz_id: string
  score: number
  passed: boolean
  attempt_number: number
  submitted_at: string
}
