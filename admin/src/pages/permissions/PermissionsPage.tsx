import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Box, Container, Button, TextField, InputAdornment } from '@mui/material'
import { Add as AddIcon, Search as SearchIcon } from '@mui/icons-material'
import { ConfirmDialog } from '@gofreego/tsutils'
import { usePermissions } from './hooks/usePermissions'
import { PermissionTable } from './components/PermissionTable'
import { PermissionFormDialog } from './components/PermissionFormDialog'
import type { Permission, CreatePermissionRequest, UpdatePermissionRequest } from '../../apis/proto/openauth/v1/permissions'
import { PageHeader } from '../../components'

export const PermissionsPage = () => {
  const [searchParams, setSearchParams] = useSearchParams()
  const { permissions, loading, loadingMore, hasMore, loadPermissions, createPermission, updatePermission, deletePermission } = usePermissions()

  const [openFormDialog, setOpenFormDialog] = useState(false)
  const [openConfirmDialog, setOpenConfirmDialog] = useState(false)
  const [editData, setEditData] = useState<Permission | undefined>(undefined)
  const [deleteId, setDeleteId] = useState<string>('')
  const [searchInput, setSearchInput] = useState<string>(searchParams.get('search') || '')
  const [searchTerm, setSearchTerm] = useState<string>(searchParams.get('search') || '')

  const LIMIT = 10

  useEffect(() => {
    const params = new URLSearchParams()
    if (searchTerm) params.set('search', searchTerm)
    setSearchParams(params, { replace: true })
  }, [searchTerm, setSearchParams])

  useEffect(() => {
    const timer = setTimeout(() => setSearchTerm(searchInput), 400)
    return () => clearTimeout(timer)
  }, [searchInput])

  useEffect(() => {
    loadPermissions({ limit: LIMIT, offset: 0, search: searchTerm, append: false })
  }, [searchTerm, loadPermissions])

  const reload = () => loadPermissions({ limit: LIMIT, offset: 0, search: searchTerm, append: false })

  const handleEdit = (p: Permission) => {
    setEditData(p)
    setOpenFormDialog(true)
  }

  const handleDeleteClick = (p: Permission) => {
    setDeleteId(p.id)
    setOpenConfirmDialog(true)
  }

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deletePermission(deleteId)
      setOpenConfirmDialog(false)
      setDeleteId('')
      reload()
    }
  }

  const handleSave = async (data: CreatePermissionRequest | UpdatePermissionRequest) => {
    if ('id' in data && data.id) {
      await updatePermission(data as UpdatePermissionRequest)
    } else {
      await createPermission(data as CreatePermissionRequest)
    }
    setEditData(undefined)
    reload()
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ py: 4 }}>
        <PageHeader
          title="Permissions"
          subtitle="Define and manage system permissions."
          action={
            <Button variant="contained" startIcon={<AddIcon />} onClick={() => { setEditData(undefined); setOpenFormDialog(true) }} sx={{ borderRadius: 2 }}>
              Create Permission
            </Button>
          }
        />

        <Box sx={{ mb: 3, display: 'flex', gap: 2, flexWrap: 'wrap', alignItems: 'center' }}>
          <TextField
            size="small"
            placeholder="Search permissions..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            InputProps={{ startAdornment: (<InputAdornment position="start"><SearchIcon /></InputAdornment>) }}
            sx={{ flex: 1, minWidth: 250, maxWidth: 400, '& .MuiOutlinedInput-root': { borderRadius: 4 } }}
          />
          {searchInput && (
            <Button variant="outlined" onClick={() => setSearchInput('')} sx={{ borderRadius: 2 }}>Clear</Button>
          )}
        </Box>

        <PermissionTable
          permissions={permissions}
          loading={loading}
          loadingMore={loadingMore}
          onEdit={handleEdit}
          onDelete={handleDeleteClick}
        />

        {hasMore && (
          <Box sx={{ display: 'flex', justifyContent: 'center', mt: 3 }}>
            <Button variant="outlined" onClick={() => loadPermissions({ limit: LIMIT, offset: permissions.length, search: searchTerm, append: true })} disabled={loadingMore} sx={{ borderRadius: 2 }}>
              Load More
            </Button>
          </Box>
        )}

        <PermissionFormDialog
          open={openFormDialog}
          initialData={editData}
          onClose={() => { setOpenFormDialog(false); setEditData(undefined) }}
          onSave={handleSave}
        />

        <ConfirmDialog
          open={openConfirmDialog}
          title="Delete Permission"
          message="Are you sure you want to delete this permission? This action cannot be undone."
          confirmText="Delete"
          cancelText="Cancel"
          confirmColor="error"
          onConfirm={handleConfirmDelete}
          onCancel={() => setOpenConfirmDialog(false)}
        />
      </Box>
    </Container>
  )
}
