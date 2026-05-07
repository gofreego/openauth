import { httpClient, setAuthToken, clearAuthToken } from '../utils/httpClient'
import type {
  SignInRequest,
  SignInResponse,
  RefreshTokenRequest,
  RefreshTokenResponse,
  LogoutRequest,
  LogoutResponse,
} from '../apis/proto/openauth/v1/sessions'

const BASE_URL = '/openauth/v1'

// Storage key
const SESSION_DETAILS_KEY = 'session_details'

export const authService = {
  async signIn(request: SignInRequest): Promise<SignInResponse> {
      const response = await httpClient.post<SignInResponse>(
        `${BASE_URL}/auth/signin`,
        request
      )

      if (response.data.accessToken) {
        localStorage.setItem(SESSION_DETAILS_KEY, JSON.stringify(response.data))
        setAuthToken(response.data.accessToken)
      }

      return response.data
  },

  async refreshToken(request?: Partial<RefreshTokenRequest>): Promise<RefreshTokenResponse> {
    const refreshToken = this.getSessionDetails()?.refreshToken
    if (!refreshToken) {
      throw new Error('No refresh token available')
    }

    const response = await httpClient.post<RefreshTokenResponse>(
      `${BASE_URL}/auth/refresh`,
      { refreshToken, ...request }
    )

    // Update stored session with new tokens
    if (response.data.accessToken) {
      const current = this.getSessionDetails()
      if (current) {
        localStorage.setItem(SESSION_DETAILS_KEY, JSON.stringify({
          ...current,
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
        }))
      }
      setAuthToken(response.data.accessToken)
    }

    return response.data
  },

  async logout(request: LogoutRequest): Promise<LogoutResponse> {
    try {
      request.sessionId = this.getSessionId()
      const response = await httpClient.post<LogoutResponse>(
        `${BASE_URL}/auth/logout`,
        request || {}
      )
      return response.data
    } finally {
      localStorage.removeItem(SESSION_DETAILS_KEY)
      clearAuthToken()
    }
  },

  // Check if user is authenticated
  isAuthenticated(): boolean {
    return !!this.getSessionDetails()?.accessToken
  },

  // Get stored access token
  getAccessToken(): string | undefined {
    return this.getSessionDetails()?.accessToken || undefined
  },

  // Get full session details stored at sign-in
  getSessionDetails(): SignInResponse | null {
    const raw = localStorage.getItem(SESSION_DETAILS_KEY)
    if (!raw) return null
    try {
      return JSON.parse(raw) as SignInResponse
    } catch {
      return null
    }
  },

  // Get sessionId
  getSessionId(): string | undefined {
    return this.getSessionDetails()?.sessionId
  },

  // Initialize auth from stored session (call on app startup)
  initializeAuth(): void {
    const session = this.getSessionDetails()
    if (session?.accessToken && Number(session.expiresAt) > Date.now() / 1000) {
      setAuthToken(session.accessToken)
    } else {
      localStorage.removeItem(SESSION_DETAILS_KEY)
    }
  }
}