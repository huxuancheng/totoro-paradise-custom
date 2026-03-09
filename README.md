# Totoro-paradise 改进版

> Fuck `totoro school`, without MITM.

The name is netaed from `nekopara`.

---

## ✨ 改进功能

相较于原版的主要改进:

- ✨ **新增自定义跑步时长功能** - 可精确到秒
- ✨ **支持分钟和秒数分别输入** - 更灵活的时间控制
- 🐛 **修复自定义时间导致的卡死问题**
- 📚 **添加启动脚本** - `start.sh` 和 `launch-app.sh`
- 📚 **添加使用说明文档** - 中文使用指南

## 🏗️ How to build

```bash
pnpm i
pnpm build
```

## 🚀 部署方法

### Linux / macOS

#### 方式一: 使用启动脚本 (推荐)

```bash
# 赋予执行权限
chmod +x start.sh launch-app.sh

# 运行启动脚本
bash start.sh
# 或
./start.sh
```

#### 方式二: 直接运行

```bash
# 安装依赖
npx pnpm i

# 开发模式 (热重载)
npx pnpm dev

# 生产模式
npx pnpm build
npx pnpm start
```

#### 方式三: 使用 Docker

```bash
# 构建并运行
docker-compose up -d

# 停止
docker-compose down

# 查看日志
docker-compose logs -f
```

### Windows

#### 方式一: 使用 Git Bash / WSL

```bash
# 在 Git Bash 或 WSL 中运行
bash start.sh
```

#### 方式二: 使用 PowerShell / CMD

```bash
# 安装依赖
npm install -g pnpm
pnpm install

# 开发模式
pnpm dev

# 生产模式
pnpm build
pnpm start
```

#### 方式三: 使用 Docker Desktop

```bash
# 在 PowerShell 或 CMD 中运行
docker-compose up -d
```

### 使用 Docker 部署 (跨平台)

```bash
# 构建镜像
docker build -t totoro-paradise .

# 运行容器
docker run -d -p 3000:3000 totoro-paradise

# 或使用 docker-compose
docker-compose up -d
```

## ⚛️ How to develop

```bash
pnpm dev
```

访问地址: http://localhost:3000

## 📝 使用说明

详细使用说明请参考 [使用说明.md](./使用说明.md)

## 🔗 原项目

原项目已归档，不再维护: https://github.com/BeiyanYunyi/totoro-paradise

## 📝 License

[AGPL-3.0](LICENSE)
