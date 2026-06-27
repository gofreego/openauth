import { useState, useCallback } from 'react'
import { useNotification } from '@gofreego/tsutils'
import { userService } from '../../../services/userService'
import type {
  User,
  SignUpRequest,
  UpdateUserRequest,
} from '../../../apis/proto/openauth/v1/users'

export interface UseUsersReturn {
  users: User[]
  loading: boolean
  loadingMore: boolean
  hasMore: boolean
  loadUsers: (params: { limit: number; offset: number; search?: string; append?: boolean }) => Promise<void>
  createUser: (data: SignUpRequest) => Promise<void>
  updateUser: (data: UpdateUserRequest) => Promise<void>
  deleteUser: (uuid: string, softDelete?: boolean) => Promise<void>
}

export const useUsers = (): UseUsersReturn => {
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [loadingMore, setLoadingMore] = useState(false)
  const [hasMore, setHasMore] = useState(false)
  const { showNotification } = useNotification()

  const loadUsers = useCallback(async (params: { limit: number; offset: number; search?: string; append?: boolean }) => {
    if (params.append) {
      setLoadingMore(true)
    } else {
      setLoading(true)
    }
    try {
      const data = await userService.list({
        limit: params.limit,
        offset: params.offset,
        search: params.search || '',
      })
      const items = data.users || []
      if (params.append) {
        setUsers(prev => [...prev, ...items])
      } else {
        setUsers(items)
      }
      setHasMore(items.length === params.limit)
    } catch (error) {
      showNotification('Failed to load users', 'error')
      console.error(error)
    } finally {
      if (params.append) {
        setLoadingMore(false)
      } else {
        setLoading(false)
      }
    }
  }, [showNotification])

  const createUser = useCallback(async (data: SignUpRequest) => {
    try {
      await userService.create(data)
      showNotification('User created successfully', 'success')
    } catch (error) {
      showNotification('Failed to create user', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const updateUser = useCallback(async (data: UpdateUserRequest) => {
    try {
      await userService.update(data)
      showNotification('User updated successfully', 'success')
    } catch (error) {
      showNotification('Failed to update user', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  const deleteUser = useCallback(async (uuid: string, softDelete = true) => {
    try {
      await userService.delete(uuid, softDelete)
      showNotification(softDelete ? 'User deactivated successfully' : 'User deleted successfully', 'success')
    } catch (error) {
      showNotification('Failed to delete user', 'error')
      console.error(error)
      throw error
    }
  }, [showNotification])

  return {
    users,
    loading,
    loadingMore,
    hasMore,
    loadUsers,
    createUser,
    updateUser,
    deleteUser,
  }
}
