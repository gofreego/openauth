import { useState, useCallback } from 'react'
import { useNotification } from '@gofreego/tsutils'
import { groupService } from '../../../services/groupService'
import type { Group, CreateGroupRequest, UpdateGroupRequest } from '../../../apis/proto/openauth/v1/groups'

export interface UseGroupsReturn {
  groups: Group[]
  loading: boolean
  loadingMore: boolean
  hasMore: boolean
  loadGroups: (params: { limit: number; offset: number; search?: string; append?: boolean }) => Promise<void>
  createGroup: (data: CreateGroupRequest) => Promise<void>
  updateGroup: (data: UpdateGroupRequest) => Promise<void>
  deleteGroup: (id: string) => Promise<void>
}

export const useGroups = (): UseGroupsReturn => {
  const [groups, setGroups] = useState<Group[]>([])
  const [loading, setLoading] = useState(true)
  const [loadingMore, setLoadingMore] = useState(false)
  const [hasMore, setHasMore] = useState(false)
  const { showNotification } = useNotification()

  const loadGroups = useCallback(async (params: { limit: number; offset: number; search?: string; append?: boolean }) => {
    if (params.append) setLoadingMore(true)
    else setLoading(true)
    try {
      const data = await groupService.list({ limit: params.limit, offset: params.offset, search: params.search || '', all: false })
      const items = data.groups || []
      setGroups(prev => (params.append ? [...prev, ...items] : items))
      setHasMore(items.length === params.limit)
    } catch (error) {
      showNotification('Failed to load groups', 'error')
      console.error(error)
    } finally {
      if (params.append) setLoadingMore(false)
      else setLoading(false)
    }
  }, [showNotification])

  const createGroup = useCallback(async (data: CreateGroupRequest) => {
    try {
      await groupService.create(data)
      showNotification('Group created successfully', 'success')
    } catch (error) {
      showNotification('Failed to create group', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const updateGroup = useCallback(async (data: UpdateGroupRequest) => {
    try {
      await groupService.update(data)
      showNotification('Group updated successfully', 'success')
    } catch (error) {
      showNotification('Failed to update group', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const deleteGroup = useCallback(async (id: string) => {
    try {
      await groupService.delete(id)
      showNotification('Group deleted successfully', 'success')
    } catch (error) {
      showNotification('Failed to delete group', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  return { groups, loading, loadingMore, hasMore, loadGroups, createGroup, updateGroup, deleteGroup }
}
