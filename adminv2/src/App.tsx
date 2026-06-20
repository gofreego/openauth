import { useEffect } from 'react'
import { ThemeProvider, NotificationProvider, SidebarLayout } from '@gofreego/tsutils'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { LoginPage } from './pages/login/LoginPage'
import { HomePage } from './pages/home/HomePage'
import { AppsPage } from './pages/apps/AppsPage'
import { authService } from './services'
import { ProtectedRoute } from './router/guards'
import HomeIcon from '@mui/icons-material/Home'
import AppsIcon from '@mui/icons-material/Apps'

function AdminLayout() {
  const menuItems = [
    {
      id: 'home',
      label: 'Home',
      path: '/home',
      icon: <HomeIcon />,
    },
    {
      id: 'apps',
      label: 'Apps',
      path: '/apps',
      icon: <AppsIcon />,
    },
  ]

  return (
    <SidebarLayout
      menuItems={menuItems}
      isRouter={true}
      isBrowserRouter={false}
      style={{ height: '100vh' }}
    />
  )
}

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
            <Route element={<ProtectedRoute><AdminLayout /></ProtectedRoute>}>
              <Route path="/home" element={<HomePage />} />
              <Route path="/apps" element={<AppsPage />} />
              <Route path="*" element={<Navigate to="/home" replace />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </NotificationProvider>
    </ThemeProvider>
  )
}

export default App
