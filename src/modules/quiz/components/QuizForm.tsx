'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { submitQuiz } from '../actions'
import type { Question } from '../types'

export function QuizForm({ quizId, questions }: { quizId: string; questions: Question[] }) {
  const [selections, setSelections] = useState<Record<string, string>>({})
  const [serverError, setServerError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  const allAnswered = questions.every((q) => selections[q.id])

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!allAnswered) {
      setServerError('Please answer every question before submitting')
      return
    }
    setServerError(null)
    setSubmitting(true)
    const result = await submitQuiz(quizId, selections)
    // submitQuiz redirects on success; reaching here means an error was returned
    if (result?.error) {
      setServerError(result.error)
      setSubmitting(false)
    }
  }

  return (
    <form onSubmit={onSubmit} className="space-y-8">
      {questions.map((question, qIdx) => (
        <fieldset key={question.id} className="rounded-xl border border-border bg-card p-6">
          <legend className="sr-only">Question {qIdx + 1}</legend>
          <p className="mb-4 font-medium text-foreground">
            <span className="mr-2 text-muted-foreground">{qIdx + 1}.</span>
            {question.question_text}
          </p>
          <div className="space-y-2">
            {question.answers.map((answer) => (
              <label
                key={answer.id}
                className={[
                  'flex cursor-pointer items-center gap-3 rounded-lg border px-4 py-3 text-sm transition-colors',
                  selections[question.id] === answer.id
                    ? 'border-foreground bg-muted'
                    : 'border-border hover:bg-muted/50',
                ].join(' ')}
              >
                <input
                  type="radio"
                  name={question.id}
                  value={answer.id}
                  checked={selections[question.id] === answer.id}
                  onChange={() =>
                    setSelections((prev) => ({ ...prev, [question.id]: answer.id }))
                  }
                  className="accent-foreground"
                />
                <span className="text-foreground">{answer.answer_text}</span>
              </label>
            ))}
          </div>
        </fieldset>
      ))}

      {serverError && (
        <div className="rounded-lg border border-destructive/30 bg-destructive/10 px-3 py-2 text-sm text-destructive">
          {serverError}
        </div>
      )}

      <Button type="submit" disabled={submitting || !allAnswered} className="h-10 px-6">
        {submitting ? 'Submitting…' : 'Submit quiz'}
      </Button>
    </form>
  )
}
