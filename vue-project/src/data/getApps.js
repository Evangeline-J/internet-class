import { apps as mock } from '@/mock/apps'
import { http, USE_MOCK } from '@/utils/http'

function normalize(app) {
  return {
    ...app,
    price: Number(app.price ?? 0),
    rating: Number(app.rating ?? 0),
    downloads: Number(app.downloads ?? 0),
    reviews: Number(app.reviews ?? 0),
    // publishedAt 后端为 "YYYY-MM-DD"，目前仅展示，保留字符串即可
  }
}

/**
* 拉取应用列表（后端已支持 sort/order/page/size）
* @param {Object} params
* @param {number} params.page - 第几页（从1开始）
* @param {number} params.size - 每页条数
* @param {'rating'|'downloads'|'published_at'|'id'} params.sort - 排序字段
* @param {'asc'|'desc'} params.order - 升/降序
* @returns {Promise<{items:any[], total:number, page:number, size:number, sort:string, order:string}>}
*/
export async function getApps({ page = 1, size = 12, sort = 'rating', order = 'desc' } = {}) {
  if (USE_MOCK) {
    // 本地 mock 也按相同规则“排+分”，这样你切换 mock/真实后端体验一致
    let items = mock.map(normalize)
    if (sort === 'rating') items.sort((a, b) => a.rating - b.rating)
    if (sort === 'downloads') items.sort((a, b) => a.downloads - b.downloads)
    if (sort === 'published_at') items.sort((a, b) => String(a.publishedAt).localeCompare(String(b.publishedAt)))
    if (sort === 'id') items.sort((a, b) => a.id - b.id)
    if (order === 'desc') items.reverse()
    const start = (page - 1) * size
    const end = start + size
    return {
      items: items.slice(start, end),
      total: items.length,
      page,
      size,
      sort,
      order
    }
  }

  // 由于响应拦截器已解包，直接拿到后端的 PageResult
  const res = await http.get('/apps', { params: { page, size, sort, order } })
  // res 形如：{ items, total, page, size, sort, order }
  return {
    ...res,
    items: (res.items ?? []).map(normalize)
  }
}