import {
  Box,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  IconButton,
  CircularProgress,
  Typography,
  Avatar,
  Chip,
  Stack,
} from '@mui/material'
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Person as PersonIcon,
  VpnKey as VpnKeyIcon,
  Groups as GroupsIcon,
  Devices as DevicesIcon,
  AccountBox as ProfileIcon,
} from '@mui/icons-material'
import type { User } from '../../../apis/proto/openauth/v1/users'

export interface UserTableProps {
  users: User[]
  loading: boolean
  loadingMore: boolean
  onEdit: (user: User) => void
  onDelete: (user: User) => void
  onManagePermissions?: (user: User) => void
  onManageGroups?: (user: User) => void
  onViewSessions?: (user: User) => void
  onViewProfiles?: (user: User) => void
}

export const UserTable = ({
  users,
  loading,
  loadingMore,
  onEdit,
  onDelete,
  onManagePermissions,
  onManageGroups,
  onViewSessions,
  onViewProfiles,
}: UserTableProps) => {
  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
        <CircularProgress />
      </Box>
    )
  }

  if (users.length === 0) {
    return (
      <Box sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="body1" color="textSecondary">
          No users found.
        </Typography>
      </Box>
    )
  }

  return (
    <Box>
      <TableContainer component={Paper} sx={{ borderRadius: 4 }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell sx={{ fontWeight: 600, width: 64 }} />
              <TableCell sx={{ fontWeight: 600 }}>Username</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Email</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Phone</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Status</TableCell>
              <TableCell sx={{ fontWeight: 600 }} align="right">Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {users.map((user) => (
              <TableRow key={user.uuid} hover>
                <TableCell>
                  <Avatar src={user.avatarUrl} alt={user.username} sx={{ width: 36, height: 36 }}>
                    <PersonIcon />
                  </Avatar>
                </TableCell>
                <TableCell sx={{ fontWeight: 500 }}>
                  {user.name || user.username}
                  {user.name && (
                    <Typography variant="caption" color="text.secondary" display="block">
                      {user.username}
                    </Typography>
                  )}
                </TableCell>
                <TableCell>{user.email || '-'}</TableCell>
                <TableCell>{user.phone || '-'}</TableCell>
                <TableCell>
                  <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap>
                    <Chip
                      size="small"
                      label={user.isActive ? 'Active' : 'Inactive'}
                      color={user.isActive ? 'success' : 'default'}
                    />
                    {user.isLocked && <Chip size="small" label="Locked" color="error" />}
                    {user.deactivated && <Chip size="small" label="Deactivated" color="warning" />}
                  </Stack>
                </TableCell>
                <TableCell align="right">
                  {onViewProfiles && (
                    <IconButton size="small" onClick={() => onViewProfiles(user)} color="default" title="Profiles">
                      <ProfileIcon fontSize="small" />
                    </IconButton>
                  )}
                  {onViewSessions && (
                    <IconButton size="small" onClick={() => onViewSessions(user)} color="default" title="Sessions">
                      <DevicesIcon fontSize="small" />
                    </IconButton>
                  )}
                  {onManageGroups && (
                    <IconButton size="small" onClick={() => onManageGroups(user)} color="secondary" title="Groups">
                      <GroupsIcon fontSize="small" />
                    </IconButton>
                  )}
                  {onManagePermissions && (
                    <IconButton size="small" onClick={() => onManagePermissions(user)} color="info" title="Permissions">
                      <VpnKeyIcon fontSize="small" />
                    </IconButton>
                  )}
                  <IconButton size="small" onClick={() => onEdit(user)} color="primary" title="Edit User">
                    <EditIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={() => onDelete(user)} color="error" title="Delete User">
                    <DeleteIcon fontSize="small" />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {loadingMore && (
        <Box sx={{ display: 'flex', justifyContent: 'center', py: 3 }}>
          <CircularProgress />
        </Box>
      )}
    </Box>
  )
}
