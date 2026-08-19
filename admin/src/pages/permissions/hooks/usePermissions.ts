import { useState, useCallback } from 'react'
import { useNotification } from '@gofreego/tsutils'
import { permissionService } from '../../../services/permissionService'
import type {
  Permission,
  CreatePermissionRequest,
  UpdatePermissionRequest,
} from '../../../apis/proto/openauth/v1/permissions'

export interface UsePermissionsReturn {
  permissions: Permission[]
  loading: boolean
  loadingMore: boolean
  hasMore: boolean
  loadPermissions: (params: { limit: number; offset: number; search?: string; append?: boolean }) => Promise<void>
  createPermission: (data: CreatePermissionRequest) => Promise<void>
  updatePermission: (data: UpdatePermissionRequest) => Promise<void>
  deletePermission: (id: string) => Promise<void>
}

export const usePermissions = (): UsePermissionsReturn => {
  const [permissions, setPermissions] = useState<Permission[]>([])
  const [loading, setLoading] = useState(true)
  const [loadingMore, setLoadingMore] = useState(false)
  const [hasMore, setHasMore] = useState(false)
  const { showNotification } = useNotification()

  const loadPermissions = useCallback(async (params: { limit: number; offset: number; search?: string; append?: boolean }) => {
    if (params.append) setLoadingMore(true)
    else setLoading(true)
    try {
      const data = await permissionService.list({
        limit: params.limit,
        offset: params.offset,
        search: params.search || '',
        all: false,
      })
      const items = data.permissions || []
      setPermissions(prev => (params.append ? [...prev, ...items] : items))
      setHasMore(items.length === params.limit)
    } catch (error) {
      showNotification('Failed to load permissions', 'error')
      console.error(error)
    } finally {
      if (params.append) setLoadingMore(false)
      else setLoading(false)
    }
  }, [showNotification])

  const createPermission = useCallback(async (data: CreatePermissionRequest) => {
    try {
      await permissionService.create(data)
      showNotification('Permission created successfully', 'success')
    } catch (error) {
      showNotification('Failed to create permission', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const updatePermission = useCallback(async (data: UpdatePermissionRequest) => {
    try {
      await permissionService.update(data)
      showNotification('Permission updated successfully', 'success')
    } catch (error) {
      showNotification('Failed to update permission', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const deletePermission = useCallback(async (id: string) => {
    try {
      await permissionService.delete(id)
      showNotification('Permission deleted successfully', 'success')
    } catch (error) {
      showNotification('Failed to delete permission', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  return { permissions, loading, loadingMore, hasMore, loadPermissions, createPermission, updatePermission, deletePermission }
}
