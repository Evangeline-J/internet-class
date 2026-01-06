import { http } from '@/utils/http'

export function createSession(title) {
  return http.post('/v1/chat/sessions', title ? { title } : {})
}

export function listSessions() {
  return http.get('/v1/chat/sessions')
}

export function deleteSession(id) {
  return http.delete(`/v1/chat/sessions/${id}`)
}

export function listMessages(sessionId) {
  return http.get(`/v1/chat/sessions/${sessionId}/messages`)
}

export function sendMessage(sessionId, content) {
  return http.post(`/v1/chat/sessions/${sessionId}/messages`, { content })
}




