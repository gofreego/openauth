import { httpClient } from '../utils/httpClient'
import type {
  Permission,
  ListPermissionsRequest,
  ListPermissionsResponse,
  CreatePermissionRequest,
  UpdatePermissionRequest,
  DeletePermissionResponse,
} from '../apis/proto/openauth/v1/permissions'

const BASE_URL = '/openauth/v1/permissions'

export const permissionService = {
  async list(params: ListPermissionsRequest): Promise<ListPermissionsResponse> {
    const queryParams = new URLSearchParams({
      limit: params.limit.toString(),
      offset: params.offset.toString(),
      all: (params.all ?? false).toString(),
      ...(params.search && { search: params.search }),
    })
    const response = await httpClient.get<ListPermissionsResponse>(`${BASE_URL}?${queryParams.toString()}`)
    return response.data
  },

  async create(data: CreatePermissionRequest): Promise<Permission> {
    const response = await httpClient.post<Permission>(BASE_URL, data)
    return response.data
  },

  async update(data: UpdatePermissionRequest): Promise<Permission> {
    const response = await httpClient.put<Permission>(`${BASE_URL}/${data.id}`, data)
    return response.data
  },

  async delete(id: string): Promise<DeletePermissionResponse> {
    const response = await httpClient.delete<DeletePermissionResponse>(`${BASE_URL}/${id}`)
    return response.data
  },
}
