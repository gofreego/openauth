import { useState } from 'react'
import {
  Box,
  Container,
  Paper,
  Typography,
  ToggleButton,
  ToggleButtonGroup,
  Button,
  Divider,
  Stack,
  CircularProgress,
} from '@mui/material'
import {
  LightMode as LightIcon,
  DarkMode as DarkIcon,
  SettingsBrightness as SystemIcon,
  Logout as LogoutIcon,
} from '@mui/icons-material'
import { useNavigate } from 'react-router-dom'
import { useTheme, useNotification, extractErrorMessage } from '@gofreego/tsutils'
import type { ThemeMode } from '@gofreego/tsutils'
import { authService } from '../../services'
import { PageHeader } from '../../components'

export const SettingsPage = () => {
  const { themeMode, setThemeMode } = useTheme()
  const { showNotification } = useNotification()
  const navigate = useNavigate()
  const [loggingOut, setLoggingOut] = useState(false)

  const session = authService.getSessionDetails()
  const user = session?.user

  const handleLogout = async () => {
    setLoggingOut(true)
    try {
      await authService.logout({ allSessions: false })
      showNotification('Logged out successfully', 'success')
      navigate('/login', { replace: true })
    } catch (err: unknown) {
      showNotification(extractErrorMessage(err), 'error')
      navigate('/login', { replace: true })
    } finally {
      setLoggingOut(false)
    }
  }

  return (
    <Container maxWidth="md">
      <Box sx={{ py: 4 }}>
        <PageHeader title="Settings" subtitle="Manage your preferences and account." />

        <Paper sx={{ borderRadius: 4, p: 3, mb: 3 }}>
          <Typography variant="h6" gutterBottom>Appearance</Typography>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
            Choose how the admin panel looks.
          </Typography>
          <ToggleButtonGroup
            value={themeMode}
            exclusive
            onChange={(_, value: ThemeMode | null) => value && setThemeMode(value)}
            size="small"
          >
            <ToggleButton value="light"><LightIcon fontSize="small" sx={{ mr: 1 }} /> Light</ToggleButton>
            <ToggleButton value="dark"><DarkIcon fontSize="small" sx={{ mr: 1 }} /> Dark</ToggleButton>
            <ToggleButton value="system"><SystemIcon fontSize="small" sx={{ mr: 1 }} /> System</ToggleButton>
          </ToggleButtonGroup>
        </Paper>

        <Paper sx={{ borderRadius: 4, p: 3 }}>
          <Typography variant="h6" gutterBottom>Account</Typography>
          {user ? (
            <Stack spacing={1} sx={{ mb: 2 }}>
              <Typography variant="body2"><strong>Username:</strong> {user.username}</Typography>
              {user.email && <Typography variant="body2"><strong>Email:</strong> {user.email}</Typography>}
            </Stack>
          ) : (
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>No account information available.</Typography>
          )}
          <Divider sx={{ my: 2 }} />
          <Button
            variant="outlined"
            color="error"
            startIcon={loggingOut ? <CircularProgress size={16} color="inherit" /> : <LogoutIcon />}
            onClick={handleLogout}
            disabled={loggingOut}
            sx={{ borderRadius: 2, textTransform: 'none' }}
          >
            {loggingOut ? 'Logging out...' : 'Logout'}
          </Button>
        </Paper>
      </Box>
    </Container>
  )
}
