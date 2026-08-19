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
import type { CreateAppRequest, UpdateAppRequest } from '../../../apis/proto/openauth/v1/apps'

export interface AppFormDialogProps {
  open: boolean
  initialData?: UpdateAppRequest
  onClose: () => void
  onSave: (data: CreateAppRequest | UpdateAppRequest) => Promise<void>
}

export const AppFormDialog = ({
  open,
  initialData,
  onClose,
  onSave,
}: AppFormDialogProps) => {
  const [formData, setFormData] = useState<CreateAppRequest & { id?: string }>({
    name: '',
    description: '',
    url: '',
    logoUrl: '',
  })
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState<{ name?: string; url?: string }>({})

  useEffect(() => {
    if (initialData) {
      setFormData({
        id: initialData.id,
        name: initialData.name || '',
        description: initialData.description || '',
        url: initialData.url || '',
        logoUrl: initialData.logoUrl || '',
      })
    } else {
      setFormData({
        name: '',
        description: '',
        url: '',
        logoUrl: '',
      })
    }
    setErrors({})
  }, [initialData, open])

  const handleChange = (field: keyof CreateAppRequest) => (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const value = event.target.value
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }))

    // Basic validation
    if (field === 'name') {
      if (!value) {
        setErrors((prev) => ({ ...prev, name: 'Name is required' }))
      } else {
        setErrors((prev) => {
          const copy = { ...prev }
          delete copy.name
          return copy
        })
      }
    }

    if (field === 'url') {
      if (!value) {
        setErrors((prev) => ({ ...prev, url: 'URL is required' }))
      } else {
        setErrors((prev) => {
          const copy = { ...prev }
          delete copy.url
          return copy
        })
      }
    }
  }

  const handleSubmit = async () => {
    // Validate again
    const newErrors: { name?: string; url?: string } = {}
    if (!formData.name) newErrors.name = 'Name is required'
    if (!formData.url) newErrors.url = 'URL is required'

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors)
      return
    }

    setSaving(true)
    try {
      if (initialData?.id) {
        await onSave({
          id: initialData.id,
          name: formData.name,
          description: formData.description,
          url: formData.url,
          logoUrl: formData.logoUrl,
        })
      } else {
        await onSave({
          name: formData.name,
          description: formData.description,
          url: formData.url,
          logoUrl: formData.logoUrl,
        })
      }
      onClose()
    } catch (error) {
      console.error('Failed to save app:', error)
    } finally {
      setSaving(false)
    }
  }

  return (
    <Dialog
      open={open}
      onClose={onClose}
      maxWidth="sm"
      fullWidth
      slotProps={{
        paper: { sx: { borderRadius: 4 } },
      }}
    >
      <DialogTitle>
        <Typography variant="h6">
          {initialData?.id ? 'Edit App' : 'Create App'}
        </Typography>
      </DialogTitle>
      <DialogContent>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5, mt: 2.5 }}>
          <TextField
            label="App Name"
            value={formData.name}
            onChange={handleChange('name')}
            fullWidth
            required
            autoFocus
            error={!!errors.name}
            helperText={errors.name}
            slotProps={{
              inputLabel: { shrink: true },
            }}
          />
          <TextField
            label="App URL"
            value={formData.url}
            onChange={handleChange('url')}
            fullWidth
            required
            error={!!errors.url}
            helperText={errors.url || 'The redirect URL or homepage of the application'}
            slotProps={{
              inputLabel: { shrink: true },
            }}
          />
          <TextField
            label="Description"
            value={formData.description}
            onChange={handleChange('description')}
            fullWidth
            multiline
            rows={3}
            slotProps={{
              inputLabel: { shrink: true },
            }}
          />
          <TextField
            label="Logo URL"
            value={formData.logoUrl}
            onChange={handleChange('logoUrl')}
            fullWidth
            helperText="Optional URL to the application logo image"
            slotProps={{
              inputLabel: { shrink: true },
            }}
          />
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} disabled={saving}>
          Cancel
        </Button>
        <Button
          onClick={handleSubmit}
          variant="contained"
          disabled={saving || !formData.name || !formData.url}
        >
          {saving ? 'Saving...' : 'Save'}
        </Button>
      </DialogActions>
    </Dialog>
  )
}
