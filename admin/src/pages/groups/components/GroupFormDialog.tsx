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
import type { Group, CreateGroupRequest, UpdateGroupRequest } from '../../../apis/proto/openauth/v1/groups'

export interface GroupFormDialogProps {
  open: boolean
  initialData?: Group
  onClose: () => void
  onSave: (data: CreateGroupRequest | UpdateGroupRequest) => Promise<void>
}

export const GroupFormDialog = ({ open, initialData, onClose, onSave }: GroupFormDialogProps) => {
  const isEdit = !!initialData
  const [form, setForm] = useState({ name: '', displayName: '', description: '', isDefault: false })
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState<{ name?: string; displayName?: string }>({})

  useEffect(() => {
    if (initialData) {
      setForm({ name: initialData.name || '', displayName: initialData.displayName || '', description: initialData.description || '', isDefault: false })
    } else {
      setForm({ name: '', displayName: '', description: '', isDefault: false })
    }
    setErrors({})
  }, [initialData, open])

  const handleChange = (field: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }))
  }

  const handleSubmit = async () => {
    const newErrors: typeof errors = {}
    if (!form.name) newErrors.name = 'Name is required'
    if (!form.displayName) newErrors.displayName = 'Display name is required'
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors)
      return
    }
    setSaving(true)
    try {
      if (isEdit && initialData) {
        await onSave({ id: initialData.id, name: form.name, displayName: form.displayName, description: form.description })
      } else {
        await onSave({ name: form.name, displayName: form.displayName, description: form.description, isDefault: form.isDefault })
      }
      onClose()
    } catch (error) {
      console.error('Failed to save group:', error)
    } finally {
      setSaving(false)
    }
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">{isEdit ? 'Edit Group' : 'Create Group'}</Typography>
      </DialogTitle>
      <DialogContent>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5, mt: 2.5 }}>
          <TextField label="Name" value={form.name} onChange={handleChange('name')} fullWidth required autoFocus error={!!errors.name} helperText={errors.name} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Display Name" value={form.displayName} onChange={handleChange('displayName')} fullWidth required error={!!errors.displayName} helperText={errors.displayName} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Description" value={form.description} onChange={handleChange('description')} fullWidth multiline rows={3} slotProps={{ inputLabel: { shrink: true } }} />
          {!isEdit && (
            <FormControlLabel
              control={<Switch checked={form.isDefault} onChange={(e) => setForm((p) => ({ ...p, isDefault: e.target.checked }))} />}
              label="Assign to new users by default"
            />
          )}
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} disabled={saving}>Cancel</Button>
        <Button onClick={handleSubmit} variant="contained" disabled={saving || !form.name || !form.displayName}>
          {saving ? 'Saving...' : 'Save'}
        </Button>
      </DialogActions>
    </Dialog>
  )
}
