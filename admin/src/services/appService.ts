import { httpClient } from '../utils/httpClient'
import type {
  App,
  CreateAppRequest,
  UpdateAppRequest,
  DeleteAppResponse,
  AssignAppRequest,
  AssignAppResponse,
  ListAppsRequest,
  ListAppsResponse,
  ListUserAppsRequest,
  ListUserAppsResponse,
} from '../apis/proto/openauth/v1/apps'

const BASE_URL = '/openauth/v1/apps'
const USER_URL = '/openauth/v1/users'

export const appService = {
  async list(params: ListAppsRequest): Promise<ListAppsResponse> {
    const queryParams = new URLSearchParams({
      limit: params.limit.toString(),
      offset: params.offset.toString(),
      ...(params.search && { search: params.search }),
    })

    const response = await httpClient.get<ListAppsResponse>(
      `${BASE_URL}?${queryParams.toString()}`
    )
    return response.data
  },

  async create(data: CreateAppRequest): Promise<App> {
    const response = await httpClient.post<App>(BASE_URL, data)
    return response.data
  },

  async update(data: UpdateAppRequest): Promise<App> {
    // Note: backend path is /openauth/v1/apps/{id}
    const response = await httpClient.put<App>(`${BASE_URL}/${data.id}`, data)
    return response.data
  },

  async delete(id: string): Promise<DeleteAppResponse> {
    const response = await httpClient.delete<DeleteAppResponse>(`${BASE_URL}/${id}`)
    return response.data
  },

  async assign(data: AssignAppRequest): Promise<AssignAppResponse> {
    const response = await httpClient.post<AssignAppResponse>(
      `${USER_URL}/${data.userId}/apps`,
      data
    )
    return response.data
  },

  async listUserApps(params: ListUserAppsRequest): Promise<ListUserAppsResponse> {
    const queryParams = new URLSearchParams({
      limit: params.limit.toString(),
      offset: params.offset.toString(),
    })
    const response = await httpClient.get<ListUserAppsResponse>(
      `${USER_URL}/${params.userId}/apps?${queryParams.toString()}`
    )
    return response.data
  },
}
