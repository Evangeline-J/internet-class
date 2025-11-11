import axios from 'axios'
import { getToken } from './auth'

const BASE_API = import.meta.env.VITE_BASE_API || '/api'

const http = axios.create({
  baseURL: BASE_API,
  timeout: 15000,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }
})

// 请求拦截器 (保持不变)
http.interceptors.request.use((config) => {
  const token = getToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
}, (error) => {
  return Promise.reject(error)
})

// --- 【最终版响应拦截器】 ---
http.interceptors.response.use(
  (response) => {
    const payload = response.data;

    // 检查 payload 是否存在
    if (!payload) {
      // 如果响应体为空，也视为一种错误
      return Promise.reject(new Error('响应数据为空'));
    }

    // 【核心修改】检查响应是否是我们标准的 {code, data} 包装格式
    if (typeof payload === 'object' && 'code' in payload && 'data' in payload) {
      // 是标准包装格式
      if (payload.code === 0) {
        // 业务成功，只返回 data 部分
        return payload.data;
      } else {
        // 业务失败，抛出错误
        const errorMessage = payload.message || '业务处理失败';
        const error = new Error(errorMessage);
        error.code = payload.code;
        return Promise.reject(error);
      }
    } else {
      // 【新增逻辑】如果不是标准包装格式 (例如登录接口的直接响应)
      // 我们直接认为它是成功的，并返回整个 payload
      return payload;
    }
  },
  (error) => {
    // 网络错误处理 (保持不变)
    if (error.response) {
      const p = error.response.data;
      const msg = p?.message || `HTTP ${error.response.status}`;
      const err = new Error(msg);
      err.code = p?.code ?? error.response.status;
      throw err;
    } else if (error.request) {
      throw new Error('网络不可用或服务器无响应');
    } else {
      throw new Error(error.message || '请求发生错误');
    }
  }
)

export { http }