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
  MenuItem,
  FormControlLabel,
  Switch,
} from '@mui/material'
import { ValueType } from '../../../apis/proto/openauth/v1/configs'
import type { Config, CreateConfigRequest, UpdateConfigRequest } from '../../../apis/proto/openauth/v1/configs'
import { VALUE_TYPE_OPTIONS, displayValue, buildValueFields } from '../utils/configValue'

export interface ConfigFormDialogProps {
  open: boolean
  entityId: string
  initialData?: Config
  onClose: () => void
  onSave: (data: CreateConfigRequest | UpdateConfigRequest) => Promise<void>
}

export const ConfigFormDialog = ({ open, entityId, initialData, onClose, onSave }: ConfigFormDialogProps) => {
  const isEdit = !!initialData
  const [form, setForm] = useState({
    key: '',
    displayName: '',
    description: '',
    type: ValueType.VALUE_TYPE_STRING,
    value: '',
  })
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState<{ key?: string }>({})

  useEffect(() => {
    if (initialData) {
      setForm({
        key: initialData.key || '',
        displayName: initialData.displayName || '',
        description: initialData.description || '',
        type: initialData.type ?? ValueType.VALUE_TYPE_STRING,
        value: displayValue(initialData),
      })
    } else {
      setForm({ key: '', displayName: '', description: '', type: ValueType.VALUE_TYPE_STRING, value: '' })
    }
    setErrors({})
  }, [initialData, open])

  const handleSubmit = async () => {
    if (!form.key) {
      setErrors({ key: 'Key is required' })
      return
    }
    setSaving(true)
    try {
      const valueFields = buildValueFields(form.type, form.value)
      if (isEdit && initialData) {
        await onSave({
          id: initialData.id,
          displayName: form.displayName,
          description: form.description,
          ...valueFields,
        })
      } else {
        await onSave({
          entityId,
          key: form.key,
          displayName: form.displayName,
          description: form.description,
          type: form.type,
          ...valueFields,
        })
      }
      onClose()
    } catch (error) {
      console.error('Failed to save config:', error)
    } finally {
      setSaving(false)
    }
  }

  const renderValueField = () => {
    if (form.type === ValueType.VALUE_TYPE_BOOL) {
      return (
        <FormControlLabel
          control={<Switch checked={form.value === 'true'} onChange={(e) => setForm((p) => ({ ...p, value: e.target.checked ? 'true' : 'false' }))} />}
          label="Value"
        />
      )
    }
    return (
      <TextField
        label="Value"
        value={form.value}
        onChange={(e) => setForm((p) => ({ ...p, value: e.target.value }))}
        fullWidth
        multiline={form.type === ValueType.VALUE_TYPE_JSON}
        rows={form.type === ValueType.VALUE_TYPE_JSON ? 4 : 1}
        type={form.type === ValueType.VALUE_TYPE_INT || form.type === ValueType.VALUE_TYPE_FLOAT ? 'number' : 'text'}
        slotProps={{ inputLabel: { shrink: true } }}
      />
    )
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">{isEdit ? 'Edit Config' : 'Create Config'}</Typography>
      </DialogTitle>
      <DialogContent>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5, mt: 2.5 }}>
          <TextField label="Key" value={form.key} onChange={(e) => setForm((p) => ({ ...p, key: e.target.value }))} fullWidth required autoFocus disabled={isEdit} error={!!errors.key} helperText={errors.key} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Display Name" value={form.displayName} onChange={(e) => setForm((p) => ({ ...p, displayName: e.target.value }))} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="Description" value={form.description} onChange={(e) => setForm((p) => ({ ...p, description: e.target.value }))} fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField
            select
            label="Type"
            value={form.type}
            onChange={(e) => setForm((p) => ({ ...p, type: Number(e.target.value) as ValueType, value: '' }))}
            fullWidth
            disabled={isEdit}
            slotProps={{ inputLabel: { shrink: true } }}
          >
            {VALUE_TYPE_OPTIONS.map((o) => (
              <MenuItem key={o.value} value={o.value}>{o.label}</MenuItem>
            ))}
          </TextField>
          {renderValueField()}
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} disabled={saving}>Cancel</Button>
        <Button onClick={handleSubmit} variant="contained" disabled={saving || !form.key}>
          {saving ? 'Saving...' : 'Save'}
        </Button>
      </DialogActions>
    </Dialog>
  )
}
