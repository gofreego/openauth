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
import { groupService } from '../../../services/groupService'
import type { Group, UserGroup } from '../../../apis/proto/openauth/v1/groups'
import type { User } from '../../../apis/proto/openauth/v1/users'

export interface ManageUserGroupsDialogProps {
  open: boolean
  user: User | null
  onClose: () => void
}

export const ManageUserGroupsDialog = ({ open, user, onClose }: ManageUserGroupsDialogProps) => {
  const { showNotification } = useNotification()
  const [userGroups, setUserGroups] = useState<UserGroup[]>([])
  const [allGroups, setAllGroups] = useState<Group[]>([])
  const [selected, setSelected] = useState<Group[]>([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  const load = useCallback(async () => {
    if (!user) return
    setLoading(true)
    try {
      const [groups, all] = await Promise.all([
        groupService.listUserGroups(user.id),
        groupService.list({ limit: 1000, offset: 0, all: true }),
      ])
      setUserGroups(groups.groups || [])
      setAllGroups(all.groups || [])
    } catch (error) {
      showNotification('Failed to load groups', 'error')
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
      await Promise.all(selected.map((g) => groupService.assignUsers(g.id, [user.id])))
      showNotification('Added to groups', 'success')
      setSelected([])
      await load()
    } catch (error) {
      showNotification('Failed to add to groups', 'error')
      console.error(error)
    } finally {
      setSaving(false)
    }
  }

  const handleRemove = async (groupId: string) => {
    if (!user) return
    try {
      await groupService.removeUsers(groupId, [user.id])
      showNotification('Removed from group', 'success')
      await load()
    } catch (error) {
      showNotification('Failed to remove from group', 'error')
      console.error(error)
    }
  }

  const memberIds = new Set(userGroups.map((g) => g.groupId))
  const options = allGroups.filter((g) => !memberIds.has(g.id))

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">Manage Groups</Typography>
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
                getOptionLabel={(o) => `${o.displayName} (${o.name})`}
                isOptionEqualToValue={(o, v) => o.id === v.id}
                renderInput={(params) => <TextField {...params} label="Add to groups" placeholder="Select groups..." />}
              />
              <Button variant="contained" startIcon={<AddIcon />} onClick={handleAssign} disabled={saving || selected.length === 0} sx={{ mt: 1, borderRadius: 2 }}>
                Add
              </Button>
            </Box>

            <Divider sx={{ my: 1 }} />
            <Typography variant="subtitle2" sx={{ mb: 1 }}>Member of ({userGroups.length})</Typography>

            {userGroups.length === 0 ? (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2 }}>Not a member of any group.</Typography>
            ) : (
              <List dense>
                {userGroups.map((g) => (
                  <ListItem
                    key={g.groupId}
                    secondaryAction={
                      <IconButton edge="end" color="error" size="small" onClick={() => handleRemove(g.groupId)} title="Remove" disabled={g.isSystem}>
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    }
                  >
                    <ListItemText primary={g.groupDisplayName || g.groupName} secondary={g.groupName} />
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
