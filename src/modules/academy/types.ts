export interface Stage {
  id: string
  course_id: string
  title: string
  order_index: number
  is_hidden: boolean
  is_mvp_active: boolean
}

export interface Module {
  id: string
  stage_id: string
  title: string
  order_index: number
  description: string | null
}

export interface Lesson {
  id: string
  module_id: string
  title: string
  order_index: number
  video_url: string | null
  pdf_url: string | null
  notes: string | null
  lesson_type: string | null
  is_required: boolean
}

export interface StageWithModules extends Stage {
  modules: Module[]
}

export interface ModuleWithLessons extends Module {
  stage: Pick<Stage, 'id' | 'title'>
  lessons: (Lesson & { completed: boolean })[]
}

export interface LessonWithCompletion extends Lesson {
  module: Pick<Module, 'id' | 'title'>
  completed: boolean
}
