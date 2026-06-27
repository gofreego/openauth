import { httpClient } from '../utils/httpClient'
import type {
  GetUserEffectivePermissionsResponse,
  AssignPermissionsToUserResponse,
  RemovePermissionsFromUserResponse,
  ListGroupPermissionsResponse,
  AssignPermissionsToGroupResponse,
  RemovePermissionsFromGroupResponse,
} from '../apis/proto/openauth/v1/permission_assignments'

const USER_URL = '/openauth/v1/users'
const GROUP_URL = '/openauth/v1/groups'

export const permissionAssignmentService = {
  // ===== User permissions =====
  async getUserEffectivePermissions(userId: string): Promise<GetUserEffectivePermissionsResponse> {
    const response = await httpClient.get<GetUserEffectivePermissionsResponse>(
      `${USER_URL}/${userId}/effective-permissions`
    )
    return response.data
  },

  async assignPermissionsToUser(userId: string, permissionsIds: string[], expiresAt?: string): Promise<AssignPermissionsToUserResponse> {
    const response = await httpClient.post<AssignPermissionsToUserResponse>(
      `${USER_URL}/${userId}/permissions`,
      { userId, permissionsIds, expiresAt }
    )
    return response.data
  },

  async removePermissionsFromUser(userId: string, permissionsIds: string[]): Promise<RemovePermissionsFromUserResponse> {
    const response = await httpClient.put<RemovePermissionsFromUserResponse>(
      `${USER_URL}/${userId}/permissions`,
      { userId, permissionsIds }
    )
    return response.data
  },

  // ===== Group permissions =====
  async listGroupPermissions(groupId: string): Promise<ListGroupPermissionsResponse> {
    const response = await httpClient.get<ListGroupPermissionsResponse>(
      `${GROUP_URL}/${groupId}/permissions`
    )
    return response.data
  },

  async assignPermissionsToGroup(groupId: string, permissionsIds: string[]): Promise<AssignPermissionsToGroupResponse> {
    const response = await httpClient.post<AssignPermissionsToGroupResponse>(
      `${GROUP_URL}/${groupId}/permissions`,
      { groupId, permissionsIds }
    )
    return response.data
  },

  async removePermissionsFromGroup(groupId: string, permissionsIds: string[]): Promise<RemovePermissionsFromGroupResponse> {
    const response = await httpClient.put<RemovePermissionsFromGroupResponse>(
      `${GROUP_URL}/${groupId}/permissions`,
      { groupId, permissionsIds }
    )
    return response.data
  },
}
