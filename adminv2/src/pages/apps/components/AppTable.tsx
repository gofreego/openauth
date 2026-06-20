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
  Link,
} from '@mui/material'
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Language as LanguageIcon,
} from '@mui/icons-material'
import type { App } from '../../../apis/proto/openauth/v1/apps'

export interface AppTableProps {
  apps: App[]
  loading: boolean
  loadingMore: boolean
  onEdit: (app: App) => void
  onDelete: (app: App) => void
  onRowClick?: (app: App) => void
}

function formatDate(secondsStr: string): string {
  const seconds = parseInt(secondsStr, 10)
  if (isNaN(seconds) || seconds <= 0) return '-'
  // check if secondsStr is in milliseconds or seconds (if > 30000000000 it is likely ms)
  const isMs = seconds > 30000000000
  const date = new Date(isMs ? seconds : seconds * 1000)
  return date.toLocaleString()
}

export const AppTable = ({
  apps,
  loading,
  loadingMore,
  onEdit,
  onDelete,
  onRowClick,
}: AppTableProps) => {
  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
        <CircularProgress />
      </Box>
    )
  }

  if (apps.length === 0) {
    return (
      <Box sx={{ py: 4, textAlign: 'center' }}>
        <Typography variant="body1" color="textSecondary">
          No apps found. Create your first app to get started.
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
              <TableCell sx={{ fontWeight: 600, width: 80 }}>Logo</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Name</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>URL</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Description</TableCell>
              <TableCell sx={{ fontWeight: 600 }}>Updated At</TableCell>
              <TableCell sx={{ fontWeight: 600 }} align="right">
                Actions
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {apps.map((app) => (
              <TableRow
                key={app.id}
                hover
                onClick={() => onRowClick?.(app)}
                sx={{ cursor: onRowClick ? 'pointer' : 'default' }}
              >
                <TableCell>
                  <Avatar
                    src={app.logoUrl}
                    alt={app.name}
                    variant="rounded"
                    sx={{ width: 40, height: 40 }}
                  >
                    <LanguageIcon />
                  </Avatar>
                </TableCell>
                <TableCell sx={{ fontWeight: 500 }}>{app.name}</TableCell>
                <TableCell>
                  <Link
                    href={app.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    onClick={(e) => e.stopPropagation()}
                    sx={{ wordBreak: 'break-all' }}
                  >
                    {app.url}
                  </Link>
                </TableCell>
                <TableCell sx={{ color: 'text.secondary', maxWidth: 250 }}>
                  {app.description || '-'}
                </TableCell>
                <TableCell>{formatDate(app.updatedAt)}</TableCell>
                <TableCell align="right">
                  <IconButton
                    size="small"
                    onClick={(e) => {
                      e.stopPropagation()
                      onEdit(app)
                    }}
                    color="primary"
                    title="Edit App"
                  >
                    <EditIcon fontSize="small" />
                  </IconButton>
                  <IconButton
                    size="small"
                    onClick={(e) => {
                      e.stopPropagation()
                      onDelete(app)
                    }}
                    color="error"
                    title="Delete App"
                  >
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
