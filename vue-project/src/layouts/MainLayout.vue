<template>
  <div class="app-layout">
    <header class="header">
      <span class="title">我的系统</span>
      <div class="user-info">
        <span>欢迎</span>
        <button @click="handleLogout">退出</button>
      </div>
    </header>
    <div class="container">
      <aside class="sidebar">
        <SidebarMenu />
      </aside>
      <main class="main-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import SidebarMenu from '@/components/SidebarMenu.vue';
import { logout } from '@/utils/auth';
import { useMenuStore } from '@/stores/menu';

const router = useRouter();
const menuStore = useMenuStore();

const handleLogout = () => {
  logout(); // 清除 token
  menuStore.reset(); // 重置 Pinia 状态
  router.push('/login'); // 跳转到登录页
};
</script>

<style scoped>
.app-layout { display: flex; flex-direction: column; height: 100vh; }
.header { display: flex; justify-content: space-between; align-items: center; padding: 0 20px; height: 60px; background: linear-gradient(180deg, #f8fafc, #eef2ff); color: #0f172a; flex-shrink: 0; border-bottom: 1px solid rgba(2,6,23,0.06); }
.container { display: flex; flex-grow: 1; }
/* 与登录页保持统一的浅色系渐变背景 */
.sidebar {
  width: 200px;
  background: linear-gradient(180deg, #f8fafc, #eef2ff);
  color: #0f172a;
  padding: 14px 6px 20px;
  flex-shrink: 0;
  border-right: 1px solid rgba(2,6,23,0.06);
  overflow-y: auto;
}
.main-content { flex-grow: 1; padding: 20px; overflow-y: auto; }
.user-info button { margin-left: 15px; background: #e74c3c; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;}
</style>