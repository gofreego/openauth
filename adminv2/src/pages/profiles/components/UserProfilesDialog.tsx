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
  TextField,
  Divider,
} from '@mui/material'
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Person as PersonIcon,
  ArrowBack as BackIcon,
} from '@mui/icons-material'
import { ConfirmDialog, useNotification } from '@gofreego/tsutils'
import { profileService } from '../../../services/profileService'
import type { User } from '../../../apis/proto/openauth/v1/users'
import type { UserProfile } from '../../../apis/proto/openauth/v1/users'

export interface UserProfilesDialogProps {
  open: boolean
  user: User | null
  onClose: () => void
}

const EMPTY_FORM = {
  profileName: '',
  firstName: '',
  lastName: '',
  displayName: '',
  bio: '',
  avatarUrl: '',
  dateOfBirth: '',
  gender: '',
  country: '',
  city: '',
  websiteUrl: '',
}

type ProfileForm = typeof EMPTY_FORM

export const UserProfilesDialog = ({ open, user, onClose }: UserProfilesDialogProps) => {
  const { showNotification } = useNotification()
  const [profiles, setProfiles] = useState<UserProfile[]>([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [mode, setMode] = useState<'list' | 'form'>('list')
  const [editing, setEditing] = useState<UserProfile | null>(null)
  const [form, setForm] = useState<ProfileForm>(EMPTY_FORM)
  const [deleteUuid, setDeleteUuid] = useState<string>('')

  const load = useCallback(async () => {
    if (!user) return
    setLoading(true)
    try {
      const data = await profileService.listUserProfiles(user.uuid)
      setProfiles(data.profiles || [])
    } catch (error) {
      showNotification('Failed to load profiles', 'error')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }, [user, showNotification])

  useEffect(() => {
    if (open && user) {
      setMode('list')
      setEditing(null)
      load()
    }
  }, [open, user, load])

  const openCreate = () => {
    setEditing(null)
    setForm(EMPTY_FORM)
    setMode('form')
  }

  const openEdit = (p: UserProfile) => {
    setEditing(p)
    setForm({
      profileName: p.profileName || '',
      firstName: p.firstName || '',
      lastName: p.lastName || '',
      displayName: p.displayName || '',
      bio: p.bio || '',
      avatarUrl: p.avatarUrl || '',
      dateOfBirth: p.dateOfBirth || '',
      gender: p.gender || '',
      country: p.country || '',
      city: p.city || '',
      websiteUrl: p.websiteUrl || '',
    })
    setMode('form')
  }

  const handleChange = (field: keyof ProfileForm) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }))
  }

  const handleSubmit = async () => {
    if (!user) return
    setSaving(true)
    try {
      if (editing) {
        await profileService.update({ profileUuid: editing.uuid, ...form, metadata: new Uint8Array() })
        showNotification('Profile updated', 'success')
      } else {
        await profileService.create({ userId: user.id, ...form, metadata: new Uint8Array() })
        showNotification('Profile created', 'success')
      }
      setMode('list')
      await load()
    } catch (error) {
      showNotification('Failed to save profile', 'error')
      console.error(error)
    } finally {
      setSaving(false)
    }
  }

  const handleConfirmDelete = async () => {
    if (!deleteUuid) return
    try {
      await profileService.delete(deleteUuid)
      showNotification('Profile deleted', 'success')
      setDeleteUuid('')
      await load()
    } catch (error) {
      showNotification('Failed to delete profile', 'error')
      console.error(error)
    }
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth slotProps={{ paper: { sx: { borderRadius: 4 } } }}>
      <DialogTitle>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
          {mode === 'form' && (
            <IconButton size="small" onClick={() => setMode('list')} title="Back"><BackIcon /></IconButton>
          )}
          <Box>
            <Typography variant="h6">{mode === 'form' ? (editing ? 'Edit Profile' : 'Create Profile') : 'Profiles'}</Typography>
            {user && <Typography variant="body2" color="text.secondary">{user.name || user.username}</Typography>}
          </Box>
        </Box>
      </DialogTitle>
      <DialogContent dividers>
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}><CircularProgress /></Box>
        ) : mode === 'list' ? (
          <>
            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mb: 1 }}>
              <Button startIcon={<AddIcon />} onClick={openCreate} sx={{ borderRadius: 2 }}>Add Profile</Button>
            </Box>
            <Divider sx={{ mb: 1 }} />
            {profiles.length === 0 ? (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2 }}>No profiles found.</Typography>
            ) : (
              <List dense>
                {profiles.map((p) => (
                  <ListItem
                    key={p.uuid}
                    secondaryAction={
                      <>
                        <IconButton edge="end" color="primary" size="small" onClick={() => openEdit(p)} title="Edit"><EditIcon fontSize="small" /></IconButton>
                        <IconButton edge="end" color="error" size="small" onClick={() => setDeleteUuid(p.uuid)} title="Delete"><DeleteIcon fontSize="small" /></IconButton>
                      </>
                    }
                  >
                    <ListItemAvatar>
                      <Avatar src={p.avatarUrl} sx={{ width: 36, height: 36 }}><PersonIcon /></Avatar>
                    </ListItemAvatar>
                    <ListItemText
                      primary={p.displayName || p.profileName || `${p.firstName || ''} ${p.lastName || ''}`.trim() || 'Profile'}
                      secondary={p.bio || [p.city, p.country].filter(Boolean).join(', ') || '-'}
                    />
                  </ListItem>
                ))}
              </List>
            )}
          </>
        ) : (
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 1 }}>
            <TextField label="Profile Name" value={form.profileName} onChange={handleChange('profileName')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
            <Box sx={{ display: 'flex', gap: 2 }}>
              <TextField label="First Name" value={form.firstName} onChange={handleChange('firstName')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              <TextField label="Last Name" value={form.lastName} onChange={handleChange('lastName')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
            </Box>
            <TextField label="Display Name" value={form.displayName} onChange={handleChange('displayName')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
            <TextField label="Bio" value={form.bio} onChange={handleChange('bio')} fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} />
            <TextField label="Avatar URL" value={form.avatarUrl} onChange={handleChange('avatarUrl')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
            <Box sx={{ display: 'flex', gap: 2 }}>
              <TextField label="Date of Birth" type="date" value={form.dateOfBirth} onChange={handleChange('dateOfBirth')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              <TextField label="Gender" value={form.gender} onChange={handleChange('gender')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
            </Box>
            <Box sx={{ display: 'flex', gap: 2 }}>
              <TextField label="City" value={form.city} onChange={handleChange('city')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              <TextField label="Country" value={form.country} onChange={handleChange('country')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
            </Box>
            <TextField label="Website URL" value={form.websiteUrl} onChange={handleChange('websiteUrl')} fullWidth slotProps={{ inputLabel: { shrink: true } }} />
          </Box>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        {mode === 'form' ? (
          <>
            <Button onClick={() => setMode('list')} disabled={saving}>Cancel</Button>
            <Button variant="contained" onClick={handleSubmit} disabled={saving}>{saving ? 'Saving...' : 'Save'}</Button>
          </>
        ) : (
          <Button onClick={onClose}>Close</Button>
        )}
      </DialogActions>

      <ConfirmDialog
        open={!!deleteUuid}
        title="Delete Profile"
        message="Are you sure you want to delete this profile?"
        confirmText="Delete"
        cancelText="Cancel"
        confirmColor="error"
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteUuid('')}
      />
    </Dialog>
  )
}
