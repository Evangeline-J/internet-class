<template>
  <nav class="menu-nav">
    <ul>
      <!-- 直接使用我们刚刚创建的递归子组件 -->
      <SidebarMenuItem :items="menus" />
    </ul>
  </nav>
</template>

<script setup>
import { computed } from 'vue';
import { useMenuStore } from '@/stores/menu';
import SidebarMenuItem from './SidebarMenuItem.vue'; // 引入新的子组件

const menuStore = useMenuStore();
const menus = computed(() => menuStore.menus);
</script>

<style scoped>
/* 主要的容器样式可以留在这里，仅做外观优化 */
.menu-nav {
  width: 100%;
  padding: 8px 6px 14px;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
.menu-nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
</style>