import { useState, useEffect, useCallback } from 'react'
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  Avatar,
  Switch,
  TextField,
  InputAdornment,
  CircularProgress,
  Box,
  Typography,
} from '@mui/material'
import { Search as SearchIcon, Person as PersonIcon } from '@mui/icons-material'
import { useNotification } from '@gofreego/tsutils'
import { userService } from '../../../services/userService'
import { appService } from '../../../services/appService'
import type { User } from '../../../apis/proto/openauth/v1/users'
import type { App } from '../../../apis/proto/openauth/v1/apps'

interface ManageAppUsersDialogProps {
  open: boolean
  onClose: () => void
  app: App | null
}

interface UserAppState {
  user: User
  hasApp: boolean
  loading: boolean
  allAppIds: number[]
}

export const ManageAppUsersDialog = ({ open, onClose, app }: ManageAppUsersDialogProps) => {
  const [usersState, setUsersState] = useState<Record<string, UserAppState>>({})
  const [loadingUsers, setLoadingUsers] = useState(false)
  const [search, setSearch] = useState('')
  const { showNotification } = useNotification()

  const loadUsersAndApps = useCallback(async (searchQuery: string) => {
    if (!app) return
    setLoadingUsers(true)
    try {
      // 1. Fetch users
      const usersRes = await userService.list({ limit: 20, offset: 0, search: searchQuery })
      const fetchedUsers = usersRes.users || []

      // 2. Fetch assigned apps for each user to see if they have THIS app
      const newState: Record<string, UserAppState> = {}
      
      await Promise.all(
        fetchedUsers.map(async (user) => {
          try {
            const userAppsRes = await appService.listUserApps({
              userId: user.id as any,
              limit: 100,
              offset: 0,
            })
            const userAppIds = (userAppsRes.apps || []).map(a => Number(a.id))
            const hasApp = userAppIds.includes(Number(app.id))
            
            newState[user.id.toString()] = {
              user,
              hasApp,
              loading: false,
              allAppIds: userAppIds,
            }
          } catch (err) {
            console.error(`Failed to fetch apps for user ${user.id}`, err)
            newState[user.id.toString()] = {
              user,
              hasApp: false,
              loading: false,
              allAppIds: [],
            }
          }
        })
      )

      setUsersState(newState)
    } catch (error) {
      showNotification('Failed to load users', 'error')
      console.error(error)
    } finally {
      setLoadingUsers(false)
    }
  }, [app, showNotification])

  useEffect(() => {
    if (open && app) {
      loadUsersAndApps(search)
    } else {
      setUsersState({})
      setSearch('')
    }
  }, [open, app]) // Intentionally not including search to avoid excessive calls, we will use a submit handler or debounce

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearch(e.target.value)
  }

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    loadUsersAndApps(search)
  }

  const handleToggleApp = async (userIdStr: string) => {
    if (!app) return
    
    const state = usersState[userIdStr]
    if (!state) return

    // Set loading state for this user
    setUsersState(prev => ({
      ...prev,
      [userIdStr]: { ...state, loading: true }
    }))

    try {
      const isCurrentlyAssigned = state.hasApp
      const currentAppId = Number(app.id)
      
      let newAppIds: number[]
      if (isCurrentlyAssigned) {
        // Remove it
        newAppIds = state.allAppIds.filter(id => id !== currentAppId)
      } else {
        // Add it
        newAppIds = [...state.allAppIds, currentAppId]
      }

      await appService.assign({
        userId: state.user.id as any,
        appIds: newAppIds as any,
      })

      setUsersState(prev => ({
        ...prev,
        [userIdStr]: { 
          ...state, 
          hasApp: !isCurrentlyAssigned, 
          allAppIds: newAppIds,
          loading: false 
        }
      }))
      
      showNotification(`Successfully ${isCurrentlyAssigned ? 'removed from' : 'assigned to'} app`, 'success')
    } catch (error) {
      showNotification('Failed to update app assignment', 'error')
      console.error(error)
      setUsersState(prev => ({
        ...prev,
        [userIdStr]: { ...state, loading: false }
      }))
    }
  }

  const usersList = Object.values(usersState)

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle>Manage Users for {app?.name}</DialogTitle>
      <DialogContent dividers>
        <Box component="form" onSubmit={handleSearchSubmit} sx={{ mb: 2 }}>
          <TextField
            fullWidth
            size="small"
            placeholder="Search users..."
            value={search}
            onChange={handleSearchChange}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon fontSize="small" />
                </InputAdornment>
              ),
            }}
          />
        </Box>

        {loadingUsers ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
            <CircularProgress />
          </Box>
        ) : usersList.length === 0 ? (
          <Typography color="text.secondary" textAlign="center" py={4}>
            No users found.
          </Typography>
        ) : (
          <List disablePadding>
            {usersList.map(({ user, hasApp, loading }) => (
              <ListItem 
                key={user.id.toString()}
                divider
                secondaryAction={
                  loading ? (
                    <CircularProgress size={24} />
                  ) : (
                    <Switch
                      edge="end"
                      checked={hasApp}
                      onChange={() => handleToggleApp(user.id.toString())}
                      color="primary"
                    />
                  )
                }
              >
                <ListItemAvatar>
                  <Avatar src={user.avatarUrl}>
                    {!user.avatarUrl && <PersonIcon />}
                  </Avatar>
                </ListItemAvatar>
                <ListItemText 
                  primary={user.name || user.username} 
                  secondary={user.email} 
                />
              </ListItem>
            ))}
          </List>
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} color="inherit">
          Done
        </Button>
      </DialogActions>
    </Dialog>
  )
}
