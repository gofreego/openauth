import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Box, Container, Button, TextField, InputAdornment } from '@mui/material'
import { Add as AddIcon, Search as SearchIcon } from '@mui/icons-material'
import { ConfirmDialog } from '@gofreego/tsutils'
import { useGroups } from './hooks/useGroups'
import { GroupTable } from './components/GroupTable'
import { GroupFormDialog } from './components/GroupFormDialog'
import { ManageGroupMembersDialog } from './components/ManageGroupMembersDialog'
import { ManageGroupPermissionsDialog } from './components/ManageGroupPermissionsDialog'
import type { Group, CreateGroupRequest, UpdateGroupRequest } from '../../apis/proto/openauth/v1/groups'
import { PageHeader } from '../../components'

export const GroupsPage = () => {
  const [searchParams, setSearchParams] = useSearchParams()
  const { groups, loading, loadingMore, hasMore, loadGroups, createGroup, updateGroup, deleteGroup } = useGroups()

  const [openFormDialog, setOpenFormDialog] = useState(false)
  const [openConfirmDialog, setOpenConfirmDialog] = useState(false)
  const [editData, setEditData] = useState<Group | undefined>(undefined)
  const [deleteId, setDeleteId] = useState<string>('')
  const [searchInput, setSearchInput] = useState<string>(searchParams.get('search') || '')
  const [searchTerm, setSearchTerm] = useState<string>(searchParams.get('search') || '')

  const [membersGroup, setMembersGroup] = useState<Group | null>(null)
  const [permissionsGroup, setPermissionsGroup] = useState<Group | null>(null)

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
    loadGroups({ limit: LIMIT, offset: 0, search: searchTerm, append: false })
  }, [searchTerm, loadGroups])

  const reload = () => loadGroups({ limit: LIMIT, offset: 0, search: searchTerm, append: false })

  const handleEdit = (g: Group) => {
    setEditData(g)
    setOpenFormDialog(true)
  }

  const handleDeleteClick = (g: Group) => {
    setDeleteId(g.id)
    setOpenConfirmDialog(true)
  }

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteGroup(deleteId)
      setOpenConfirmDialog(false)
      setDeleteId('')
      reload()
    }
  }

  const handleSave = async (data: CreateGroupRequest | UpdateGroupRequest) => {
    if ('id' in data && data.id) {
      await updateGroup(data as UpdateGroupRequest)
    } else {
      await createGroup(data as CreateGroupRequest)
    }
    setEditData(undefined)
    reload()
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ py: 4 }}>
        <PageHeader
          title="Groups"
          subtitle="Organize users into groups and assign group permissions."
          action={
            <Button variant="contained" startIcon={<AddIcon />} onClick={() => { setEditData(undefined); setOpenFormDialog(true) }} sx={{ borderRadius: 2 }}>
              Create Group
            </Button>
          }
        />

        <Box sx={{ mb: 3, display: 'flex', gap: 2, flexWrap: 'wrap', alignItems: 'center' }}>
          <TextField
            size="small"
            placeholder="Search groups..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            InputProps={{ startAdornment: (<InputAdornment position="start"><SearchIcon /></InputAdornment>) }}
            sx={{ flex: 1, minWidth: 250, maxWidth: 400, '& .MuiOutlinedInput-root': { borderRadius: 4 } }}
          />
          {searchInput && (
            <Button variant="outlined" onClick={() => setSearchInput('')} sx={{ borderRadius: 2 }}>Clear</Button>
          )}
        </Box>

        <GroupTable
          groups={groups}
          loading={loading}
          loadingMore={loadingMore}
          onEdit={handleEdit}
          onDelete={handleDeleteClick}
          onManageMembers={setMembersGroup}
          onManagePermissions={setPermissionsGroup}
        />

        {hasMore && (
          <Box sx={{ display: 'flex', justifyContent: 'center', mt: 3 }}>
            <Button variant="outlined" onClick={() => loadGroups({ limit: LIMIT, offset: groups.length, search: searchTerm, append: true })} disabled={loadingMore} sx={{ borderRadius: 2 }}>
              Load More
            </Button>
          </Box>
        )}

        <GroupFormDialog
          open={openFormDialog}
          initialData={editData}
          onClose={() => { setOpenFormDialog(false); setEditData(undefined) }}
          onSave={handleSave}
        />

        <ConfirmDialog
          open={openConfirmDialog}
          title="Delete Group"
          message="Are you sure you want to delete this group? This action cannot be undone."
          confirmText="Delete"
          cancelText="Cancel"
          confirmColor="error"
          onConfirm={handleConfirmDelete}
          onCancel={() => setOpenConfirmDialog(false)}
        />

        <ManageGroupMembersDialog open={!!membersGroup} group={membersGroup} onClose={() => setMembersGroup(null)} />
        <ManageGroupPermissionsDialog open={!!permissionsGroup} group={permissionsGroup} onClose={() => setPermissionsGroup(null)} />
      </Box>
    </Container>
  )
}
