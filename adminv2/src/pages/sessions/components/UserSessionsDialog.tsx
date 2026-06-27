import { useState, useEffect, useCallback } from 'react'
import {
  Box,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Typography,
  List,
  ListItem,
  ListItemText,
  ListItemAvatar,
  Avatar,
  IconButton,
  CircularProgress,
  Chip,
} from '@mui/material'
import {
  PowerSettingsNew as TerminateIcon,
  Computer as ComputerIcon,
  Smartphone as PhoneIcon,
} from '@mui/icons-material'
import { useNotification } from '@gofreego/tsutils'
import { sessionService } from '../../../services/sessionService'
import type { Session } from '../../../apis/proto/openauth/v1/sessions'
import type { User } from '../../../apis/proto/openauth/v1/users'

export interface UserSessionsDialogProps {
  open: boolean
  user: User | null
  onClose: () => void
}

function formatDate(value: string): string {
  if (!value) return '-'
  const num = parseInt(value, 10)
  let date: Date
  if (!isNaN(num) && /^\d+$/.test(value)) {
    date = new Date(num > 30000000000 ? num : num * 1000)
  } else {
    date = new Date(value)
  }
  return isNaN(date.getTime()) ? '-' : date.toLocaleString()
}

export const UserSessionsDialog = ({ open, user, onClose }: UserSessionsDialogProps) => {
  const { showNotification } = useNotification()
  const [sessions, setSessions] = useState<Session[]>([])
  const [loading, setLoading] = useState(false)

  const load = useCallback(async () => {
    if (!user) return
    setLoading(true)
    try {
      const data = await sessionService.listUserSessions(user.uuid)
      setSessions(data.sessions || [])
    } catch (error) {
      showNotification('Failed to load sessions', 'error')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }, [user, showNotification])

  useEffect(() => {
    if (open && user) load()
  }, [open, user, load])

  const handleTerminate = async (session: Session) => {
    try {
      await sessionService.terminate(session.id, session.userId)
      showNotification('Session terminated', 'success')
      await load()
    } catch (error) {
      showNotification('Failed to terminate session', 'error')
      console.error(error)
    }
  }

  const isMobile = (type: string) => /mobile|phone|android|ios/i.test(type)

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">Active Sessions</Typography>
        {user && <Typography variant="body2" color="text.secondary">{user.name || user.username}</Typography>}
      </DialogTitle>
      <DialogContent dividers>
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}><CircularProgress /></Box>
        ) : sessions.length === 0 ? (
          <Typography variant="body2" color="text.secondary" sx={{ py: 2 }}>No sessions found.</Typography>
        ) : (
          <List dense>
            {sessions.map((s) => (
              <ListItem
                key={s.id}
                alignItems="flex-start"
                secondaryAction={
                  s.isActive ? (
                    <IconButton edge="end" color="error" size="small" onClick={() => handleTerminate(s)} title="Terminate">
                      <TerminateIcon fontSize="small" />
                    </IconButton>
                  ) : undefined
                }
              >
                <ListItemAvatar>
                  <Avatar sx={{ width: 36, height: 36 }}>
                    {isMobile(s.deviceType) ? <PhoneIcon /> : <ComputerIcon />}
                  </Avatar>
                </ListItemAvatar>
                <ListItemText
                  primary={
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      {s.deviceName || s.deviceType || 'Unknown device'}
                      <Chip size="small" label={s.isActive ? 'Active' : 'Expired'} color={s.isActive ? 'success' : 'default'} />
                    </Box>
                  }
                  secondary={
                    <>
                      <Typography variant="caption" display="block">IP: {s.ipAddress || '-'} {s.location ? `• ${s.location}` : ''}</Typography>
                      <Typography variant="caption" display="block">Last activity: {formatDate(s.lastActivityAt)}</Typography>
                      <Typography variant="caption" display="block">Expires: {formatDate(s.expiresAt)}</Typography>
                    </>
                  }
                />
              </ListItem>
            ))}
          </List>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose}>Close</Button>
      </DialogActions>
    </Dialog>
  )
}
