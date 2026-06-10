import type { SupabaseClient } from '@supabase/supabase-js'
import type { Stage, StageWithModules, ModuleWithLessons, LessonWithCompletion } from './types'

export async function getStages(supabase: SupabaseClient): Promise<Stage[]> {
  const { data, error } = await supabase
    .from('stages')
    .select('id, course_id, title, order_index, is_hidden, is_mvp_active')
    .eq('is_mvp_active', true)
    .eq('is_hidden', false)
    .order('order_index', { ascending: true })

  if (error) return []
  return data ?? []
}

export async function getStageWithModules(
  supabase: SupabaseClient,
  stageId: string
): Promise<StageWithModules | null> {
  const { data: stage, error: stageError } = await supabase
    .from('stages')
    .select('id, course_id, title, order_index, is_hidden, is_mvp_active')
    .eq('id', stageId)
    .single()

  if (stageError || !stage) return null

  const { data: modules } = await supabase
    .from('modules')
    .select('id, stage_id, title, order_index, description')
    .eq('stage_id', stageId)
    .order('order_index', { ascending: true })

  return { ...stage, modules: modules ?? [] }
}

export async function getModuleWithLessons(
  supabase: SupabaseClient,
  moduleId: string,
  userId: string
): Promise<ModuleWithLessons | null> {
  const { data: module, error: moduleError } = await supabase
    .from('modules')
    .select('id, stage_id, title, order_index, description, stages(id, title)')
    .eq('id', moduleId)
    .single()

  if (moduleError || !module) return null

  const { data: lessons } = await supabase
    .from('lessons')
    .select('id, module_id, title, order_index, video_url, pdf_url, notes, lesson_type, is_required')
    .eq('module_id', moduleId)
    .order('order_index', { ascending: true })

  const { data: completions } = await supabase
    .from('lesson_completions')
    .select('lesson_id')
    .eq('user_id', userId)

  const completedIds = new Set((completions ?? []).map((c: { lesson_id: string }) => c.lesson_id))

  const stageData = Array.isArray(module.stages) ? module.stages[0] : module.stages

  return {
    id: module.id,
    stage_id: module.stage_id,
    title: module.title,
    order_index: module.order_index,
    description: module.description,
    stage: { id: stageData?.id ?? '', title: stageData?.title ?? '' },
    lessons: (lessons ?? []).map((l) => ({ ...l, completed: completedIds.has(l.id) })),
  }
}

export async function getLessonWithCompletion(
  supabase: SupabaseClient,
  lessonId: string,
  userId: string
): Promise<LessonWithCompletion | null> {
  const { data: lesson, error: lessonError } = await supabase
    .from('lessons')
    .select('id, module_id, title, order_index, video_url, pdf_url, notes, lesson_type, is_required, modules(id, title)')
    .eq('id', lessonId)
    .single()

  if (lessonError || !lesson) return null

  const { data: completion } = await supabase
    .from('lesson_completions')
    .select('id')
    .eq('user_id', userId)
    .eq('lesson_id', lessonId)
    .maybeSingle()

  const moduleData = Array.isArray(lesson.modules) ? lesson.modules[0] : lesson.modules

  return {
    id: lesson.id,
    module_id: lesson.module_id,
    title: lesson.title,
    order_index: lesson.order_index,
    video_url: lesson.video_url,
    pdf_url: lesson.pdf_url,
    notes: lesson.notes,
    lesson_type: lesson.lesson_type,
    is_required: lesson.is_required,
    module: { id: moduleData?.id ?? '', title: moduleData?.title ?? '' },
    completed: !!completion,
  }
}
