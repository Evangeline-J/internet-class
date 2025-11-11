import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getMenus } from '@/api/menu'
import router from '@/router'
import MainLayout from '@/layouts/MainLayout.vue'

// 使用 Vite 的 import.meta.glob 实现动态导入视图组件
const viewModules = import.meta.glob('@/views/**/*.vue')

/**
 * 【最终修正版】
 * 格式化后端返回的菜单数据，转换成 Vue Router 的路由记录
 * 这个版本会安全地处理 path 或 component 为 null 的情况
 * @param {Array} menus - 后端返回的菜单数组
 * @returns {Array} - Vue Router 路由记录数组
 */
function generateRoutes(menus) {
  const routes = [];
  for (const menu of menus) {
    // 只有当一个菜单项同时拥有 path 和 component 时，它才是一个有效的、可渲染的路由。
    // 父级菜单可能只有 children，没有 component，所以我们不为它直接创建路由，但会处理它的子项。
    if (menu.path && menu.component) {
      const route = {
        // path 属性现在是安全的，因为它在 if 条件中已被检查
        path: menu.path,
        // name 的生成也是安全的
        name: menu.path.replace('/', ''), 
        meta: { title: menu.name, icon: menu.icon },
        // 动态加载组件也是安全的
        component: viewModules[`/src/views/${menu.component}.vue`],
        children: [] // 先初始化 children
      };

      // 如果这个有效的路由还有子菜单，递归处理它们
      if (menu.children && menu.children.length > 0) {
        route.children = generateRoutes(menu.children);
      }
      routes.push(route);

    } else if (menu.children && menu.children.length > 0) {
      // 如果这个菜单项本身无效（比如没有 component），但它有子菜单，
      // 我们需要将它的子菜单的路由“提级”，直接加到当前路由列表中。
      routes.push(...generateRoutes(menu.children));
    }
  }
  return routes;
}


export const useMenuStore = defineStore('menu', () => {
  const menus = ref([])
  const hasGeneratedRoutes = ref(false)

  async function fetchAndGenerateRoutes() {
    // 1. 从后端获取菜单数据
    const backendMenus = await getMenus()
    menus.value = backendMenus

    // 2. 将后端菜单数据转换为路由格式
    const dynamicRoutes = generateRoutes(backendMenus)

    // 3. 将动态路由添加到主布局的子路由中
    // 我们假设所有动态页面都在一个主布局下
    router.addRoute({
      path: '/',
      component: MainLayout,
      redirect: dynamicRoutes[0]?.path || '/fallback', // 重定向到第一个菜单项
      children: dynamicRoutes
    });
    
    // 4. 更新状态
    hasGeneratedRoutes.value = true
  }

  function reset() {
    menus.value = []
    hasGeneratedRoutes.value = false
    // 这里可能还需要移除路由，但通常在退出登录后刷新页面即可
  }

  return {
    menus,
    hasGeneratedRoutes,
    fetchAndGenerateRoutes,
    reset
  }
})