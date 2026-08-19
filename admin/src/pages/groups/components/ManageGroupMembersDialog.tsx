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
  Autocomplete,
  TextField,
  Divider,
} from '@mui/material'
import { Delete as DeleteIcon, Add as AddIcon, Person as PersonIcon } from '@mui/icons-material'
import { useNotification } from '@gofreego/tsutils'
import { groupService } from '../../../services/groupService'
import { userService } from '../../../services/userService'
import type { Group, GroupUser } from '../../../apis/proto/openauth/v1/groups'
import type { User } from '../../../apis/proto/openauth/v1/users'

export interface ManageGroupMembersDialogProps {
  open: boolean
  group: Group | null
  onClose: () => void
}

export const ManageGroupMembersDialog = ({ open, group, onClose }: ManageGroupMembersDialogProps) => {
  const { showNotification } = useNotification()
  const [members, setMembers] = useState<GroupUser[]>([])
  const [allUsers, setAllUsers] = useState<User[]>([])
  const [selected, setSelected] = useState<User[]>([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  const load = useCallback(async () => {
    if (!group) return
    setLoading(true)
    try {
      const [groupUsers, users] = await Promise.all([
        groupService.listGroupUsers(group.id),
        userService.list({ limit: 1000, offset: 0 }),
      ])
      setMembers(groupUsers.users || [])
      setAllUsers(users.users || [])
    } catch (error) {
      showNotification('Failed to load members', 'error')
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
      await groupService.assignUsers(group.id, selected.map((u) => u.id))
      showNotification('Members added', 'success')
      setSelected([])
      await load()
    } catch (error) {
      showNotification('Failed to add members', 'error')
      console.error(error)
    } finally {
      setSaving(false)
    }
  }

  const handleRemove = async (userId: string) => {
    if (!group) return
    try {
      await groupService.removeUsers(group.id, [userId])
      showNotification('Member removed', 'success')
      await load()
    } catch (error) {
      showNotification('Failed to remove member', 'error')
      console.error(error)
    }
  }

  const memberIds = new Set(members.map((m) => m.userId))
  const options = allUsers.filter((u) => !memberIds.has(u.id))

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Typography variant="h6">Manage Members</Typography>
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
                getOptionLabel={(o) => o.name ? `${o.name} (${o.username})` : o.username}
                isOptionEqualToValue={(o, v) => o.id === v.id}
                renderInput={(params) => <TextField {...params} label="Add members" placeholder="Select users..." />}
              />
              <Button variant="contained" startIcon={<AddIcon />} onClick={handleAssign} disabled={saving || selected.length === 0} sx={{ mt: 1, borderRadius: 2 }}>
                Add
              </Button>
            </Box>

            <Divider sx={{ my: 1 }} />
            <Typography variant="subtitle2" sx={{ mb: 1 }}>Members ({members.length})</Typography>

            {members.length === 0 ? (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2 }}>No members in this group.</Typography>
            ) : (
              <List dense>
                {members.map((m) => (
                  <ListItem
                    key={m.userId}
                    secondaryAction={
                      <IconButton edge="end" color="error" size="small" onClick={() => handleRemove(m.userId)} title="Remove">
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    }
                  >
                    <ListItemAvatar>
                      <Avatar src={m.avatar} sx={{ width: 32, height: 32 }}><PersonIcon /></Avatar>
                    </ListItemAvatar>
                    <ListItemText primary={m.name || m.username} secondary={m.email || m.username} />
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
