import { useState } from 'react'
import { Box, Button, Typography, Paper, CircularProgress } from '@mui/material'
import { Logout, AdminPanelSettings } from '@mui/icons-material'
import { useNavigate } from 'react-router-dom'
import { useNotification, extractErrorMessage } from '@gofreego/tsutils'
import { authService } from '../../services'

export function HomePage() {
  const navigate = useNavigate()
  const { showNotification } = useNotification()
  const [loggingOut, setLoggingOut] = useState(false)

  const handleLogout = async () => {
    setLoggingOut(true)
    try {
      await authService.logout({ allSessions: false })
      showNotification('Logged out successfully', 'success')
      navigate('/login', { replace: true })
    } catch (err: unknown) {
      showNotification(extractErrorMessage(err), 'error')
      // Navigate anyway since tokens are cleared
      navigate('/login', { replace: true })
    } finally {
      setLoggingOut(false)
    }
  }

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        padding: 2,
      }}
    >
      <Paper
        elevation={8}
        sx={{
          maxWidth: 480,
          width: '100%',
          padding: 6,
          borderRadius: 2,
          textAlign: 'center',
        }}
      >
        <AdminPanelSettings
          sx={{ fontSize: 56, color: 'primary.main', mb: 2 }}
        />
        <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
          Welcome to OpenAuth
        </Typography>
        <Typography variant="body1" color="text.secondary" sx={{ mb: 4 }}>
          You are successfully logged in to the admin panel.
        </Typography>
        <Button
          variant="outlined"
          color="error"
          startIcon={loggingOut ? <CircularProgress size={16} color="inherit" /> : <Logout />}
          onClick={handleLogout}
          disabled={loggingOut}
          sx={{ textTransform: 'none' }}
        >
          {loggingOut ? 'Logging out...' : 'Logout'}
        </Button>
      </Paper>
    </Box>
  )
}
