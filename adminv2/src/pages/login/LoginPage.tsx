import { useState, useEffect } from 'react'
import {
  Box,
  Card,
  CardContent,
  TextField,
  Button,
  Typography,
  InputAdornment,
  IconButton,
  CircularProgress,
  Alert,
} from '@mui/material'
import { Visibility, VisibilityOff, Lock, Person } from '@mui/icons-material'
import { useNotification, extractErrorMessage, useTheme } from '@gofreego/tsutils'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { authService, sessionManager } from '../../services'

export function LoginPage() {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [checking, setChecking] = useState(true)
  const [error, setError] = useState('')
  const { showNotification } = useNotification()
  const { theme } = useTheme()
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()

  const redirectUser = async () => {
    const redirectTo = searchParams.get('redirect')
    if (redirectTo) {
      try {
        const { loginToken } = await authService.generateLoginToken()
        const url = new URL(redirectTo)
        url.searchParams.set('login_token', loginToken)
        window.location.href = url.toString()
      } catch {
        sessionManager.getRefreshToken();
        // reload the page
        window.location.reload();
      }
    } else {
      navigate('/home', { replace: true })
    }
  }

  // If already authenticated, redirect immediately without showing the form
  useEffect(() => {
    if (authService.isAuthenticated()) {
      authService.initializeAuth()
      redirectUser().finally(() => setChecking(false))
    } else {
      setChecking(false)
    }
  }, [])

  if (checking) {
    return (
      <Box sx={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: `linear-gradient(135deg, ${theme.colors.primary} 0%, ${theme.colors.primaryActive} 100%)` }}>
        <CircularProgress sx={{ color: '#fff' }} />
      </Box>
    )
  }

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const response = await authService.signIn({
        username,
        password,
        includePermissions: true,
      })
      await redirectUser()
      showNotification(response.message || 'Login successful!', 'success')

    } catch (err: unknown) {

      const message = extractErrorMessage(err)

      setError(message)
      showNotification(message, 'error')
    } finally {
      setLoading(false)
    }
  }

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: `linear-gradient(135deg, ${theme.colors.primary} 0%, ${theme.colors.primaryActive} 100%)`,
        padding: 2,
      }}
    >
      <Card
        sx={{
          maxWidth: 400,
          width: '100%',
          boxShadow: '0 8px 32px rgba(0, 0, 0, 0.2)',
          borderRadius: 2,
        }}
      >
        <CardContent sx={{ padding: 4 }}>
          <Box sx={{ textAlign: 'center', mb: 4 }}>
            <Lock
              sx={{
                fontSize: 48,
                color: 'primary.main',
                mb: 1,
              }}
            />
            <Typography variant="h4" component="h1" fontWeight="bold">
              OpenAuth
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Sign in to your account
            </Typography>
          </Box>

          <form onSubmit={handleLogin}>
            <TextField
              fullWidth
              label="Username / Email / Mobile"
              variant="outlined"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              margin="normal"
              required
              autoComplete="username"
              autoFocus
              slotProps={{
                input: {
                  startAdornment: (
                    <InputAdornment position="start">
                      <Person color="action" />
                    </InputAdornment>
                  ),
                },
              }}
            />

            <TextField
              fullWidth
              label="Password"
              variant="outlined"
              type={showPassword ? 'text' : 'password'}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              margin="normal"
              required
              autoComplete="current-password"
              slotProps={{
                input: {
                  startAdornment: (
                    <InputAdornment position="start">
                      <Lock color="action" />
                    </InputAdornment>
                  ),
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowPassword(!showPassword)}
                        edge="end"
                        aria-label={showPassword ? 'Hide password' : 'Show password'}
                      >
                        {showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                },
              }}
            />

            {error && (
              <Alert severity="error" sx={{ mt: 2 }}>
                {error}
              </Alert>
            )}

            <Button
              type="submit"
              fullWidth
              variant="contained"
              size="large"
              disabled={loading || !username || !password}
              sx={{
                mt: 3,
                mb: 2,
                py: 1.5,
                textTransform: 'none',
                fontSize: '1rem',
              }}
            >
              {loading ? (
                <CircularProgress size={24} color="inherit" />
              ) : (
                'Sign In'
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </Box>
  )
}
