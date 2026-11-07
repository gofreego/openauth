import { useMemo, useState } from 'react'
import {
  Alert,
  Box,
  Button,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Stack,
  TextField,
  Typography,
} from '@mui/material'
import type { BulkCreatePermissionsResponse, CreatePermissionRequest } from '../../../apis/proto/openauth/v1/permissions'
import { permissionService } from '../../../services/permissionService'

/** The server's message from an error (grpc-gateway: { message }), or [fallback]. */
const errorMessage = (e: unknown, fallback: string) => {
  const data = (e as { data?: { message?: unknown } })?.data
  return typeof data?.message === 'string' && data.message ? data.message : fallback
}

const EXAMPLE = `[
  "openpay:products:read",
  { "name": "openpay:products:write", "displayName": "Write products", "description": "Create and edit products" }
]`

/** "openpay:products:read" → "Openpay Products Read", for entries given as just a name. */
const displayNameFor = (name: string) =>
  name
    .split(/[:._\-\s]+/)
    .filter(Boolean)
    .map((w) => w[0].toUpperCase() + w.slice(1))
    .join(' ')

/**
 * Reads the pasted JSON: an array (or { "permissions": [...] }) of names, or of objects with
 * name, displayName (or display_name) and description. A missing display name is made from
 * the name.
 */
const parsePermissions = (text: string): CreatePermissionRequest[] => {
  const parsed: unknown = JSON.parse(text)
  const list = Array.isArray(parsed) ? parsed : (parsed as { permissions?: unknown })?.permissions
  if (!Array.isArray(list)) throw new Error('Expected a JSON array, or an object with a "permissions" array')
  return list.map((item, i) => {
    if (typeof item === 'string') return { name: item.trim(), displayName: displayNameFor(item.trim()) }
    if (!item || typeof item !== 'object') throw new Error(`Entry ${i + 1} is neither a name nor an object`)
    const o = item as Record<string, unknown>
    const name = typeof o.name === 'string' ? o.name.trim() : ''
    if (!name) throw new Error(`Entry ${i + 1} has no "name"`)
    const display = o.displayName ?? o.display_name
    const description = typeof o.description === 'string' && o.description.trim() ? o.description.trim() : undefined
    return {
      name,
      displayName: typeof display === 'string' && display.trim() ? display.trim() : displayNameFor(name),
      ...(description && { description }),
    }
  })
}

export interface BulkPermissionsDialogProps {
  open: boolean
  onClose: () => void
  /** After a run that created any. */
  onCreated: () => void
}

export const BulkPermissionsDialog = ({ open, onClose, onCreated }: BulkPermissionsDialogProps) => {
  const [text, setText] = useState('')
  const [saving, setSaving] = useState(false)
  const [result, setResult] = useState<BulkCreatePermissionsResponse | null>(null)
  const [error, setError] = useState<string | null>(null)

  const parsed = useMemo(() => {
    if (!text.trim()) return { items: [] as CreatePermissionRequest[], error: null }
    try {
      return { items: parsePermissions(text), error: null }
    } catch (e) {
      return { items: [] as CreatePermissionRequest[], error: (e as Error).message }
    }
  }, [text])

  const close = () => {
    setText('')
    setResult(null)
    setError(null)
    onClose()
  }

  const submit = async () => {
    setSaving(true)
    setError(null)
    try {
      const res = await permissionService.bulkCreate(parsed.items)
      setResult(res)
      if ((res.created ?? []).length > 0) onCreated()
    } catch (e) {
      setError(errorMessage(e, 'Failed to create the permissions'))
    } finally {
      setSaving(false)
    }
  }

  const created = result?.created ?? []
  const skipped = result?.skipped ?? []
  const failed = result?.failed ?? []

  return (
    <Dialog open={open} onClose={close} maxWidth="md" fullWidth>
      <DialogTitle>Create permissions in bulk</DialogTitle>
      <DialogContent>
        {!result ? (
          <Stack spacing={2} sx={{ mt: 1 }}>
            <Typography variant="body2" color="text.secondary">
              Paste a JSON array of permission names, or of objects with <code>name</code>, <code>displayName</code>{' '}
              and <code>description</code>. A missing display name is made from the name. Names that exist already
              are skipped. Up to 500 at a time.
            </Typography>
            <TextField
              multiline
              minRows={10}
              maxRows={22}
              placeholder={EXAMPLE}
              value={text}
              onChange={(e) => setText(e.target.value)}
              error={!!parsed.error}
              helperText={parsed.error ?? (parsed.items.length ? `${parsed.items.length} permissions` : ' ')}
              InputProps={{ sx: { fontFamily: 'monospace', fontSize: 13 } }}
              fullWidth
            />
            {parsed.items.length > 0 && (
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, maxHeight: 140, overflow: 'auto' }}>
                {parsed.items.map((p, i) => (
                  <Chip key={`${p.name}-${i}`} size="small" label={p.name} title={p.displayName} />
                ))}
              </Box>
            )}
            {error && <Alert severity="error">{error}</Alert>}
          </Stack>
        ) : (
          <Stack spacing={2} sx={{ mt: 1 }}>
            <Alert severity={failed.length ? 'warning' : 'success'}>
              {created.length} created · {skipped.length} skipped (already there) · {failed.length} failed
            </Alert>
            {failed.length > 0 && (
              <Box>
                <Typography variant="subtitle2" gutterBottom>
                  Failed
                </Typography>
                {failed.map((f) => (
                  <Typography key={f.name} variant="body2" sx={{ fontFamily: 'monospace' }}>
                    {f.name}: {f.error}
                  </Typography>
                ))}
              </Box>
            )}
            {skipped.length > 0 && (
              <Box>
                <Typography variant="subtitle2" gutterBottom>
                  Skipped
                </Typography>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                  {skipped.map((name, i) => (
                    <Chip key={`${name}-${i}`} size="small" variant="outlined" label={name} />
                  ))}
                </Box>
              </Box>
            )}
          </Stack>
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={close}>{result ? 'Done' : 'Cancel'}</Button>
        {!result && (
          <Button variant="contained" onClick={() => void submit()} disabled={saving || !parsed.items.length || !!parsed.error}>
            {saving ? 'Creating…' : `Create ${parsed.items.length || ''}`}
          </Button>
        )}
      </DialogActions>
    </Dialog>
  )
}
