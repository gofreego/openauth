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
  IconButton,
  Chip,
  CircularProgress,
  Autocomplete,
  TextField,
  Divider,
} from '@mui/material'
import { Delete as DeleteIcon, Add as AddIcon } from '@mui/icons-material'
import { useNotification } from '@gofreego/tsutils'
import { permissionAssignmentService } from '../../../services/permissionAssignmentService'
import { permissionService } from '../../../services/permissionService'
import type { User } from '../../../apis/proto/openauth/v1/users'
import type { EffectivePermission } from '../../../apis/proto/openauth/v1/permission_assignments'
import type { Permission } from '../../../apis/proto/openauth/v1/permissions'

export interface ManageUserPermissionsDialogProps {
  open: boolean
  user: User | null
  onClose: () => void
}

export const ManageUserPermissionsDialog = ({ open, user, onClose }: ManageUserPermissionsDialogProps) => {
  const { showNotification } = useNotification()
  const [effective, setEffective] = useState<EffectivePermission[]>([])
  const [allPermissions, setAllPermissions] = useState<Permission[]>([])
  const [selected, setSelected] = useState<Permission[]>([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  const load = useCallback(async () => {
    if (!user) return
    setLoading(true)
    try {
      const [eff, all] = await Promise.all([
        permissionAssignmentService.getUserEffectivePermissions(user.id),
        permissionService.list({ limit: 1000, offset: 0, all: true }),
      ])
      setEffective(eff.permissions || [])
      setAllPermissions(all.permissions || [])
    } catch (error) {
      showNotification('Failed to load permissions', 'error')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }, [user, showNotification])

  useEffect(() => {
    if (open && user) {
      setSelected([])
      load()
    }
  }, [open, user, load])

  const handleAssign = async () => {
    if (!user || selected.length === 0) return
    setSaving(true)
    try {
      await permissionAssignmentService.assignPermissionsToUser(user.id, selected.map((p) => p.id))
      showNotification('Permissions assigned', 'success')
      setSelected([])
      await load()
    } catch (error) {
      showNotification('Failed to assign permissions', 'error')
      console.error(error)
    } finally {
      setSaving(false)
    }
  }

  const handleRemove = async (permissionId: string) => {
    if (!user) return
    try {
      await permissionAssignmentService.removePermissionsFromUser(user.id, [permissionId])
      showNotification('Permission removed', 'success')
      await load()
    } catch (error) {
      showNotification('Failed to remove permission', 'error')
      console.error(error)
    }
  }

  // Permissions already directly assigned should not appear as options
  const directIds = new Set(effective.filter((e) => e.source === 'direct').map((e) => e.permissionId))
  const options = allPermissions.filter((p) => !directIds.has(p.id))

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">Manage Permissions</Typography>
        {user && <Typography variant="body2" color="text.secondary">{user.name || user.username}</Typography>}
      </DialogTitle>
      <DialogContent dividers>
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}><CircularProgress /></Box>
        ) : (
          <>
            <Box sx={{ display: 'flex', gap: 1, mb: 2, alignItems: 'flex-start' }}>
              <Autocomplete
                multiple
                sx={{ flex: 1 }}
                options={options}
                value={selected}
                onChange={(_, value) => setSelected(value)}
                getOptionLabel={(option) => `${option.displayName} (${option.name})`}
                isOptionEqualToValue={(o, v) => o.id === v.id}
                renderInput={(params) => <TextField {...params} label="Add permissions" placeholder="Select..." />}
              />
              <Button
                variant="contained"
                startIcon={<AddIcon />}
                onClick={handleAssign}
                disabled={saving || selected.length === 0}
                sx={{ mt: 1, borderRadius: 2 }}
              >
                Assign
              </Button>
            </Box>

            <Divider sx={{ my: 1 }} />
            <Typography variant="subtitle2" sx={{ mb: 1 }}>Effective permissions</Typography>

            {effective.length === 0 ? (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2 }}>No permissions assigned.</Typography>
            ) : (
              <List dense>
                {effective.map((e) => (
                  <ListItem
                    key={`${e.permissionId}-${e.source}-${e.groupId ?? ''}`}
                    secondaryAction={
                      e.source === 'direct' ? (
                        <IconButton edge="end" color="error" size="small" onClick={() => handleRemove(e.permissionId)} title="Remove">
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      ) : undefined
                    }
                  >
                    <ListItemText
                      primary={e.permissionDisplayName || e.permissionName}
                      secondary={e.permissionName}
                    />
                    <Chip
                      size="small"
                      label={e.source === 'direct' ? 'Direct' : `Group: ${e.groupDisplayName || e.groupName}`}
                      color={e.source === 'direct' ? 'primary' : 'default'}
                      sx={{ mr: 6 }}
                    />
                  </ListItem>
                ))}
              </List>
            )}
          </>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose}>Close</Button>
      </DialogActions>
    </Dialog>
  )
}
