import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Box, Container, Button, TextField, InputAdornment } from '@mui/material'
import { Add as AddIcon, Search as SearchIcon } from '@mui/icons-material'
import { ConfirmDialog } from '@gofreego/tsutils'
import { useApps } from './hooks/useApps'
import { AppTable } from './components/AppTable'
import { AppFormDialog } from './components/AppFormDialog'
import type { App, CreateAppRequest, UpdateAppRequest } from '../../apis/proto/openauth/v1/apps'
import { PageHeader } from '../../components'

export const AppsPage = () => {
  const [searchParams, setSearchParams] = useSearchParams()

  const {
    apps,
    loading,
    loadingMore,
    hasMore,
    loadApps,
    createApp,
    updateApp,
    deleteApp,
    getAppById,
  } = useApps()

  const [openFormDialog, setOpenFormDialog] = useState(false)
  const [openConfirmDialog, setOpenConfirmDialog] = useState(false)
  const [deleteId, setDeleteId] = useState<string>('')
  const [editData, setEditData] = useState<UpdateAppRequest | undefined>(undefined)
  const [searchInput, setSearchInput] = useState<string>(searchParams.get('search') || '')
  const [searchTerm, setSearchTerm] = useState<string>(searchParams.get('search') || '')

  const LIMIT = 10

  // Sync search filter with URL
  useEffect(() => {
    const params = new URLSearchParams()
    if (searchTerm) params.set('search', searchTerm)
    else params.delete('search')
    setSearchParams(params, { replace: true })
  }, [searchTerm, setSearchParams])

  // Debounce inputs into filters
  useEffect(() => {
    const timer = setTimeout(() => {
      setSearchTerm(searchInput)
    }, 400)
    return () => clearTimeout(timer)
  }, [searchInput])

  // Load initial apps with pagination and filters
  useEffect(() => {
    loadApps({ limit: LIMIT, offset: 0, search: searchTerm, append: false })
  }, [searchTerm, loadApps])

  const handleLoadMore = () => {
    loadApps({ limit: LIMIT, offset: apps.length, search: searchTerm, append: true })
  }

  const handleClearFilters = () => {
    setSearchInput('')
  }

  const handleCreate = () => {
    setEditData(undefined)
    setOpenFormDialog(true)
  }

  const handleEdit = async (app: App) => {
    const fullApp = await getAppById(app.id)
    if (fullApp) {
      setEditData({
        id: fullApp.id,
        name: fullApp.name,
        description: fullApp.description,
        url: fullApp.url,
        logoUrl: fullApp.logoUrl,
      })
      setOpenFormDialog(true)
    }
  }

  const handleDeleteClick = (app: App) => {
    setDeleteId(app.id)
    setOpenConfirmDialog(true)
  }

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteApp(deleteId)
      setOpenConfirmDialog(false)
      setDeleteId('')
      // Reload
      loadApps({ limit: LIMIT, offset: 0, search: searchTerm, append: false })
    }
  }

  const handleSave = async (data: CreateAppRequest | UpdateAppRequest) => {
    if ('id' in data && data.id) {
      await updateApp(data as UpdateAppRequest)
    } else {
      await createApp(data as CreateAppRequest)
    }
    setEditData(undefined)
    // Reload
    loadApps({ limit: LIMIT, offset: 0, search: searchTerm, append: false })
  }

  const handleCloseFormDialog = () => {
    setOpenFormDialog(false)
    setEditData(undefined)
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ py: 4 }}>
        <PageHeader
          title="Apps"
          subtitle="Manage registered applications and integrations."
          action={
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={handleCreate}
              sx={{ borderRadius: 2 }}
            >
              Create App
            </Button>
          }
        />

        <Box sx={{ mb: 3, display: 'flex', gap: 2, flexWrap: 'wrap', alignItems: 'center' }}>
          <TextField
            size="small"
            placeholder="Search apps by name..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon />
                </InputAdornment>
              ),
            }}
            sx={{
              flex: 1,
              minWidth: 250,
              maxWidth: 400,
              '& .MuiOutlinedInput-root': {
                borderRadius: 4,
              }
            }}
          />
          {searchInput && (
            <Button
              variant="outlined"
              onClick={handleClearFilters}
              sx={{ borderRadius: 2 }}
            >
              Clear
            </Button>
          )}
        </Box>

        <AppTable
          apps={apps}
          loading={loading}
          loadingMore={loadingMore}
          onEdit={handleEdit}
          onDelete={handleDeleteClick}
        />

        {hasMore && (
          <Box
            sx={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              mt: 3,
              position: 'relative',
              minHeight: 40,
            }}
          >
            <Button
              variant="outlined"
              onClick={handleLoadMore}
              disabled={loadingMore}
              sx={{ borderRadius: 2 }}
            >
              Load More
            </Button>
          </Box>
        )}

        <AppFormDialog
          open={openFormDialog}
          initialData={editData}
          onClose={handleCloseFormDialog}
          onSave={handleSave}
        />

        <ConfirmDialog
          open={openConfirmDialog}
          title="Delete App"
          message="Are you sure you want to delete this application? This action cannot be undone."
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
