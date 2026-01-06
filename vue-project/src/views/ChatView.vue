<template>
  <section class="chat-page">
    <div class="chat-wrap">
      <aside class="session-pane">
        <div class="pane-header">
          <h3>会话</h3>
          <button class="new-btn" @click="onCreate">新建</button>
        </div>

        <ul class="session-list">
          <li v-for="s in sessions" :key="s.id"
              :class="['session-item', activeId === s.id ? 'active' : '']"
              @click="openSession(s.id)"
              @contextmenu.prevent="removeSession(s)">
            <span class="title">{{ s.title || ('会话 ' + s.id) }}</span>
          </li>
        </ul>
      </aside>

      <main class="dialog-pane">
        <div class="dialog-body" ref="scrollArea">
          <div v-if="!activeId" class="empty">请选择或创建一个会话</div>
          <div v-else>
            <div v-for="m in messages" :key="m.id" :class="['msg', m.role]">
              <div class="bubble">
                <div class="role">
                  <template v-if="m.role === 'assistant_think'">
                    思考 <span class="think-badge">THINK</span>
                  </template>
                  <template v-else>
                    {{ m.role === 'user' ? '我' : '助手' }}
                  </template>
                </div>
                <div class="content">{{ m.content }}</div>
                <div class="ts">{{ formatTime(m.createdAt) }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="composer" v-if="activeId">
          <textarea v-model="draft" placeholder="输入你的问题..." @keydown.enter.exact.prevent="send"></textarea>
          <button class="send-btn" :disabled="!draft.trim() || sending" @click="send">
            {{ sending ? '发送中...' : '发送' }}
          </button>
        </div>
      </main>
    </div>
  </section>
  </template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { listSessions, createSession, deleteSession, listMessages, sendMessage } from '@/api/chat'

const sessions = ref([])
const activeId = ref(null)
const messages = ref([])
const draft = ref('')
const sending = ref(false)
const scrollArea = ref(null)

function formatTime(t) {
  if (!t) return ''
  return String(t).replace('T',' ').slice(0, 19)
}

async function fetchSessions() {
  sessions.value = await listSessions()
}

function splitAssistant(content) {
  const s = String(content || '')
  // 情况1：标准 <think>...</think>
  const m = s.match(/<think>([\s\S]*?)<\/think>/i)
  if (m) {
    const think = m[1].trim()
    const answer = s.slice(m.index + m[0].length).trim()
    return { think, answer }
  }
  // 情况2：仅返回 </think>（部分 R1 模型可能出现）
  const closeIdx = s.toLowerCase().indexOf('</think>')
  if (closeIdx >= 0) {
    const think = s.slice(0, closeIdx).trim()
    const answer = s.slice(closeIdx + '</think>'.length).trim()
    return { think, answer }
  }
  // 默认：无思考块
  return { think: '', answer: s }
}

function normalizeList(list) {
  const out = []
  for (const it of list || []) {
    if (it.role === 'assistant') {
      const { think, answer } = splitAssistant(it.content)
      if (think) {
        out.push({ id: `${it.id}-t`, role: 'assistant_think', content: think, createdAt: it.createdAt })
      }
      out.push({ id: it.id, role: 'assistant', content: answer, createdAt: it.createdAt })
    } else {
      out.push(it)
    }
  }
  return out
}

async function openSession(id) {
  if (activeId.value === id) return
  activeId.value = id
  const raw = await listMessages(id)
  messages.value = normalizeList(raw)
  await nextTick()
  if (scrollArea.value) scrollArea.value.scrollTop = scrollArea.value.scrollHeight
}

async function onCreate() {
  const s = await createSession()
  await fetchSessions()
  await openSession(s.id)
}

async function removeSession(s) {
  if (!confirm(`删除会话「${s.title || s.id}」？`)) return
  await deleteSession(s.id)
  await fetchSessions()
  if (activeId.value === s.id) {
    activeId.value = null
    messages.value = []
  }
}

async function send() {
  const text = draft.value.trim()
  if (!text || sending.value || !activeId.value) return
  sending.value = true
  try {
    // 先在前端追加用户消息带来即时反馈
    const tmp = { id: 'u-' + Date.now(), role: 'user', content: text, createdAt: new Date().toISOString() }
    messages.value.push(tmp)
    draft.value = ''
    await nextTick()
    if (scrollArea.value) scrollArea.value.scrollTop = scrollArea.value.scrollHeight

    const resp = await sendMessage(activeId.value, text)
    const normalized = normalizeList([resp])
    for (const r of normalized) messages.value.push(r)
  } finally {
    sending.value = false
    await nextTick()
    if (scrollArea.value) scrollArea.value.scrollTop = scrollArea.value.scrollHeight
  }
}

onMounted(fetchSessions)
</script>

<style scoped>
.chat-page { min-height: calc(100vh - 60px); display: flex; }
.chat-wrap { display: flex; width: 100%; }
.session-pane {
  width: 240px;
  border-right: 1px solid rgba(2,6,23,0.06);
  background: linear-gradient(180deg, #f8fafc, #eef2ff);
  padding: 12px;
}
.pane-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.pane-header h3 { margin: 0; font-size: 14px; color: #0f172a; }
.new-btn {
  border: none; background: #7c57ff; color: #fff; border-radius: 8px; padding: 6px 10px; cursor: pointer;
}
.session-list { list-style: none; padding: 0; margin: 8px 0 0; }
.session-item {
  padding: 8px 10px; border-radius: 8px; cursor: pointer; color: #334155;
}
.session-item:hover { background: #eef2ff; }
.session-item.active { background: #e9eeff; color: #1e293b; box-shadow: inset 3px 0 0 0 #7c57ff; }

.dialog-pane { flex: 1; display: flex; flex-direction: column; }
.dialog-body { flex: 1; padding: 16px; overflow-y: auto; }
.empty { color: #94a3b8; text-align: center; margin-top: 80px; }
.msg { display: flex; margin-bottom: 12px; }
.msg.user { justify-content: flex-end; }
.msg .bubble {
  max-width: 70%;
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 13px;
  padding: 10px 12px;
  box-shadow: 0 1px 2px rgba(16,24,40,0.04);
}
.msg.assistant .bubble { background: #f8fafc; }
.msg.assistant_think .bubble {
  background: #fff7ed;
  border-color: #fed7aa;
}
.msg.assistant_think .bubble .content {
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  color: #374151;
  white-space: pre-wrap;
}
.think-badge {
  margin-left: 6px;
  padding: 0 6px;
  border-radius: 6px;
  background: #ffedd5;
  color: #c2410c;
  font-size: 11px;
  font-weight: 700;
}
.bubble .role { font-size: 12px; color: #64748b; margin-bottom: 4px; }
.bubble .content { white-space: pre-wrap; color: #0f172a; }
.bubble .ts { margin-top: 6px; font-size: 11px; color: #94a3b8; text-align: right; }

.composer { display: flex; gap: 8px; padding: 12px 16px; border-top: 1px solid rgba(2,6,23,0.06); }
.composer textarea {
  flex: 1; resize: none; height: 80px; border-radius: 10px; border: 1px solid #e2e8f0; padding: 10px 12px; outline: none;
}
.composer textarea:focus { border-color: #7c57ff; box-shadow: 0 0 0 4px rgba(124,87,255,.12); }
.send-btn { border: none; background: linear-gradient(90deg, #5b8cff, #7c57ff); color: #fff; border-radius: 10px; padding: 0 16px; cursor: pointer; }
</style>


