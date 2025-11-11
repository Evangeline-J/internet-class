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
/* 样式可以保持在子组件中，以便更好地封装 */
ul { list-style: none; padding: 0; margin: 0; }
a { display: block; padding: 10px 20px; color: white; text-decoration: none; }
a:hover, .router-link-active { background-color: #4a6fa1; }
/* 如果是父菜单项（不可点击），可以改变鼠标样式 */
a[href=""] { cursor: default; }
a[href=""]:hover { background-color: transparent; }
.submenu { padding-left: 20px; }
</style>