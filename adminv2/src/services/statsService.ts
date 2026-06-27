import { httpClient } from '../utils/httpClient'
import type { StatsResponse } from '../apis/proto/openauth/v1/stats'

const BASE_URL = '/openauth/v1/stats'

export const statsService = {
  async get(): Promise<StatsResponse> {
    const response = await httpClient.get<StatsResponse>(BASE_URL)
    return response.data
  },
}
