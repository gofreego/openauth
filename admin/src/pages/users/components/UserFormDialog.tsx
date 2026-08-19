import { useState, useEffect } from 'react'
import {
  Box,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Typography,
  FormControlLabel,
  Switch,
} from '@mui/material'
import type { User, SignUpRequest, UpdateUserRequest } from '../../../apis/proto/openauth/v1/users'

export interface UserFormDialogProps {
  open: boolean
  initialData?: User
  onClose: () => void
  onSave: (data: SignUpRequest | UpdateUserRequest) => Promise<void>
}

export const UserFormDialog = ({ open, initialData, onClose, onSave }: UserFormDialogProps) => {
  const isEdit = !!initialData
  const [form, setForm] = useState({
    username: '',
    email: '',
    phone: '',
    password: '',
    name: '',
    avatarUrl: '',
    isActive: true,
  })
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState<{ username?: string; password?: string }>({})

  useEffect(() => {
    if (initialData) {
      setForm({
        username: initialData.username || '',
        email: initialData.email || '',
        phone: initialData.phone || '',
        password: '',
        name: initialData.name || '',
        avatarUrl: initialData.avatarUrl || '',
        isActive: initialData.isActive,
      })
    } else {
      setForm({ username: '', email: '', phone: '', password: '', name: '', avatarUrl: '', isActive: true })
    }
    setErrors({})
  }, [initialData, open])

  const handleChange = (field: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }))
  }

  const handleSubmit = async () => {
    const newErrors: typeof errors = {}
    if (!form.username) newErrors.username = 'Username is required'
    if (!isEdit && !form.password) newErrors.password = 'Password is required'
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors)
      return
    }

    setSaving(true)
    try {
      if (isEdit && initialData) {
        const data: UpdateUserRequest = {
          uuid: initialData.uuid,
          username: form.username,
          email: form.email || undefined,
          phone: form.phone || undefined,
          name: form.name || undefined,
          avatarUrl: form.avatarUrl || undefined,
          isActive: form.isActive,
        }
        await onSave(data)
      } else {
        const data: SignUpRequest = {
          username: form.username,
          email: form.email || undefined,
          phone: form.phone || undefined,
          password: form.password,
          name: form.name || undefined,
        }
        await onSave(data)
      }
      onClose()
    } catch (error) {
      console.error('Failed to save user:', error)
    } finally {
      setSaving(false)
    }
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">{isEdit ? 'Edit User' : 'Create User'}</Typography>
      </DialogTitle>
      <DialogContent>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5, mt: 2.5 }}>
          <TextField
            label="Username"
            value={form.username}
            onChange={handleChange('username')}
            fullWidth
            required
            autoFocus
            error={!!errors.username}
            helperText={errors.username}
            slotProps={{ inputLabel: { shrink: true } }}
          />
          <TextField label="Display Name" value={form.name} onChange={handleChange('name')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Email" type="email" value={form.email} onChange={handleChange('email')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Phone" value={form.phone} onChange={handleChange('phone')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
          {!isEdit && (
            <TextField
              label="Password"
              type="password"
              value={form.password}
              onChange={handleChange('password')}
              fullWidth
              required
              error={!!errors.password}
              helperText={errors.password}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          )}
          {isEdit && (
            <>
              <TextField label="Avatar URL" value={form.avatarUrl} onChange={handleChange('avatarUrl')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              <FormControlLabel
                control={<Switch checked={form.isActive} onChange={(e) => setForm((p) => ({ ...p, isActive: e.target.checked }))} />}
                label="Active"
              />
            </>
          )}
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} disabled={saving}>Cancel</Button>
        <Button onClick={handleSubmit} variant="contained" disabled={saving || !form.username}>
          {saving ? 'Saving...' : 'Save'}
        </Button>
      </DialogActions>
    </Dialog>
  )
}
