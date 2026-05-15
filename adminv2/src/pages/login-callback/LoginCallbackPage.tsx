import { useEffect } from 'react'
import { Box, CircularProgress, Typography } from '@mui/material'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { extractErrorMessage, useTheme } from '@gofreego/tsutils'
import type { IAuthService } from '@gofreego/tsutils'

interface LoginCallbackPageProps {
  authService: IAuthService
  navigateTo?: string
}

export function LoginCallbackPage({ authService, navigateTo = '/home' }: LoginCallbackPageProps) {
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()
  const { theme } = useTheme()

  useEffect(() => {
    const loginToken = searchParams.get('login_token')

    if (!loginToken) {
        console.error('Login callback failed: Missing login_token in query parameters')
      navigate('/auth/login', { replace: true })
      return
    }
    authService
      .signInWithLoginToken({ loginToken })
      .then(() => {
        navigate(navigateTo, { replace: true })
      })
      .catch((err: unknown) => {
        console.error('Login callback failed:', extractErrorMessage(err))
        navigate('/auth/login', { replace: true })
      })
  }, [])

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        background: `linear-gradient(135deg, ${theme.colors.primary} 0%, ${theme.colors.primaryActive} 100%)`,
        gap: 2,
      }}
    >
      <CircularProgress sx={{ color: theme.colors.surface }} />
      <Typography variant="body2" sx={{ color: theme.colors.surface, opacity: 0.85 }}>
        Signing you in…
      </Typography>
    </Box>
  )
}
