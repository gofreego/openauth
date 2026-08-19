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
} from '@mui/material'
import type { ConfigEntity, CreateConfigEntityRequest, UpdateConfigEntityRequest } from '../../../apis/proto/openauth/v1/configs'

export interface ConfigEntityFormDialogProps {
  open: boolean
  initialData?: ConfigEntity
  onClose: () => void
  onSave: (data: CreateConfigEntityRequest | UpdateConfigEntityRequest) => Promise<void>
}

export const ConfigEntityFormDialog = ({ open, initialData, onClose, onSave }: ConfigEntityFormDialogProps) => {
  const isEdit = !!initialData
  const [form, setForm] = useState({ name: '', displayName: '', description: '', readPerm: '', writePerm: '' })
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState<{ name?: string; displayName?: string }>({})

  useEffect(() => {
    if (initialData) {
      setForm({
        name: initialData.name || '',
        displayName: initialData.displayName || '',
        description: initialData.description || '',
        readPerm: initialData.readPerm || '',
        writePerm: initialData.writePerm || '',
      })
    } else {
      setForm({ name: '', displayName: '', description: '', readPerm: '', writePerm: '' })
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
        await onSave({ id: initialData.id, ...form })
      } else {
        await onSave({ ...form })
      }
      onClose()
    } catch (error) {
      console.error('Failed to save config entity:', error)
    } finally {
      setSaving(false)
    }
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">{isEdit ? 'Edit Config Entity' : 'Create Config Entity'}</Typography>
      </DialogTitle>
      <DialogContent>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5, mt: 2.5 }}>
          <TextField label="Name" value={form.name} onChange={handleChange('name')} fullWidth required autoFocus error={!!errors.name} helperText={errors.name} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Display Name" value={form.displayName} onChange={handleChange('displayName')} fullWidth required error={!!errors.displayName} helperText={errors.displayName} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Description" value={form.description} onChange={handleChange('description')} fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Read Permission" value={form.readPerm} onChange={handleChange('readPerm')} fullWidth helperText="Permission required to read configs in this entity" slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Write Permission" value={form.writePerm} onChange={handleChange('writePerm')} fullWidth helperText="Permission required to modify configs in this entity" slotProps={{ inputLabel: { shrink: true } }} />
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
