export type UserRole = 'student' | 'mentor' | 'admin' | 'super_admin'

export interface AuthUser {
  id: string
  email: string
  name: string
  role: UserRole
}
