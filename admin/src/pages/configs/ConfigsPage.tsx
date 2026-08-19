import { useState, useEffect, useCallback } from 'react'
import { Box, Container, Button, TextField, InputAdornment, IconButton, Typography } from '@mui/material'
import { Add as AddIcon, Search as SearchIcon, ArrowBack as BackIcon } from '@mui/icons-material'
import { ConfirmDialog, useNotification } from '@gofreego/tsutils'
import { configService } from '../../services/configService'
import { ConfigEntityTable } from './components/ConfigEntityTable'
import { ConfigEntityFormDialog } from './components/ConfigEntityFormDialog'
import { ConfigTable } from './components/ConfigTable'
import { ConfigFormDialog } from './components/ConfigFormDialog'
import type {
  ConfigEntity,
  Config,
  CreateConfigEntityRequest,
  UpdateConfigEntityRequest,
  CreateConfigRequest,
  UpdateConfigRequest,
} from '../../apis/proto/openauth/v1/configs'
import { PageHeader } from '../../components'

export const ConfigsPage = () => {
  const { showNotification } = useNotification()

  // ===== Entities state =====
  const [entities, setEntities] = useState<ConfigEntity[]>([])
  const [loadingEntities, setLoadingEntities] = useState(true)
  const [searchInput, setSearchInput] = useState('')
  const [searchTerm, setSearchTerm] = useState('')
  const [openEntityForm, setOpenEntityForm] = useState(false)
  const [editEntity, setEditEntity] = useState<ConfigEntity | undefined>(undefined)
  const [deleteEntityId, setDeleteEntityId] = useState('')

  // ===== Selected entity / configs state =====
  const [selectedEntity, setSelectedEntity] = useState<ConfigEntity | null>(null)
  const [configs, setConfigs] = useState<Config[]>([])
  const [loadingConfigs, setLoadingConfigs] = useState(false)
  const [openConfigForm, setOpenConfigForm] = useState(false)
  const [editConfig, setEditConfig] = useState<Config | undefined>(undefined)
  const [deleteConfigId, setDeleteConfigId] = useState('')

  const loadEntities = useCallback(async (search: string) => {
    setLoadingEntities(true)
    try {
      const data = await configService.listEntities({ limit: 100, offset: 0, search, all: false })
      setEntities(data.entities || [])
    } catch (error) {
      showNotification('Failed to load config entities', 'error')
      console.error(error)
    } finally {
      setLoadingEntities(false)
    }
  }, [showNotification])

  const loadConfigs = useCallback(async (entityId: string) => {
    setLoadingConfigs(true)
    try {
      const data = await configService.listConfigs({ entityId, limit: 200, offset: 0, all: true })
      setConfigs(data.configs || [])
    } catch (error) {
      showNotification('Failed to load configs', 'error')
      console.error(error)
    } finally {
      setLoadingConfigs(false)
    }
  }, [showNotification])

  useEffect(() => {
    const timer = setTimeout(() => setSearchTerm(searchInput), 400)
    return () => clearTimeout(timer)
  }, [searchInput])

  useEffect(() => {
    if (!selectedEntity) loadEntities(searchTerm)
  }, [searchTerm, selectedEntity, loadEntities])

  // ===== Entity handlers =====
  const handleSaveEntity = async (data: CreateConfigEntityRequest | UpdateConfigEntityRequest) => {
    try {
      if ('id' in data && data.id) {
        await configService.updateEntity(data as UpdateConfigEntityRequest)
        showNotification('Config entity updated', 'success')
      } else {
        await configService.createEntity(data as CreateConfigEntityRequest)
        showNotification('Config entity created', 'success')
      }
      setEditEntity(undefined)
      loadEntities(searchTerm)
    } catch (error) {
      showNotification('Failed to save config entity', 'error')
      console.error(error)
      throw error
    }
  }

  const handleConfirmDeleteEntity = async () => {
    if (!deleteEntityId) return
    try {
      await configService.deleteEntity(deleteEntityId)
      showNotification('Config entity deleted', 'success')
      setDeleteEntityId('')
      loadEntities(searchTerm)
    } catch (error) {
      showNotification('Failed to delete config entity', 'error')
      console.error(error)
    }
  }

  const handleSelectEntity = (entity: ConfigEntity) => {
    setSelectedEntity(entity)
    loadConfigs(entity.id)
  }

  // ===== Config handlers =====
  const handleSaveConfig = async (data: CreateConfigRequest | UpdateConfigRequest) => {
    try {
      if ('id' in data && data.id) {
        await configService.updateConfig(data as UpdateConfigRequest)
        showNotification('Config updated', 'success')
      } else {
        await configService.createConfig(data as CreateConfigRequest)
        showNotification('Config created', 'success')
      }
      setEditConfig(undefined)
      if (selectedEntity) loadConfigs(selectedEntity.id)
    } catch (error) {
      showNotification('Failed to save config', 'error')
      console.error(error)
      throw error
    }
  }

  const handleConfirmDeleteConfig = async () => {
    if (!deleteConfigId) return
    try {
      await configService.deleteConfig(deleteConfigId)
      showNotification('Config deleted', 'success')
      setDeleteConfigId('')
      if (selectedEntity) loadConfigs(selectedEntity.id)
    } catch (error) {
      showNotification('Failed to delete config', 'error')
      console.error(error)
    }
  }

  // ===== Render: configs view =====
  if (selectedEntity) {
    return (
      <Container maxWidth="lg">
        <Box sx={{ py: 4 }}>
          <PageHeader
            title={selectedEntity.displayName}
            subtitle={
              <Box component="span" sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                <IconButton size="small" onClick={() => setSelectedEntity(null)} title="Back to entities"><BackIcon fontSize="small" /></IconButton>
                <Typography component="span" variant="body2" color="text.secondary">Configs for {selectedEntity.name}</Typography>
              </Box>
            }
            action={
              <Button variant="contained" startIcon={<AddIcon />} onClick={() => { setEditConfig(undefined); setOpenConfigForm(true) }} sx={{ borderRadius: 2 }}>
                Create Config
              </Button>
            }
          />

          <ConfigTable
            configs={configs}
            loading={loadingConfigs}
            onEdit={(c) => { setEditConfig(c); setOpenConfigForm(true) }}
            onDelete={(c) => setDeleteConfigId(c.id)}
          />

          <ConfigFormDialog
            open={openConfigForm}
            entityId={selectedEntity.id}
            initialData={editConfig}
            onClose={() => { setOpenConfigForm(false); setEditConfig(undefined) }}
            onSave={handleSaveConfig}
          />

          <ConfirmDialog
            open={!!deleteConfigId}
            title="Delete Config"
            message="Are you sure you want to delete this config? This action cannot be undone."
            confirmText="Delete"
            cancelText="Cancel"
            confirmColor="error"
            onConfirm={handleConfirmDeleteConfig}
            onCancel={() => setDeleteConfigId('')}
          />
        </Box>
      </Container>
    )
  }

  // ===== Render: entities view =====
  return (
    <Container maxWidth="lg">
      <Box sx={{ py: 4 }}>
        <PageHeader
          title="Configs"
          subtitle="Manage configuration entities and their key-value settings."
          action={
            <Button variant="contained" startIcon={<AddIcon />} onClick={() => { setEditEntity(undefined); setOpenEntityForm(true) }} sx={{ borderRadius: 2 }}>
              Create Entity
            </Button>
          }
        />

        <Box sx={{ mb: 3, display: 'flex', gap: 2, flexWrap: 'wrap', alignItems: 'center' }}>
          <TextField
            size="small"
            placeholder="Search entities..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            InputProps={{ startAdornment: (<InputAdornment position="start"><SearchIcon /></InputAdornment>) }}
            sx={{ flex: 1, minWidth: 250, maxWidth: 400, '& .MuiOutlinedInput-root': { borderRadius: 4 } }}
          />
          {searchInput && <Button variant="outlined" onClick={() => setSearchInput('')} sx={{ borderRadius: 2 }}>Clear</Button>}
        </Box>

        <ConfigEntityTable
          entities={entities}
          loading={loadingEntities}
          loadingMore={false}
          onEdit={(e) => { setEditEntity(e); setOpenEntityForm(true) }}
          onDelete={(e) => setDeleteEntityId(e.id)}
          onViewConfigs={handleSelectEntity}
        />

        <ConfigEntityFormDialog
          open={openEntityForm}
          initialData={editEntity}
          onClose={() => { setOpenEntityForm(false); setEditEntity(undefined) }}
          onSave={handleSaveEntity}
        />

        <ConfirmDialog
          open={!!deleteEntityId}
          title="Delete Config Entity"
          message="Are you sure you want to delete this entity and all of its configs? This action cannot be undone."
          confirmText="Delete"
          cancelText="Cancel"
          confirmColor="error"
          onConfirm={handleConfirmDeleteEntity}
          onCancel={() => setDeleteEntityId('')}
        />
      </Box>
    </Container>
  )
}
