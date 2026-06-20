import { httpClient } from '../utils/httpClient'
import type {
  ListUsersRequest,
  ListUsersResponse,
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
}
