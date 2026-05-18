import { useEffect } from 'react'
import { ThemeProvider, NotificationProvider } from '@gofreego/tsutils'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { LoginPage } from './pages/login/LoginPage'
import { HomePage } from './pages/home/HomePage'
import { authService } from './services'
import { ProtectedRoute } from './router/guards'

function App() {
  useEffect(() => {
    authService.initializeAuth()
  }, [])

  return (
    <ThemeProvider>
      <NotificationProvider>
        <BrowserRouter basename="/openauth/admin/v2">
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/home" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
            <Route path="*" element={<Navigate to="/home" replace />} />
          </Routes>
        </BrowserRouter>
      </NotificationProvider>
    </ThemeProvider>
  )
}

export default App
