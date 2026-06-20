import httpClient from '../utils/httpClient'
import { AuthService } from '@gofreego/tsutils'
import { SessionManager } from '@gofreego/tsutils';

export const sessionManager = SessionManager.getInstance(httpClient);
export const authService =  AuthService.getInstance(httpClient);
export { appService } from './appService';