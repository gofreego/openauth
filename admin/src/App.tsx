import { useEffect, useState } from 'react'
import { ThemeProvider, NotificationProvider, SidebarLayout } from '@gofreego/tsutils'
import { BrowserRouter, Routes, Route, Navigate, useLocation } from 'react-router-dom'
import { Box, Typography } from '@mui/material'
import HomeIcon from '@mui/icons-material/Home'
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
      header={<SidebarHeader />}
    />
  )
}

/**
 * The admin app used to live under /openauth/admin/v2/. Apps still pointing
 * there (e.g. `.../v2/login?redirect=...`) would otherwise fall into the
 * logged-in area's catch-all and lose their query string on the way to
 * /login, so forward them to the same page without /v2, query intact.
 */
function LegacyV2Redirect() {
  const { pathname, search, hash } = useLocation()
  const target = pathname.replace(/^\/v2(?=\/|$)/, '') || '/'
  return <Navigate to={`${target}${search}${hash}`} replace />
}

/**
 * Same sidebar header as the other admins (catalog, payments): a home icon
 * that returns to the admin portal, and this console's name.
 */
function SidebarHeader() {
  return (
    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', p: 2, position: 'relative' }}>
      <HomeIcon
        sx={{ cursor: 'pointer' }}
        onClick={() => window.location.href = '/'}
      />
      <Typography
        variant="h5"
        sx={{
          fontWeight: 'bold',
          color: 'primary.main',
          position: 'absolute',
          left: '50%',
          transform: 'translateX(-50%)',
          fontSize: '1.8rem',
        }}
      >
        OpenAuth
      </Typography>
      <Box sx={{ width: 24 }} />
    </Box>
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
        <BrowserRouter basename="/openauth/admin">
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/v2/*" element={<LegacyV2Redirect />} />
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
