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
        // 如果业务错误码是403xx，也设置HTTP状态码为403，方便前端统一处理
        if (Math.floor(payload.code / 100) === 403) {
          error.code = 403;
        } else {
          error.code = payload.code;
        }
        return Promise.reject(error);
      }
    } else {
      // 【新增逻辑】如果不是标准包装格式 (例如登录接口的直接响应)
      // 我们直接认为它是成功的，并返回整个 payload
      return payload;
    }
  },
  (error) => {
    // 【核心修复】这里是处理所有 HTTP 错误的地方
    const err = new Error(); // 创建一个新的 Error 对象

    if (error.response) {
      // 服务器返回了响应，但状态码不是 2xx
      const status = error.response.status;
      const backendData = error.response.data;
      
      // 将后端返回的 message (如果有) 赋值给错误信息
      err.message = backendData?.message || `请求失败，状态码：${status}`;
      
      // 【最关键的一步】将 HTTP 状态码附加到 error 对象的 code 属性上
      err.code = status;

    } else if (error.request) {
      // 请求已发出，但没有收到响应
      err.message = '网络不可用或服务器无响应';
    } else {
      // 其他错误，例如请求配置出错
      err.message = error.message || '请求发生未知错误';
    }

    // 抛出我们处理过的、带有 code 属性的错误对象
    return Promise.reject(err);
  }
)

// 是否使用 mock 数据（默认 false，使用真实后端）
export const USE_MOCK = false

export { http }