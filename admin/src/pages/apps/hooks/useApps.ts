import { useState, useCallback } from 'react'
import { useNotification } from '@gofreego/tsutils'
import { appService } from '../../../services/appService'
import type {
  App,
  CreateAppRequest,
  UpdateAppRequest,
} from '../../../apis/proto/openauth/v1/apps'

export interface UseAppsReturn {
  apps: App[]
  loading: boolean
  loadingMore: boolean
  selectedApp: App | null
  hasMore: boolean
  loadApps: (params: { limit: number; offset: number; search?: string; append?: boolean }) => Promise<void>
  createApp: (data: CreateAppRequest) => Promise<void>
  updateApp: (data: UpdateAppRequest) => Promise<void>
  deleteApp: (id: string) => Promise<void>
  getAppById: (id: string) => Promise<App | null>
  clearSelectedApp: () => void
}

export const useApps = (): UseAppsReturn => {
  const [apps, setApps] = useState<App[]>([])
  const [loading, setLoading] = useState(true)
  const [loadingMore, setLoadingMore] = useState(false)
  const [selectedApp, setSelectedApp] = useState<App | null>(null)
  const [hasMore, setHasMore] = useState(false)
  const { showNotification } = useNotification()

  const loadApps = useCallback(async (params: { limit: number; offset: number; search?: string; append?: boolean }) => {
    if (params.append) {
      setLoadingMore(true)
    } else {
      setLoading(true)
    }
    try {
      const data = await appService.list({
        limit: params.limit,
        offset: params.offset,
        search: params.search || '',
      })
      const items = data.apps || []
      if (params.append) {
        setApps(prev => [...prev, ...items])
      } else {
        setApps(items)
      }
      setHasMore(items.length === params.limit)
    } catch (error) {
      showNotification('Failed to load apps', 'error')
      console.error(error)
    } finally {
      if (params.append) {
        setLoadingMore(false)
      } else {
        setLoading(false)
      }
    }
  }, [showNotification])

  const createApp = useCallback(async (data: CreateAppRequest) => {
    try {
      await appService.create(data)
      showNotification('App created successfully', 'success')
    } catch (error) {
      showNotification('Failed to create app', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const updateApp = useCallback(async (data: UpdateAppRequest) => {
    try {
      await appService.update(data)
      showNotification('App updated successfully', 'success')
    } catch (error) {
      showNotification('Failed to update app', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const deleteApp = useCallback(async (id: string) => {
    try {
      await appService.delete(id)
      showNotification('App deleted successfully', 'success')
    } catch (error) {
      showNotification('Failed to delete app', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const getAppById = useCallback(async (id: string): Promise<App | null> => {
    // There is no getById endpoint in the proto definition of App service,
    // but we can locate it from the loaded list or just find it.
    // Let's search inside our local state as fallback.
    const found = apps.find(a => a.id === id) || null
    setSelectedApp(found)
    return found
  }, [apps])

  const clearSelectedApp = useCallback(() => {
    setSelectedApp(null)
  }, [])

  return {
    apps,
    loading,
    loadingMore,
    selectedApp,
    hasMore,
    loadApps,
    createApp,
    updateApp,
    deleteApp,
    getAppById,
    clearSelectedApp,
  }
}
