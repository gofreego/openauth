import { httpClient } from '../utils/httpClient'
import type {
  ListUserSessionsResponse,
  TerminateSessionResponse,
} from '../apis/proto/openauth/v1/sessions'

const USER_URL = '/openauth/v1/users'
const SESSION_URL = '/openauth/v1/sessions'

export const sessionService = {
  async listUserSessions(userUuid: string, limit = 100, offset = 0): Promise<ListUserSessionsResponse> {
    const queryParams = new URLSearchParams({ limit: limit.toString(), offset: offset.toString() })
    const response = await httpClient.get<ListUserSessionsResponse>(
      `${USER_URL}/${userUuid}/sessions?${queryParams.toString()}`
    )
    return response.data
  },

  async terminate(sessionId: string, userId?: string): Promise<TerminateSessionResponse> {
    const response = await httpClient.put<TerminateSessionResponse>(
      `${SESSION_URL}/terminate`,
      { sessionId, userId }
    )
    return response.data
  },
}
