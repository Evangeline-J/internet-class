import { http } from '@/utils/http'

/**
 * @description 获取当前用户的菜单列表
 */
export function getMenus() {
  return http.get('/v1/menus')
}