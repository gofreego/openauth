import { useEffect, useState } from 'react'
import { ThemeProvider, NotificationProvider, SidebarLayout } from '@gofreego/tsutils'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { LoginPage } from './pages/login/LoginPage'
import { DashboardPage } from './pages/dashboard/DashboardPage'
import { AppsPage } from './pages/apps/AppsPage'
import { UsersPage } from './pages/users/UsersPage'
import { GroupsPage } from './pages/groups/GroupsPage'
import { PermissionsPage } from './pages/permissions/PermissionsPage'
import { ConfigsPage } from './pages/configs/ConfigsPage'
import { SettingsPage } from './pages/settings/SettingsPage'
import { authService } from './services'
import { ProtectedRoute } from './router/guards'
import DashboardIcon from '@mui/icons-material/Dashboard'
import AppsIcon from '@mui/icons-material/Apps'
import PeopleIcon from '@mui/icons-material/People'
import GroupsIcon from '@mui/icons-material/Groups'
import VpnKeyIcon from '@mui/icons-material/VpnKey'
import TuneIcon from '@mui/icons-material/Tune'
import SettingsIcon from '@mui/icons-material/Settings'

function AdminLayout() {
  const menuItems = [
    { id: 'dashboard', label: 'Dashboard', path: '/dashboard', icon: <DashboardIcon /> },
    { id: 'users', label: 'Users', path: '/users', icon: <PeopleIcon /> },
    { id: 'groups', label: 'Groups', path: '/groups', icon: <GroupsIcon /> },
    { id: 'permissions', label: 'Permissions', path: '/permissions', icon: <VpnKeyIcon /> },
    { id: 'apps', label: 'Apps', path: '/apps', icon: <AppsIcon /> },
    { id: 'configs', label: 'Configs', path: '/configs', icon: <TuneIcon /> },
    { id: 'settings', label: 'Settings', path: '/settings', icon: <SettingsIcon /> },
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
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    authService.initializeAuth();
    setIsInitialized(true);
  }, [])

  if (!isInitialized) {
    // return loading spinner or placeholder
    return <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
      <div>Loading...</div>
    </div>
  }

  return (
    <ThemeProvider>
      <NotificationProvider>
        <BrowserRouter basename="/openauth/admin/v2">
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route element={<ProtectedRoute><AdminLayout /></ProtectedRoute>}>
              <Route path="/dashboard" element={<DashboardPage />} />
              <Route path="/users" element={<UsersPage />} />
              <Route path="/groups" element={<GroupsPage />} />
              <Route path="/permissions" element={<PermissionsPage />} />
              <Route path="/apps" element={<AppsPage />} />
              <Route path="/configs" element={<ConfigsPage />} />
              <Route path="/settings" element={<SettingsPage />} />
              <Route path="*" element={<Navigate to="/dashboard" replace />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </NotificationProvider>
    </ThemeProvider>
  )
}

export default App
