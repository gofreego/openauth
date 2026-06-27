import { httpClient } from '../utils/httpClient'
import type {
  ListUserProfilesResponse,
  CreateProfileRequest,
  CreateProfileResponse,
  UpdateProfileRequest,
  UpdateProfileResponse,
  DeleteProfileResponse,
} from '../apis/proto/openauth/v1/users'

const USER_URL = '/openauth/v1/users'
const PROFILE_URL = '/openauth/v1/profiles'

// metadata is a protobuf bytes field; it does not serialize cleanly to JSON,
// so we drop it from REST payloads (the backend treats it as optional).
function stripMetadata<T extends { metadata?: unknown }>(data: T): Omit<T, 'metadata'> {
  const rest = { ...data }
  delete (rest as { metadata?: unknown }).metadata
  return rest
}

export const profileService = {
  async listUserProfiles(userUuid: string, limit = 100, offset = 0): Promise<ListUserProfilesResponse> {
    const queryParams = new URLSearchParams({ limit: limit.toString(), offset: offset.toString() })
    const response = await httpClient.get<ListUserProfilesResponse>(
      `${USER_URL}/${userUuid}/profiles?${queryParams.toString()}`
    )
    return response.data
  },

  async create(data: CreateProfileRequest): Promise<CreateProfileResponse> {
    const response = await httpClient.post<CreateProfileResponse>(
      `${USER_URL}/${data.userId}/profiles`,
      stripMetadata(data)
    )
    return response.data
  },

  async update(data: UpdateProfileRequest): Promise<UpdateProfileResponse> {
    const response = await httpClient.put<UpdateProfileResponse>(
      `${PROFILE_URL}/${data.profileUuid}`,
      stripMetadata(data)
    )
    return response.data
  },

  async delete(profileUuid: string): Promise<DeleteProfileResponse> {
    const response = await httpClient.delete<DeleteProfileResponse>(`${PROFILE_URL}/${profileUuid}`)
    return response.data
  },
}
