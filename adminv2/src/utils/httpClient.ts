import { HttpClient } from '@gofreego/tsutils'

export { HttpClient, extractErrorMessage } from '@gofreego/tsutils'
export type { HttpClientConfig, RequestConfig, HttpResponse, HttpError, ErrorData } from '@gofreego/tsutils'

// ============ Configured Instance ============
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://api.bappaapp.com'

const getDevHeaders = (): Record<string, string> => {
  const headers: Record<string, string> = {}

  const devUserId = import.meta.env.VITE_DEV_USER_ID
  const devProfileId = import.meta.env.VITE_DEV_PROFILE_ID

  if (devUserId) {
    headers['X-User-Id'] = devUserId
  }
  if (devProfileId) {
    headers['X-Profile-Id'] = devProfileId
  }

  return headers
}

export const httpClient = new HttpClient({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: getDevHeaders(),
})

export const setAuthToken = (token: string) => {
  httpClient.setDefaultHeader('Authorization', `Bearer ${token}`)
}

export const clearAuthToken = () => {
  httpClient.removeDefaultHeader('Authorization')
}

export default httpClient

