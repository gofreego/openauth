import { ThemeProvider, NotificationProvider } from '@gofreego/tsutils'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { LoginPage } from './pages/login/LoginPage'
import { HomePage } from './pages/home/HomePage'
import { authService } from './services/authService'
import type { ReactElement } from 'react'

function ProtectedRoute({ children }: { children: ReactElement }) {
  return authService.isAuthenticated() ? children : <Navigate to="/auth/login" replace />
}

function App() {
  authService.initializeAuth()

  return (
    <ThemeProvider>
      <NotificationProvider>
        <BrowserRouter >
          <Routes>
            <Route path="/auth/login" element={<LoginPage />} />
              <Route path="/home" element={<ProtectedRoute><HomePage/></ProtectedRoute>} />
            <Route path="*" element={<Navigate to="/home" replace />} />
          </Routes>
        </BrowserRouter>
      </NotificationProvider>
    </ThemeProvider>
  )
}

export default App
