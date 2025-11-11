import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import { getToken, logout } from '../utils/auth'
import { useMenuStore } from '@/stores/menu'

// 静态路由保持不变
const staticRoutes = [
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: { isPublic: true }
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('../views/NotFoundView.vue'),
    meta: { isPublic: true }
  }
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: staticRoutes
})


// --- 【最终修正版路由守卫】 ---
router.beforeEach(async (to, from, next) => {
  const hasToken = getToken();
  
  // 在守卫外部获取 store 实例，确保它在 Pinia 初始化后被调用
  // 这一点很重要，以防 Pinia 未完全准备好
  const menuStore = useMenuStore();

  if (hasToken) {
    // 用户已登录
    if (to.name === 'login') {
      // 如果已登录还想去登录页，直接送回首页
      next({ path: '/' });
    } else {
      // 检查路由是否已生成
      if (menuStore.hasGeneratedRoutes) {
        // 如果已生成，直接放行
        next();
      } else {
        try {
          // 如果未生成，则调用 action 获取菜单并添加路由
          await menuStore.fetchAndGenerateRoutes();
          
          // 【核心修改】
          // 使用 next({ ...to, replace: true }) 是最关键的一步。
          // 它的作用是：丢弃当前的导航，用相同的目标地址发起一次全新的导航。
          // 此时，因为 hasGeneratedRoutes 已经是 true，
          // 新的导航会直接进入上面的 if 分支，从而确保了新添加的路由能被正确匹配到。
          next({ path: to.fullPath, replace: true });
          
        } catch (error) {
          console.error('动态路由添加失败:', error);
          // 如果失败（例如 token 过期），则清空登录状态并返回登录页
          logout();
          next({ name: 'login' });
        }
      }
    }
  } else {
    // 用户未登录
    if (to.meta.isPublic) {
      // 如果是公开页面，直接放行
      next();
    } else {
      // 如果是受保护页面，重定向到登录页
      next({ name: 'login' });
    }
  }
});

export default router