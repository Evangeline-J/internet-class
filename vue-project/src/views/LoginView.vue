<!-- src/views/LoginView.vue -->
<template>
  <div class="auth-page">
    <div class="card">
      <div class="brand">
        <div class="logo" aria-hidden="true">
          <svg viewBox="0 0 24 24" width="28" height="28">
            <defs>
              <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
                <stop offset="0%" stop-color="#5b8cff" />
                <stop offset="100%" stop-color="#7c57ff" />
              </linearGradient>
            </defs>
            <path fill="url(#g)" d="M12 2a10 10 0 1 0 10 10A10.011 10.011 0 0 0 12 2Zm0 5a3 3 0 1 1-3 3 3 3 0 0 1 3-3Zm0 13a7 7 0 0 1-6-3.27 5 5 0 0 1 12 0A7 7 0 0 1 12 20Z"/>
          </svg>
        </div>
        <h1>欢迎登录</h1>
        <p class="subtitle">请输入您的账号和密码</p>
      </div>

      <form class="form" @submit.prevent="handleLogin">
        <div class="field">
          <label for="username">用户名</label>
          <div class="input-wrap">
            <span class="icon" aria-hidden="true">
              <svg viewBox="0 0 24 24" width="18" height="18">
                <path fill="currentColor" d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-4.418 0-8 2.239-8 5v1a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-1c0-2.761-3.582-5-8-5Z"/>
              </svg>
            </span>
            <input
              id="username"
              type="text"
              v-model="username"
              placeholder="请输入用户名"
              autocomplete="username"
              required
            />
          </div>
        </div>

        <div class="field">
          <label for="password">密码</label>
          <div class="input-wrap">
            <span class="icon" aria-hidden="true">
              <svg viewBox="0 0 24 24" width="18" height="18">
                <path fill="currentColor" d="M17 8h-1V6a4 4 0 0 0-8 0v2H7a1 1 0 0 0-1 1v10a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1Zm-7-2a2 2 0 1 1 4 0v2h-4Zm2 10a2 2 0 1 1 2-2 2 2 0 0 1-2 2Z"/>
              </svg>
            </span>
            <input
              id="password"
              type="password"
              v-model="password"
              placeholder="请输入密码"
              autocomplete="current-password"
              required
            />
          </div>
        </div>

        <button class="submit" type="submit">登录</button>
      </form>
    </div>
  </div>
  </template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { login } from '@/utils/auth';
import { useMenuStore } from '@/stores/menu'; // 引入 menu store

const username = ref('');
const password = ref('');
const router = useRouter();
const menuStore = useMenuStore(); // 获取 store 实例

const handleLogin = async () => {
  try {
    // 使用您原始的、正确的 login 方法
    const token = await login(username.value, password.value);
    
    if (token) {
      // 登录成功！
      // 在跳转之前，调用 action 来获取菜单并生成路由
      await menuStore.fetchAndGenerateRoutes();
      
      // 路由生成后，跳转到仪表盘（/apps）
      router.push('/apps');
    } else {
      // 如果 login 函数返回 null (虽然在您的逻辑里不太可能，除非后端不返回token)
      alert('登录失败，未获取到令牌。');
    }
  } catch (error) {
    console.error('登录请求失败:', error);
    // 从 error 对象中获取更具体的消息
    const errorMessage = error.message || '登录失败，请稍后再试。';
    alert(errorMessage);
  }
};
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: radial-gradient(1200px 400px at 10% -20%, #e9eeff 30%, transparent 60%),
              radial-gradient(1000px 500px at 110% 10%, #f2eaff 20%, transparent 60%),
              linear-gradient(180deg, #f8fafc, #eef2ff);
}

.card {
  width: 100%;
  max-width: 440px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
  padding: 28px 28px 32px;
  border: 1px solid rgba(2, 6, 23, 0.06);
}

.brand {
  text-align: center;
  margin-bottom: 18px;
}
.logo {
  width: 56px;
  height: 56px;
  display: grid;
  place-items: center;
  border-radius: 14px;
  background: linear-gradient(180deg, #eef2ff, #e9d8ff);
  margin: 0 auto 12px;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.6), 0 6px 16px rgba(124,87,255,0.15);
}
.brand h1 {
  margin: 0;
  font-size: 22px;
  color: #0f172a;
  font-weight: 700;
}
.subtitle {
  margin: 6px 0 0;
  color: #64748b;
  font-size: 13px;
}

.form {
  margin-top: 10px;
}
.field {
  margin-bottom: 16px;
}
.field label {
  display: block;
  margin-bottom: 8px;
  color: #334155;
  font-size: 13px;
  font-weight: 600;
}
.input-wrap {
  position: relative;
}
.icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #94a3b8;
  pointer-events: none;
}
.input-wrap input {
  width: 100%;
  height: 44px;
  padding: 0 12px 0 40px;
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  background: #fff;
  transition: all .2s ease;
  color: #0f172a;
  outline: none;
}
.input-wrap input::placeholder {
  color: #a0aec0;
}
.input-wrap input:hover {
  border-color: #cbd5e1;
}
.input-wrap input:focus {
  border-color: #7c57ff;
  box-shadow: 0 0 0 4px rgba(124, 87, 255, 0.12);
}

.submit {
  width: 100%;
  height: 46px;
  border: none;
  border-radius: 12px;
  color: #fff;
  font-weight: 700;
  letter-spacing: .5px;
  background: linear-gradient(90deg, #5b8cff, #7c57ff);
  box-shadow: 0 8px 18px rgba(92, 126, 255, 0.25);
  cursor: pointer;
  transition: transform .05s ease, box-shadow .2s ease, filter .15s ease;
}
.submit:hover {
  filter: brightness(1.03);
  box-shadow: 0 10px 22px rgba(92, 126, 255, 0.3);
}
.submit:active {
  transform: translateY(1px);
}
</style>