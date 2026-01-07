# 智能体应用管理与客服助手（前后端分离）

一个包含前端（Vue 3 + Vite + Pinia + Element Plus）与后端（Spring Boot 3 + MyBatis）的完整示例项目：

- 登录后进入“仪表盘（应用列表）”，可浏览应用卡片；点击“智能客服助手”进入聊天页；
- 聊天页左侧为会话（Session）列表，可新建/切换/删除；右侧为会话对话区，后端使用 DeepSeek 接口（可替换为你自己的 Key/模型）；
- 左侧侧边菜单（仪表盘/关于/系统管理等）与后端返回菜单联动；
- 提供 Docker 一键启动（MySQL + 后端 + 前端）。


## 目录结构

```text
.
├─ demo/                         # 后端（Spring Boot）
│  ├─ src/main/java/com/example/demo
│  │  ├─ auth/…                  # 登录、权限相关
│  │  ├─ app/…                   # 菜单、应用列表等
│  │  ├─ chat/                   # 聊天模块（本项目新增）
│  │  │  ├─ controller/ChatController.java
│  │  │  ├─ dto/…
│  │  │  ├─ entity/ChatSession.java / ChatMessage.java
│  │  │  ├─ mapper/ChatSessionMapper.java / ChatMessageMapper.java
│  │  │  └─ service/DeepSeekClient.java / ChatServiceImpl.java
│  │  └─ common/…                # 统一返回、异常处理
│  ├─ pom.xml
│  └─ Dockerfile                 # 后端镜像（多阶段：Maven 打包 → JRE 运行）
│
├─ vue-project/                  # 前端（Vue 3 + Vite）
│  ├─ src/
│  │  ├─ api/                    # axios 封装与模块 API（chat.js / menu.js 等）
│  │  ├─ components/             # 组件（AppCard、SidebarMenu 等）
│  │  ├─ layouts/MainLayout.vue  # 顶部栏 + 侧边栏 + 内容区布局
│  │  ├─ views/AppsView.vue      # 仪表盘（应用列表）
│  │  ├─ views/ChatView.vue      # 客服助手聊天页（会话 + 对话）
│  │  ├─ views/LoginView.vue     # 登录页
│  │  ├─ views/AboutView.vue     # 关于页（含管理员演示操作）
│  │  ├─ stores/menu.js          # 菜单与动态路由生成
│  │  └─ router/index.js         # 路由守卫（登录态 + 动态路由）
│  ├─ package.json
│  ├─ Dockerfile                 # 前端镜像（Node 20 构建 → Nginx 托管）
│  └─ nginx.conf                 # /api 反代至后端
│
├─ docker-mysql/
│  └─ init/                      # 放置初始化 SQL（demo_db.sql）
│
└─ docker-compose.yml            # MySQL + Backend + Frontend 一键编排
```


## 主要界面与功能说明

### 1. 登录页（LoginView）
- 输入“用户名/密码”登录；成功后会通过 Pinia 拉取后端菜单并生成动态路由；
- 登录跳转至 `AppsView`（仪表盘）。

### 2. 仪表盘（AppsView）
- 展示“智能体应用列表”，支持排序、分页；
- 卡片样式优化，并处理头像加载失败的占位背景；
- 点击“智能客服助手”卡片会跳转至 `/chat` 页面。

### 3. 聊天页（ChatView）
- 左侧 Session 栏：
  - 列表显示历史会话；
  - “新建”按钮快速创建；
  - 右键（或长按）会话条目删除该会话；
- 右侧对话区：
  - 发送消息后，后端调用 DeepSeek 模型生成回复；
  - 若模型返回包含 `<think>…</think>` 或仅 `</think>`（部分 R1 模型），前端会拆分“思考内容”和“正式回复”分别渲染：
    - “思考内容”使用浅橙底、等宽字体，并标记 THINK；
    - “正式回复”按普通气泡展示；
  - 历史消息、上下文会被保存至数据库。

### 4. 关于页（AboutView）
- 展示当前登录用户信息；
- 提供管理员演示操作（删除用户）按钮，403 会显示“您无此权限！”。

### 5. 布局与菜单
- 顶栏（Header）与侧边栏（Sidebar）采用浅色渐变并与登录页色调统一；
- 侧边栏支持多级菜单、选中高亮与层级缩进线；
- 菜单从后端加载并生成动态路由（`stores/menu.js`）。


