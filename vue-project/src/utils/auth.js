// src/utils/auth.js
import { http } from './http';

export const login = async (username, password) => {
  try {
    // http.js 拦截器处理后，这里的 loginResponse 就是后端 data 字段里的内容
    // 即 { token: "...", user: {...} }
    const loginResponse = await http.post('/v1/auth/login', {
      username,
      password
    });
    
    // 这个判断现在可以正常工作了
    if (loginResponse && loginResponse.token) {
      const token = loginResponse.token;
      localStorage.setItem('token', token);
      
      // 推荐：将用户信息也存起来
      if (loginResponse.user) {
        localStorage.setItem('userInfo', JSON.stringify(loginResponse.user));
      }
      
      return token;
    }
    
    // 如果后端 data 中没有 token，返回 null
    return null;

  } catch (error) {
    console.error('登录失败:', error);
    throw error; // 将错误继续抛出，让 LoginView.vue 的 catch 块可以捕获
  }
};

export const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('userInfo');
};

export const getToken = () => {
  return localStorage.getItem('token');
};

export const getUserInfo = () => {
    const userInfo = localStorage.getItem('userInfo');
    return userInfo ? JSON.parse(userInfo) : null;
}