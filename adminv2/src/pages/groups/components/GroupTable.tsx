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
  Chip,
} from '@mui/material'
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  People as PeopleIcon,
  VpnKey as VpnKeyIcon,
} from '@mui/icons-material'
import type { Group } from '../../../apis/proto/openauth/v1/groups'

export interface GroupTableProps {
  groups: Group[]
  loading: boolean
  loadingMore: boolean
  onEdit: (group: Group) => void
  onDelete: (group: Group) => void
  onManageMembers: (group: Group) => void
  onManagePermissions: (group: Group) => void
}

export const GroupTable = ({ groups, loading, loadingMore, onEdit, onDelete, onManageMembers, onManagePermissions }: GroupTableProps) => {
  if (loading) {
    return <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}><CircularProgress /></Box>
  }

  if (groups.length === 0) {
    return (
      <Box sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="body1" color="textSecondary">No groups found.</Typography>
      </Box>
    )
  }

  return (
    <Box>
      <TableContainer component={Paper} sx={{ borderRadius: 4 }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell sx={{ fontWeight: 600 }}>Name</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Display Name</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Description</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Type</TableCell>
              <TableCell sx={{ fontWeight: 600 }} align="right">Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {groups.map((g) => (
              <TableRow key={g.id} hover>
                <TableCell sx={{ fontFamily: 'monospace' }}>{g.name}</TableCell>
                <TableCell sx={{ fontWeight: 500 }}>{g.displayName}</TableCell>
                <TableCell sx={{ color: 'text.secondary', maxWidth: 300 }}>{g.description || '-'}</TableCell>
                <TableCell>
                  <Chip size="small" label={g.isSystem ? 'System' : 'Custom'} color={g.isSystem ? 'default' : 'primary'} />
                </TableCell>
                <TableCell align="right">
                  <IconButton size="small" onClick={() => onManageMembers(g)} color="secondary" title="Manage Members">
                    <PeopleIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={() => onManagePermissions(g)} color="info" title="Manage Permissions">
                    <VpnKeyIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={() => onEdit(g)} color="primary" title="Edit" disabled={g.isSystem}>
                    <EditIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={() => onDelete(g)} color="error" title="Delete" disabled={g.isSystem}>
                    <DeleteIcon fontSize="small" />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {loadingMore && <Box sx={{ display: 'flex', justifyContent: 'center', py: 3 }}><CircularProgress /></Box>}
    </Box>
  )
}
