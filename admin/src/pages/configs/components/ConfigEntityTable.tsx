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
  Settings as SettingsIcon,
} from '@mui/icons-material'
import type { ConfigEntity } from '../../../apis/proto/openauth/v1/configs'

export interface ConfigEntityTableProps {
  entities: ConfigEntity[]
  loading: boolean
  loadingMore: boolean
  onEdit: (entity: ConfigEntity) => void
  onDelete: (entity: ConfigEntity) => void
  onViewConfigs: (entity: ConfigEntity) => void
}

export const ConfigEntityTable = ({ entities, loading, loadingMore, onEdit, onDelete, onViewConfigs }: ConfigEntityTableProps) => {
  if (loading) {
    return <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}><CircularProgress /></Box>
  }

  if (entities.length === 0) {
    return (
      <Box sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="body1" color="textSecondary">No config entities found.</Typography>
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
            {entities.map((e) => (
              <TableRow key={e.id} hover onClick={() => onViewConfigs(e)} sx={{ cursor: 'pointer' }}>
                <TableCell sx={{ fontFamily: 'monospace' }}>{e.name}</TableCell>
                <TableCell sx={{ fontWeight: 500 }}>{e.displayName}</TableCell>
                <TableCell sx={{ color: 'text.secondary', maxWidth: 300 }}>{e.description || '-'}</TableCell>
                <TableCell>
                  <Chip size="small" label={e.isSystem ? 'System' : 'Custom'} color={e.isSystem ? 'default' : 'primary'} />
                </TableCell>
                <TableCell align="right">
                  <IconButton size="small" onClick={(ev) => { ev.stopPropagation(); onViewConfigs(e) }} color="info" title="View Configs">
                    <SettingsIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={(ev) => { ev.stopPropagation(); onEdit(e) }} color="primary" title="Edit" disabled={e.isSystem}>
                    <EditIcon fontSize="small" />
                  </IconButton>
                  <IconButton size="small" onClick={(ev) => { ev.stopPropagation(); onDelete(e) }} color="error" title="Delete" disabled={e.isSystem}>
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
