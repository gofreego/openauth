import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Box, Container, Button, TextField, InputAdornment } from '@mui/material'
import { Add as AddIcon, Search as SearchIcon } from '@mui/icons-material'
import { ConfirmDialog } from '@gofreego/tsutils'
import { useUsers } from './hooks/useUsers'
import { UserTable } from './components/UserTable'
import { UserFormDialog } from './components/UserFormDialog'
import { UserSessionsDialog } from '../sessions/components/UserSessionsDialog'
import { UserProfilesDialog } from '../profiles/components/UserProfilesDialog'
import { ManageUserGroupsDialog } from '../groups/components/ManageUserGroupsDialog'
import { ManageUserPermissionsDialog } from '../permissions/components/ManageUserPermissionsDialog'
import type { User, SignUpRequest, UpdateUserRequest } from '../../apis/proto/openauth/v1/users'
import { PageHeader } from '../../components'

export const UsersPage = () => {
  const [searchParams, setSearchParams] = useSearchParams()
  const { users, loading, loadingMore, hasMore, loadUsers, createUser, updateUser, deleteUser } = useUsers()

  const [openFormDialog, setOpenFormDialog] = useState(false)
  const [openConfirmDialog, setOpenConfirmDialog] = useState(false)
  const [editData, setEditData] = useState<User | undefined>(undefined)
  const [deleteUuid, setDeleteUuid] = useState<string>('')
  const [searchInput, setSearchInput] = useState<string>(searchParams.get('search') || '')
  const [searchTerm, setSearchTerm] = useState<string>(searchParams.get('search') || '')

  // Cross-entity dialogs
  const [sessionsUser, setSessionsUser] = useState<User | null>(null)
  const [profilesUser, setProfilesUser] = useState<User | null>(null)
  const [groupsUser, setGroupsUser] = useState<User | null>(null)
  const [permissionsUser, setPermissionsUser] = useState<User | null>(null)

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
    loadUsers({ limit: LIMIT, offset: 0, search: searchTerm, append: false })
  }, [searchTerm, loadUsers])

  const reload = () => loadUsers({ limit: LIMIT, offset: 0, search: searchTerm, append: false })

  const handleLoadMore = () => loadUsers({ limit: LIMIT, offset: users.length, search: searchTerm, append: true })

  const handleCreate = () => {
    setEditData(undefined)
    setOpenFormDialog(true)
  }

  const handleEdit = (user: User) => {
    setEditData(user)
    setOpenFormDialog(true)
  }

  const handleDeleteClick = (user: User) => {
    setDeleteUuid(user.uuid)
    setOpenConfirmDialog(true)
  }

  const handleConfirmDelete = async () => {
    if (deleteUuid) {
      await deleteUser(deleteUuid, true)
      setOpenConfirmDialog(false)
      setDeleteUuid('')
      reload()
    }
  }

  const handleSave = async (data: SignUpRequest | UpdateUserRequest) => {
    if ('uuid' in data && data.uuid) {
      await updateUser(data as UpdateUserRequest)
    } else {
      await createUser(data as SignUpRequest)
    }
    setEditData(undefined)
    reload()
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ py: 4 }}>
        <PageHeader
          title="Users"
          subtitle="Manage user accounts, profiles, groups and permissions."
          action={
            <Button variant="contained" startIcon={<AddIcon />} onClick={handleCreate} sx={{ borderRadius: 2 }}>
              Create User
            </Button>
          }
        />

        <Box sx={{ mb: 3, display: 'flex', gap: 2, flexWrap: 'wrap', alignItems: 'center' }}>
          <TextField
            size="small"
            placeholder="Search users..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            InputProps={{ startAdornment: (<InputAdornment position="start"><SearchIcon /></InputAdornment>) }}
            sx={{ flex: 1, minWidth: 250, maxWidth: 400, '& .MuiOutlinedInput-root': { borderRadius: 4 } }}
          />
          {searchInput && (
            <Button variant="outlined" onClick={() => setSearchInput('')} sx={{ borderRadius: 2 }}>Clear</Button>
          )}
        </Box>

        <UserTable
          users={users}
          loading={loading}
          loadingMore={loadingMore}
          onEdit={handleEdit}
          onDelete={handleDeleteClick}
          onViewSessions={setSessionsUser}
          onViewProfiles={setProfilesUser}
          onManageGroups={setGroupsUser}
          onManagePermissions={setPermissionsUser}
        />

        {hasMore && (
          <Box sx={{ display: 'flex', justifyContent: 'center', mt: 3 }}>
            <Button variant="outlined" onClick={handleLoadMore} disabled={loadingMore} sx={{ borderRadius: 2 }}>
              Load More
            </Button>
          </Box>
        )}

        <UserFormDialog
          open={openFormDialog}
          initialData={editData}
          onClose={() => { setOpenFormDialog(false); setEditData(undefined) }}
          onSave={handleSave}
        />

        <ConfirmDialog
          open={openConfirmDialog}
          title="Deactivate User"
          message="Are you sure you want to deactivate this user?"
          confirmText="Deactivate"
          cancelText="Cancel"
          confirmColor="error"
          onConfirm={handleConfirmDelete}
          onCancel={() => setOpenConfirmDialog(false)}
        />

        <UserSessionsDialog open={!!sessionsUser} user={sessionsUser} onClose={() => setSessionsUser(null)} />
        <UserProfilesDialog open={!!profilesUser} user={profilesUser} onClose={() => setProfilesUser(null)} />
        <ManageUserGroupsDialog open={!!groupsUser} user={groupsUser} onClose={() => setGroupsUser(null)} />
        <ManageUserPermissionsDialog open={!!permissionsUser} user={permissionsUser} onClose={() => setPermissionsUser(null)} />
      </Box>
    </Container>
  )
}
