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
.header { display: flex; justify-content: space-between; align-items: center; padding: 0 20px; height: 60px; background-color: #2c3e50; color: white; flex-shrink: 0; }
.container { display: flex; flex-grow: 1; }
.sidebar { width: 200px; background-color: #34495e; color: white; padding-top: 20px; flex-shrink: 0; }
.main-content { flex-grow: 1; padding: 20px; overflow-y: auto; }
.user-info button { margin-left: 15px; background: #e74c3c; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;}
</style>