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
import type { Config } from '../../../apis/proto/openauth/v1/configs'
import { displayValue, valueTypeLabel } from '../utils/configValue'

export interface ConfigTableProps {
  configs: Config[]
  loading: boolean
  onEdit: (config: Config) => void
  onDelete: (config: Config) => void
}

export const ConfigTable = ({ configs, loading, onEdit, onDelete }: ConfigTableProps) => {
  if (loading) {
    return <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}><CircularProgress /></Box>
  }

  if (configs.length === 0) {
    return (
      <Box sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="body1" color="textSecondary">No configs in this entity yet.</Typography>
      </Box>
    )
  }

  return (
    <TableContainer component={Paper} sx={{ borderRadius: 4 }}>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell sx={{ fontWeight: 600 }}>Key</TableCell>
            <TableCell sx={{ fontWeight: 600 }}>Display Name</TableCell>
            <TableCell sx={{ fontWeight: 600 }}>Type</TableCell>
            <TableCell sx={{ fontWeight: 600 }}>Value</TableCell>
            <TableCell sx={{ fontWeight: 600 }} align="right">Actions</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {configs.map((c) => (
            <TableRow key={c.id} hover>
              <TableCell sx={{ fontFamily: 'monospace' }}>{c.key}</TableCell>
              <TableCell>{c.displayName || '-'}</TableCell>
              <TableCell><Chip size="small" label={valueTypeLabel(c.type)} /></TableCell>
              <TableCell sx={{ fontFamily: 'monospace', maxWidth: 280, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                {displayValue(c) || '-'}
              </TableCell>
              <TableCell align="right">
                <IconButton size="small" onClick={() => onEdit(c)} color="primary" title="Edit" disabled={c.isSystem}>
                  <EditIcon fontSize="small" />
                </IconButton>
                <IconButton size="small" onClick={() => onDelete(c)} color="error" title="Delete" disabled={c.isSystem}>
                  <DeleteIcon fontSize="small" />
                </IconButton>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  )
}
