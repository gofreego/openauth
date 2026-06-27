import { httpClient } from '../utils/httpClient'
import type {
  ListUsersRequest,
  ListUsersResponse,
  GetUserResponse,
  SignUpRequest,
  SignUpResponse,
  UpdateUserRequest,
  UpdateUserResponse,
  DeleteUserResponse,
} from '../apis/proto/openauth/v1/users'

const BASE_URL = '/openauth/v1/users'

export const userService = {
  async list(params: ListUsersRequest): Promise<ListUsersResponse> {
    const queryParams = new URLSearchParams({
      limit: params.limit.toString(),
      offset: params.offset.toString(),
      ...(params.search && { search: params.search }),
    })

    const response = await httpClient.get<ListUsersResponse>(
      `${BASE_URL}?${queryParams.toString()}`
    )
    return response.data
  },

  async get(uuid: string, includeProfile = false): Promise<GetUserResponse> {
    const queryParams = new URLSearchParams({
      includeProfile: includeProfile.toString(),
    })
    const response = await httpClient.get<GetUserResponse>(
      `${BASE_URL}/${uuid}?${queryParams.toString()}`
    )
    return response.data
  },

  async create(data: SignUpRequest): Promise<SignUpResponse> {
    const response = await httpClient.post<SignUpResponse>(`${BASE_URL}/signup`, data)
    return response.data
  },

  async update(data: UpdateUserRequest): Promise<UpdateUserResponse> {
    const response = await httpClient.put<UpdateUserResponse>(`${BASE_URL}/${data.uuid}`, data)
    return response.data
  },

  async delete(uuid: string, softDelete = true): Promise<DeleteUserResponse> {
    const queryParams = new URLSearchParams({ softDelete: softDelete.toString() })
    const response = await httpClient.delete<DeleteUserResponse>(
      `${BASE_URL}/${uuid}?${queryParams.toString()}`
    )
    return response.data
  },
}
