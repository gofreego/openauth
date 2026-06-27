import { httpClient } from '../utils/httpClient'
import type {
  ListGroupsRequest,
  ListGroupsResponse,
  CreateGroupRequest,
  CreateGroupResponse,
  UpdateGroupRequest,
  UpdateGroupResponse,
  DeleteGroupResponse,
  ListGroupUsersResponse,
  ListUserGroupsResponse,
  AssignUsersToGroupResponse,
  RemoveUsersFromGroupResponse,
} from '../apis/proto/openauth/v1/groups'

const BASE_URL = '/openauth/v1/groups'
const USER_URL = '/openauth/v1/users'

export const groupService = {
  async list(params: ListGroupsRequest): Promise<ListGroupsResponse> {
    const queryParams = new URLSearchParams({
      limit: params.limit.toString(),
      offset: params.offset.toString(),
      all: (params.all ?? false).toString(),
      ...(params.search && { search: params.search }),
    })
    const response = await httpClient.get<ListGroupsResponse>(`${BASE_URL}?${queryParams.toString()}`)
    return response.data
  },

  async create(data: CreateGroupRequest): Promise<CreateGroupResponse> {
    const response = await httpClient.post<CreateGroupResponse>(BASE_URL, data)
    return response.data
  },

  async update(data: UpdateGroupRequest): Promise<UpdateGroupResponse> {
    const response = await httpClient.put<UpdateGroupResponse>(`${BASE_URL}/${data.id}`, data)
    return response.data
  },

  async delete(id: string): Promise<DeleteGroupResponse> {
    const response = await httpClient.delete<DeleteGroupResponse>(`${BASE_URL}/${id}`)
    return response.data
  },

  async listGroupUsers(groupId: string, limit = 100, offset = 0): Promise<ListGroupUsersResponse> {
    const queryParams = new URLSearchParams({ limit: limit.toString(), offset: offset.toString() })
    const response = await httpClient.get<ListGroupUsersResponse>(`${BASE_URL}/${groupId}/users?${queryParams.toString()}`)
    return response.data
  },

  async listUserGroups(userId: string, limit = 100, offset = 0, all = true): Promise<ListUserGroupsResponse> {
    const queryParams = new URLSearchParams({ limit: limit.toString(), offset: offset.toString(), all: all.toString() })
    const response = await httpClient.get<ListUserGroupsResponse>(`${USER_URL}/${userId}/groups?${queryParams.toString()}`)
    return response.data
  },

  async assignUsers(groupId: string, userIds: string[], expiresAt?: string): Promise<AssignUsersToGroupResponse> {
    const response = await httpClient.post<AssignUsersToGroupResponse>(`${BASE_URL}/${groupId}/users`, { groupId, userIds, expiresAt })
    return response.data
  },

  async removeUsers(groupId: string, userIds: string[]): Promise<RemoveUsersFromGroupResponse> {
    const response = await httpClient.put<RemoveUsersFromGroupResponse>(`${BASE_URL}/${groupId}/users`, { groupId, userIds })
    return response.data
  },
}
