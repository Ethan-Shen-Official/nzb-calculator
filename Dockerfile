# 多阶段构建：第一阶段构建应用
FROM node:18-alpine AS build-stage

WORKDIR /app

# 复制 package.json 和 package-lock.json（如果存在）
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制源代码
COPY . .

# 直接使用 vite build，跳过 vue-tsc 类型检查
RUN npx vite build

# 第二阶段：使用 nginx 服务静态文件
FROM nginx:alpine AS production-stage

# 复制构建产物到 nginx 默认目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 复制 nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]