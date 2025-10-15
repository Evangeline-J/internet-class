<script setup>
import { ref, onMounted } from 'vue'
import AppCard from '@/components/AppCard.vue'
import { getApps } from '@/data/getApps'

const list = ref([])
const total = ref(0)
const page = ref(1)
const size = ref(12)
const sort = ref('rating')        // 与后端白名单一致：rating | downloads | published_at | id
const order = ref('desc')         // 默认高->低

const loading = ref(false)
const error = ref('')

async function load() {
  loading.value = true
  try {
    const res = await getApps({ page: page.value, size: size.value, sort: sort.value, order: order.value })
    list.value = res.items
    total.value = res.total ?? list.value.length
  } catch (e) {
    error.value = e?.message || '加载失败'
  } finally {
    loading.value = false
  }
}

function onChangeSort(v) {
  if (sort.value !== v) {
    sort.value = v
    page.value = 1
    load()
  }
}

function toggleOrder() {
  order.value = order.value === 'desc' ? 'asc' : 'desc'
  page.value = 1
  load()
}

function onPageChange(p) {
  page.value = p
  load()
}

onMounted(load)
</script>

<template>
  <section class="min-h-dvh bg-slate-50 text-slate-800 antialiased">
    <div class="mx-auto max-w-screen-xl px-4 py-6 space-y-5">
      <header class="space-y-1">
        <h2 class="text-lg font-medium text-slate-900">智能体应用列表</h2>
        <p class="text-sm text-slate-500">轻量卡片栅格，移动优先，自适应多端。</p>
      </header>


      <!-- 工具栏：排序 + 升降序 -->
      <div class="flex flex-wrap items-center gap-3">
        <span class="text-slate-500">排序：</span>
        <el-select :model-value="sort" @change="onChangeSort" style="width: 160px">
          <el-option label="评分" value="rating" />
          <el-option label="下载量" value="downloads" />
          <el-option label="发布时间" value="published_at" />
          <el-option label="默认（ID）" value="id" />
        </el-select>
        <el-button @click="toggleOrder" plain>
          {{ order === 'desc' ? '高→低' : '低→高' }}
        </el-button>
        <span class="ml-auto text-sm text-slate-500" v-if="total">共 {{ total }} 个应用</span>
      </div>


      <!-- 加载态 -->
      <el-skeleton v-if="loading" animated :count="6">
        <template #template>
          <div class="grid gap-5 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
            <div class="rounded-2xl border border-slate-200 bg-white p-5">
              <el-skeleton-item variant="image" style="width:56px;height:56px;border-radius:12px" />
              <el-skeleton-item variant="h1" style="width:60%;margin-top:12px" />
              <el-skeleton-item variant="text" />
              <el-skeleton-item variant="text" style="width:80%" />
            </div>
          </div>
        </template>
      </el-skeleton>

      <!-- 错误态 -->
      <el-alert v-else-if="error" type="error" :title="error" show-icon />

      <!-- 空态 -->
      <el-empty v-else-if="!list.length" description="暂无应用" />

      <!-- 数据态 -->
      <div v-else class="grid gap-5 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
        <AppCard v-for="item in list" :key="item.id" :item="item" />
      </div>

      <!-- 分页 -->
      <div class="flex justify-end">
        <el-pagination
          v-if="total > size"
          background
          layout="prev, pager, next"
          :page-size="size"
          :current-page="page"
          :total="total"
          @current-change="onPageChange"
        />
      </div>

    </div>
  </section>
</template>