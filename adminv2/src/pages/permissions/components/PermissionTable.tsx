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
import { Edit as EditIcon, Delete as DeleteIcon } from '@mui/icons-material'
import type { Permission } from '../../../apis/proto/openauth/v1/permissions'

export interface PermissionTableProps {
  permissions: Permission[]
  loading: boolean
  loadingMore: boolean
  onEdit: (permission: Permission) => void
  onDelete: (permission: Permission) => void
}

export const PermissionTable = ({ permissions, loading, loadingMore, onEdit, onDelete }: PermissionTableProps) => {
  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
        <CircularProgress />
      </Box>
    )
  }

  if (permissions.length === 0) {
    return (
      <Box sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="body1" color="textSecondary">No permissions found.</Typography>
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
            {permissions.map((p) => (
              <TableRow key={p.id} hover>
                <TableCell sx={{ fontFamily: 'monospace' }}>{p.name}</TableCell>
                <TableCell sx={{ fontWeight: 500 }}>{p.displayName}</TableCell>
                <TableCell sx={{ color: 'text.secondary', maxWidth: 300 }}>{p.description || '-'}</TableCell>
                <TableCell>
                  <Chip size="small" label={p.isSystem ? 'System' : 'Custom'} color={p.isSystem ? 'default' : 'primary'} />
                </TableCell>
                <TableCell align="right">
                  <IconButton size="small" onClick={() => onEdit(p)} color="primary" title="Edit" disabled={p.isSystem}>
                    <EditIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={() => onDelete(p)} color="error" title="Delete" disabled={p.isSystem}>
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
