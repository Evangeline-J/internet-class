import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getMenus } from '@/api/menu'
import MainLayout from '@/layouts/MainLayout.vue'

// 动态收集 views（使用相对 glob，避免 alias 在 glob 上的问题）
const viewModules = import.meta.glob('../views/**/*.vue')

function findImporterByPath(path) {
  if (!path) return null
  const p = path.replace(/^\//, '')
  const candidates = [
    `${p}.vue`,
    `${p}/index.vue`,
    `${capitalize(p)}View.vue`
  ]
  for (const k of Object.keys(viewModules)) {
    for (const c of candidates) {
      if (k.endsWith(c)) return viewModules[k]
    }
  }
  return null
}

function capitalize(s = '') {
  return s.split(/[-_/]/).map(p => p ? (p[0].toUpperCase() + p.slice(1)) : '').join('')
}

function generateRoutes(menus = []) {
  const routes = []
  for (const menu of menus) {
    // 尝试按 path 匹配视图文件（后端未提供 component 字段时）
    const importer = menu.component
      ? (Object.keys(viewModules).find(k => k.endsWith(`${menu.component}.vue`)) ? viewModules[Object.keys(viewModules).find(k => k.endsWith(`${menu.component}.vue`))] : null)
      : findImporterByPath(menu.path)

    if (menu.path && importer) {
      const route = {
        // children 使用相对 path（去掉前导 /）
        path: menu.path.replace(/^\//, ''),
        name: (menu.name || menu.path).replace(/\s+/g, '-'),
        meta: { title: menu.name, icon: menu.icon },
        component: importer,
        children: []
      }
      if (menu.children && menu.children.length > 0) {
        route.children = generateRoutes(menu.children)
      }
      routes.push(route)
    } else if (menu.children && menu.children.length > 0) {
      routes.push(...generateRoutes(menu.children))
    } else {
      console.warn('[menu store] 忽略菜单项（找不到组件或 path）：', menu)
    }
  }
  return routes
}

export const useMenuStore = defineStore('menu', () => {
  const menus = ref([])
  const hasGeneratedRoutes = ref(false)
  const LAYOUT_ROUTE_NAME = 'app-main-layout'

  async function fetchAndGenerateRoutes() {
    if (hasGeneratedRoutes.value) return

    try {
      const backendMenus = await getMenus()
      menus.value = backendMenus || []
      console.log('[menu store] 后端原始菜单：', menus.value)

      const dynamicRoutes = generateRoutes(menus.value)
      console.log('[menu store] 生成的动态路由（相对 path）：', dynamicRoutes)

      const layoutRoute = {
        path: '/',
        name: LAYOUT_ROUTE_NAME,
        component: MainLayout,
        children: [
          // 默认欢迎页，使用 AppsView 作为主界面
          { path: '', name: 'welcome', component: viewModules['../views/AppsView.vue'] || (() => import('../views/AppsView.vue')) },
          ...dynamicRoutes
        ]
      }

      // 动态导入 router（关键，打破循环依赖）
      const routerModule = await import('@/router')
      const router = routerModule.default || routerModule.router || routerModule

      // 添加路由（避免重复添加）
      if (!(router.hasRoute && router.hasRoute(LAYOUT_ROUTE_NAME))) {
        router.addRoute(layoutRoute)
        console.log('[menu store] 已将 layoutRoute 添加到 router')
      } else {
        console.warn('[menu store] layoutRoute 已存在')
      }

      hasGeneratedRoutes.value = true
    } catch (err) {
      console.error('[menu store] 生成动态路由出错：', err)
      throw err
    }
  }

  async function reset() {
    menus.value = []
    if (!hasGeneratedRoutes.value) {
      hasGeneratedRoutes.value = false
      return
    }
    try {
      const routerModule = await import('@/router')
      const router = routerModule.default || routerModule.router || routerModule
      if (router.hasRoute && router.hasRoute(LAYOUT_ROUTE_NAME)) {
        router.removeRoute(LAYOUT_ROUTE_NAME)
        console.log('[menu store] 已移除 layoutRoute')
      }
    } catch (err) {
      console.error('[menu store] 重置移除路由时出错：', err)
    } finally {
      hasGeneratedRoutes.value = false
    }
  }

  return { menus, hasGeneratedRoutes, fetchAndGenerateRoutes, reset }
})