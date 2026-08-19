import httpClient from '../utils/httpClient'
import { AuthService } from '@gofreego/tsutils'
import { SessionManager } from '@gofreego/tsutils';

export const sessionManager = SessionManager.getInstance(httpClient);
export const authService =  AuthService.getInstance(httpClient);
export { appService } from './appService';
export { userService } from './userService';
export { statsService } from './statsService';
export { permissionService } from './permissionService';
export { permissionAssignmentService } from './permissionAssignmentService';
export { groupService } from './groupService';
export { sessionService } from './sessionService';
export { profileService } from './profileService';
export { configService } from './configService';