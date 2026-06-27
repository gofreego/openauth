import { httpClient } from '../utils/httpClient'
import type {
  ConfigEntity,
  Config,
  ListConfigEntitiesRequest,
  ListConfigEntitiesResponse,
  CreateConfigEntityRequest,
  UpdateConfigEntityRequest,
  ListConfigsRequest,
  ListConfigsResponse,
  CreateConfigRequest,
  UpdateConfigRequest,
  DeleteResponse,
} from '../apis/proto/openauth/v1/configs'

const ENTITY_URL = '/openauth/v1/config-entities'
const CONFIG_URL = '/openauth/v1/configs'

export const configService = {
  // ===== Config Entities =====
  async listEntities(params: ListConfigEntitiesRequest): Promise<ListConfigEntitiesResponse> {
    const queryParams = new URLSearchParams({
      limit: params.limit.toString(),
      offset: params.offset.toString(),
      all: (params.all ?? false).toString(),
      ...(params.search && { search: params.search }),
    })
    const response = await httpClient.get<ListConfigEntitiesResponse>(`${ENTITY_URL}?${queryParams.toString()}`)
    return response.data
  },

  async createEntity(data: CreateConfigEntityRequest): Promise<ConfigEntity> {
    const response = await httpClient.post<ConfigEntity>(ENTITY_URL, data)
    return response.data
  },

  async updateEntity(data: UpdateConfigEntityRequest): Promise<ConfigEntity> {
    const response = await httpClient.put<ConfigEntity>(`${ENTITY_URL}/${data.id}`, data)
    return response.data
  },

  async deleteEntity(id: string): Promise<DeleteResponse> {
    const response = await httpClient.delete<DeleteResponse>(`${ENTITY_URL}/${id}`)
    return response.data
  },

  // ===== Configs =====
  async listConfigs(params: ListConfigsRequest): Promise<ListConfigsResponse> {
    const queryParams = new URLSearchParams({
      limit: (params.limit ?? 100).toString(),
      offset: (params.offset ?? 0).toString(),
      all: (params.all ?? false).toString(),
      ...(params.entityId && { entity_id: params.entityId }),
      ...(params.search && { search: params.search }),
    })
    const response = await httpClient.get<ListConfigsResponse>(`${CONFIG_URL}?${queryParams.toString()}`)
    return response.data
  },

  async createConfig(data: CreateConfigRequest): Promise<Config> {
    const response = await httpClient.post<Config>(CONFIG_URL, data)
    return response.data
  },

  async updateConfig(data: UpdateConfigRequest): Promise<Config> {
    const response = await httpClient.put<Config>(`${CONFIG_URL}/${data.id}`, data)
    return response.data
  },

  async deleteConfig(id: string): Promise<DeleteResponse> {
    const response = await httpClient.delete<DeleteResponse>(`${CONFIG_URL}/${id}`)
    return response.data
  },
}
