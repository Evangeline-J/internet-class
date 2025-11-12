<template>
  <div class="about-container">
    <!-- 卡片容器 -->
    <div class="content-card">
      
      <!-- 个人信息部分 -->
      <div v-if="userInfo" class="user-info-section">
        <h2>个人信息</h2>
        <ul>
          <li><strong>用户ID:</strong> {{ userInfo.id }}</li>
          <li><strong>用户名:</strong> {{ userInfo.username }}</li>
          <li v-if="userInfo.email"><strong>邮箱:</strong> {{ userInfo.email || '未设置' }}</li>
        </ul>
      </div>

      <!-- 分隔线 -->
      <hr class="divider" />

      <!-- 新增：管理员操作区域 -->
      <div class="admin-action-section">
        <h2>危险操作</h2>
        <p>这是一个只有管理员才能成功执行的操作。</p>
        
        <!-- 新增: 输入框和绑定数据 -->
        <div class="form-group">
          <label for="delete-user-id">要删除的用户ID：</label>
          <!-- 使用 v-model 绑定到 deleteUserId 变量，.number 修饰符确保它是数字类型 -->
          <input 
            type="number" 
            id="delete-user-id" 
            v-model.number="deleteUserId" 
            placeholder="输入用户ID，例如 7"
            min="1"
          />
        </div>

        <button class="danger-button" @click="handleAdminAction" :disabled="isButtonDisabled">
          尝试删除用户 (管理员操作)
        </button>
        <!-- 按钮在 deleteUserId 为空、0或无效数字时禁用 -->

      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { getUserInfo } from '@/utils/auth'; 
import { deleteUser } from '@/api/admin'; 

// 创建一个响应式变量来存储用户信息
const userInfo = ref(null);

// 【新增】创建一个响应式变量来存储用户输入的要删除的ID
const deleteUserId = ref(null); 

// 计算属性：判断按钮是否应该被禁用
const isButtonDisabled = computed(() => {
  // 如果 deleteUserId 为空、null、undefined、0 或 NaN，则禁用按钮
  return !deleteUserId.value || deleteUserId.value <= 0 || isNaN(deleteUserId.value);
});

// 组件挂载后获取用户信息
onMounted(() => {
  userInfo.value = getUserInfo();
});

// 定义点击按钮时触发的异步方法
const handleAdminAction = async () => {
  // 1. 验证输入
  if (!deleteUserId.value || deleteUserId.value <= 0) {
    alert('请输入一个有效的用户ID。');
    return;
  }
  
  // 2. 确认操作
  if (!confirm(`警告：您确定要尝试删除用户ID为 ${deleteUserId.value} 的用户吗？`)) {
    return;
  }

  try {
    console.log(`正在尝试调用管理员接口删除用户ID: ${deleteUserId.value}...`);
    
    // 3. 【核心修改】调用 API，使用 deleteUserId.value
    const response = await deleteUser({ userId: deleteUserId.value });
    
    // 如果接口调用成功
    console.log('管理员操作成功:', response);
    alert(`操作成功！已发送删除用户 ${deleteUserId.value} 的请求。`);

  } catch (error) {
    // 【核心修改】在这里处理不同的错误类型
    console.error('管理员操作失败:', error);
    
    // 检查拦截器传过来的错误码
    if (error.code === 403 || (error.code && Math.floor(error.code / 100) === 403)) {
      // 如果是 403 错误（HTTP状态码403或业务错误码403xx），显示权限不足的提示
      alert('您无此权限！');
    } else {
      // 对于其他错误 (如 404 用户不存在, 500 服务器异常等)
      // 显示从拦截器传过来的通用错误信息
      const errorMessage = error.message || '未知错误';
      alert(`操作失败: ${errorMessage}`);
    }
  }
};
</script>

<style scoped>
/* 保持原有的样式，仅对新增的表单元素进行补充 */
.about-container {
  padding: 32px;
  background-color: #f0f2f5;
  min-height: calc(100vh - 50px);
}

.content-card {
  background: #ffffff;
  padding: 24px 40px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  max-width: 800px;
  margin: 0 auto;
}

h2 {
  font-size: 1.5em;
  color: #1f2d3d;
  margin-top: 0;
  margin-bottom: 20px;
}

.user-info-section ul {
  list-style-type: none;
  padding: 0;
}

.user-info-section li {
  font-size: 1.1em;
  color: #333;
  margin-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
  padding-bottom: 12px;
}

.user-info-section li:last-child {
  border-bottom: none;
}

.divider {
  border: none;
  border-top: 1px solid #e9ecef;
  margin: 40px 0;
}

/* 管理员操作部分 */
.admin-action-section p {
  color: #5a6d80;
  margin-bottom: 20px;
}

/* 新增表单样式 */
.form-group {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
}

.form-group label {
  font-weight: 600;
  color: #3c4858;
  white-space: nowrap; /* 防止标签换行 */
}

.form-group input {
  padding: 8px 12px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  flex-grow: 1; /* 让输入框占据剩余空间 */
  max-width: 200px;
}

.danger-button {
  background-color: #f56c6c;
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1em;
  transition: background-color 0.3s;
}

.danger-button:hover:not(:disabled) {
  background-color: #e84a4a;
}

.danger-button:disabled {
    background-color: #fab6b6; /* 禁用状态下的颜色 */
    cursor: not-allowed;
}
</style>