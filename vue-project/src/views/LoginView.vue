<!-- src/views/LoginView.vue -->
<template>
  <div class="login-container">
    <h2>登录</h2>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label for="username">用户名</label>
        <input type="text" id="username" v-model="username" required />
      </div>
      <div class="form-group">
        <label for="password">密码</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <button type="submit">登录</button>
    </form>
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
      
      // 路由生成后，再跳转到主页
      router.push('/');
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
.login-container {
  max-width: 400px;
  margin: 50px auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
}
.form-group {
  margin-bottom: 15px;
}
label {
  display: block;
  margin-bottom: 5px;
}
input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}
button {
  width: 100%;
  padding: 10px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
button:hover {
  background-color: #0056b3;
}
</style>