## 后端接口（节选）

- 登录：`POST /api/v1/auth/login`
- 菜单：`GET /api/v1/menus`
- 聊天：
  - `POST /api/v1/chat/sessions` 创建会话 → 返回会话对象
  - `GET  /api/v1/chat/sessions` 会话列表（当前用户）
  - `DELETE /api/v1/chat/sessions/{id}` 删除会话（软删除 + 清理消息）
  - `GET  /api/v1/chat/sessions/{id}/messages` 历史消息
  - `POST /api/v1/chat/sessions/{id}/messages` 发送消息 → 返回助手回复（已入库）

> DeepSeek Key 在 `demo/src/main/java/com/example/demo/chat/service/DeepSeekClient.java` 中配置。


## 数据库

请先导入 `demo_db.sql`（项目已在 `docker-mysql/init/` 预留初始化目录）。

聊天相关新增表（已在文档/迁移中给出，若你需要手动创建，可参考）：

```sql
-- 会话表
CREATE TABLE IF NOT EXISTS chat_session (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  title VARCHAR(255) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_user_id(user_id),
  KEY idx_updated_at(updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 消息表
CREATE TABLE IF NOT EXISTS chat_message (
  id BIGINT NOT NULL AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  role VARCHAR(20) NOT NULL, -- "user" | "assistant"
  content LONGTEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_session_id(session_id),
  CONSTRAINT fk_chat_message_session FOREIGN KEY (session_id) REFERENCES chat_session(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```


## 本地开发

前端（Node 20+）
```bash
cd vue-project
npm i
npm run dev
# 默认 Vite 5173 端口
```

后端（JDK 17）
```bash
cd demo
mvn -DskipTests package
java -jar target/*.jar
# 默认 8080 端口
```

注意：前端 `.env` 中通过 `VITE_BASE_API`（或在代码中使用的 http 封装）访问后端默认 `/api` 前缀；开发模式下建议配置代理或直接写后端地址。


## Docker 一键启动

### 1）放置初始化 SQL
将你的 `demo_db.sql` 文件复制到：
```
docker-mysql/init/01_demo_db.sql
```
容器首次启动会自动导入。

### 2）构建与启动
```bash
docker compose up -d --build
```

服务与端口：
- MySQL：容器内部 3306（不暴露对外），数据卷 `mysql_data`
- Backend：`http://localhost:8080`
- Frontend：`http://localhost:5173`

前端 Nginx 把 `/api` 反向代理到 `backend:8080/api`（见 `vue-project/nginx.conf`）。

### 3）镜像拉取失败（国内网络）
若构建阶段拉取 `node:20-alpine` 或 `nginx:1.25-alpine` 失败，可在 Docker Desktop 的 Docker Engine 中配置加速（示例）：
```json
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://hub-mirror.c.163.com",
    "https://mirror.ccs.tencentyun.com"
  ]
}
```
保存并重启 Docker 后，重新执行 `docker compose up -d --build`。

也可按需将 `Dockerfile` 增加可配置的 `REGISTRY` 构建参数，切换国内镜像前缀。


## 深度配置

- DeepSeek API：
  - 修改 `demo/chat/service/DeepSeekClient.java` 中的 `API_KEY`、`ENDPOINT`、`MODEL`。
  - 生产建议改为读取环境变量或配置中心（例如 Spring 配置项）。
- 登录鉴权：
  - 鉴权与菜单逻辑在 `auth/*`、`security/*`、`stores/menu.js` 中。
- 思考与正式回复分离：
  - 前端 `ChatView.vue` 中 `splitAssistant` 支持解析 `<think>…</think>` 以及仅返回 `</think>` 的情况。


## 常见问题

- 构建时报 Node 版本错误：
  - Vite 7 需要 Node 20.19+ 或 22.12+，请确保本地/镜像 Node 版本满足要求（本项目 Dockerfile 已使用 `node:20-alpine`）。
- 删除会话后列表未刷新：
  - 已在 `http.js` 拦截器中对空响应体（DELETE/204）做兼容，若之前缓存了旧前端，请刷新页面。


## License
本项目仅用于学习演示，涉及到的第三方 API Key 请自行妥善保管与配置。欢迎按需扩展与二次开发。 


