<template>
  <template v-for="item in items" :key="item.id">
    <li>
      <!-- 如果没有子菜单或子菜单为空，则为可点击链接 -->
      <router-link :to="!item.children || item.children.length === 0 ? item.path : null">
        {{ item.name }}
      </router-link>
      <!-- 如果有子菜单，则递归调用自身来渲染子菜单 -->
      <ul v-if="item.children && item.children.length > 0" class="submenu">
        <SidebarMenuItem :items="item.children" />
      </ul>
    </li>
  </template>
</template>

<script>
// 为了让组件能够递归调用自己，我们需要使用常规的 <script> 块并指定 name
export default {
  name: 'SidebarMenuItem'
}
</script>

<script setup>
// props 定义仍然可以在 setup 中
defineProps({
  items: {
    type: Array,
    required: true
  }
});
</script>

<style scoped>
/* 仅美化渲染，不改动任何逻辑结构 */
ul { list-style: none; padding: 0; margin: 0; }
li { margin: 4px 10px; }

a {
  position: relative;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 12px 10px 14px;
  color: #334155;
  text-decoration: none;
  border-radius: 10px;
  transition: background-color .15s ease, color .15s ease, box-shadow .2s ease;
}
a:hover {
  background-color: #eef2ff;
}
/* 选中态更醒目，左侧高亮条 */
a.router-link-active {
  color: #1e293b;
  background: #e9eeff;
  box-shadow: inset 3px 0 0 0 #7c57ff;
}
a.router-link-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 60%;
  background: #7c57ff;
  border-radius: 2px;
}

/* 如果是父菜单项（不可点击），可以改变鼠标样式 */
a[href=""] { cursor: default; }
a[href=""]:hover { background-color: transparent; }

.submenu {
  padding-left: 14px;
  margin-left: 4px;
  border-left: 1px dashed rgba(2,6,23,0.12);
}
</style>