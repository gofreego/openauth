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
  CircularProgress,
  Autocomplete,
  TextField,
  Divider,
} from '@mui/material'
import { Delete as DeleteIcon, Add as AddIcon } from '@mui/icons-material'
import { useNotification } from '@gofreego/tsutils'
import { permissionAssignmentService } from '../../../services/permissionAssignmentService'
import { permissionService } from '../../../services/permissionService'
import type { Group } from '../../../apis/proto/openauth/v1/groups'
import type { EffectivePermission } from '../../../apis/proto/openauth/v1/permission_assignments'
import type { Permission } from '../../../apis/proto/openauth/v1/permissions'

export interface ManageGroupPermissionsDialogProps {
  open: boolean
  group: Group | null
  onClose: () => void
}

export const ManageGroupPermissionsDialog = ({ open, group, onClose }: ManageGroupPermissionsDialogProps) => {
  const { showNotification } = useNotification()
  const [assigned, setAssigned] = useState<EffectivePermission[]>([])
  const [allPermissions, setAllPermissions] = useState<Permission[]>([])
  const [selected, setSelected] = useState<Permission[]>([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  const load = useCallback(async () => {
    if (!group) return
    setLoading(true)
    try {
      const [perms, all] = await Promise.all([
        permissionAssignmentService.listGroupPermissions(group.id),
        permissionService.list({ limit: 1000, offset: 0, all: true }),
      ])
      setAssigned(perms.permissions || [])
      setAllPermissions(all.permissions || [])
    } catch (error) {
      showNotification('Failed to load permissions', 'error')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }, [group, showNotification])

  useEffect(() => {
    if (open && group) {
      setSelected([])
      load()
    }
  }, [open, group, load])

  const handleAssign = async () => {
    if (!group || selected.length === 0) return
    setSaving(true)
    try {
      await permissionAssignmentService.assignPermissionsToGroup(group.id, selected.map((p) => p.id))
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
    if (!group) return
    try {
      await permissionAssignmentService.removePermissionsFromGroup(group.id, [permissionId])
      showNotification('Permission removed', 'success')
      await load()
    } catch (error) {
      showNotification('Failed to remove permission', 'error')
      console.error(error)
    }
  }

  const assignedIds = new Set(assigned.map((e) => e.permissionId))
  const options = allPermissions.filter((p) => !assignedIds.has(p.id))

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">Manage Permissions</Typography>
        {group && <Typography variant="body2" color="text.secondary">{group.displayName}</Typography>}
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
                getOptionLabel={(o) => `${o.displayName} (${o.name})`}
                isOptionEqualToValue={(o, v) => o.id === v.id}
                renderInput={(params) => <TextField {...params} label="Add permissions" placeholder="Select..." />}
              />
              <Button variant="contained" startIcon={<AddIcon />} onClick={handleAssign} disabled={saving || selected.length === 0} sx={{ mt: 1, borderRadius: 2 }}>
                Assign
              </Button>
            </Box>

            <Divider sx={{ my: 1 }} />
            <Typography variant="subtitle2" sx={{ mb: 1 }}>Assigned permissions ({assigned.length})</Typography>

            {assigned.length === 0 ? (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2 }}>No permissions assigned.</Typography>
            ) : (
              <List dense>
                {assigned.map((e) => (
                  <ListItem
                    key={e.permissionId}
                    secondaryAction={
                      <IconButton edge="end" color="error" size="small" onClick={() => handleRemove(e.permissionId)} title="Remove">
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    }
                  >
                    <ListItemText primary={e.permissionDisplayName || e.permissionName} secondary={e.permissionName} />
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
