import type { ReactElement } from 'react'
import { Navigate } from 'react-router-dom'
import { sessionManager } from '../services'

const LOGIN_PATH = import.meta.env.VITE_LOGIN_PATH || '/openauth/auth/login'

/**
 * Redirects unauthenticated users to the login page (VITE_LOGIN_PATH or /openauth/auth/login).
 */
export function ProtectedRoute({ children }: { children: ReactElement }) {
  return sessionManager.isAuthenticated() ? children : <Navigate to={LOGIN_PATH} replace />
}