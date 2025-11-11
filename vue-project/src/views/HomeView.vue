<template>
  <div class="home-container">
    <!-- 卡片容器，让页面更有层次感 -->
    <div class="welcome-card">
      
      <!-- 动态欢迎语 -->
      <h1>
        您好, {{ userInfo?.nickname || userInfo?.username || '用户' }}!
      </h1>

      <p class="subtitle">
        欢迎回到您的管理后台。
      </p>

      <!-- 用户信息展示区 -->
      <div v-if="userInfo" class="user-info-box">
        <h3>您的登录信息</h3>
        <ul>
          <li><strong>用户ID:</strong> {{ userInfo.id }}</li>
          <li><strong>用户名:</strong> {{ userInfo.username }}</li>
          <!-- 假设您的用户信息中还可能有邮箱和角色 -->
          <li v-if="userInfo.email"><strong>邮箱:</strong> {{ userInfo.email }}</li>
        </ul>
      </div>

      <p class="footer-text">
        现在您可以通过左侧的导航菜单开始工作了。
      </p>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { getUserInfo } from '@/utils/auth'; // 引入我们之前定义好的工具函数

// 创建一个响应式变量来存储用户信息
const userInfo = ref(null);

// onMounted 是一个生命周期钩子，它会在组件被挂载到页面上后执行
// 这是获取初始数据的最佳时机
onMounted(() => {
  // 调用工具函数从 localStorage 获取用户信息，并赋值给 userInfo
  userInfo.value = getUserInfo();
});
</script>

<style scoped>
/* 使用 scoped 属性确保样式只作用于当前组件 */

.home-container {
  padding: 32px;
  background-color: #f0f2f5; /* 一个柔和的背景色 */
  min-height: calc(100vh - 50px); /* 减去顶部导航栏的高度，确保撑满全屏 */
  display: flex;
  align-items: center;
  justify-content: center;
}

.welcome-card {
  background: #ffffff;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
  text-align: center;
  max-width: 700px;
  width: 100%;
}

h1 {
  font-size: 2.2em;
  color: #1f2d3d;
  margin-bottom: 8px;
  font-weight: 600;
}

.subtitle {
  font-size: 1.2em;
  color: #5a6d80;
  margin-bottom: 32px;
}

.user-info-box {
  margin-top: 24px;
  padding: 20px;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  background-color: #f8f9fa;
  text-align: left; /* 信息列表左对齐更易读 */
  display: inline-block; /* 让容器宽度自适应内容 */
  min-width: 300px;
}

.user-info-box h3 {
  margin-top: 0;
  margin-bottom: 16px;
  color: #3c4858;
  border-bottom: 2px solid #007bff;
  padding-bottom: 8px;
  display: inline-block;
}

.user-info-box ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

.user-info-box li {
  font-size: 1em;
  color: #333;
  margin-bottom: 10px;
}

.user-info-box li:last-child {
  margin-bottom: 0;
}

.footer-text {
  margin-top: 32px;
  color: #8492a6;
}
</style>