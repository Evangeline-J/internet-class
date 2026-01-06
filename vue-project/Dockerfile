# ===== Frontend (Vue 3 + Vite) - Multi-stage build
# Stage 1: build static assets
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --no-audit --no-fund
COPY . .
# 在构建时可通过 --build-arg BASE_API 修改后端代理前缀（默认 /api 走 Nginx 反代）
ARG BASE_API=/api
ENV VITE_BASE_API=${BASE_API}
RUN npm run build

# Stage 2: serve by nginx and proxy /api to backend
FROM nginx:1.25-alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx","-g","daemon off;"]


