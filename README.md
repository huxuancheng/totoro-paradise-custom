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

### 前置要求

- Node.js >= 18.0.0
- pnpm >= 8.0.0
- Docker (可选,用于容器化部署)

### Linux / macOS

#### 环境准备

```bash
# 安装 Node.js (以 Ubuntu 为例)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 安装 pnpm
npm install -g pnpm

# 或使用 corepack 启用 pnpm
corepack enable
corepack prepare pnpm@latest --activate
```

#### 方式一: 使用启动脚本 (推荐)

```bash
# 1. 克隆项目
git clone https://github.com/huxuancheng/totoro-paradise-custom.git
cd totoro-paradise-custom

# 2. 赋予执行权限
chmod +x start.sh launch-app.sh

# 3. 运行启动脚本 (交互式菜单)
bash start.sh
# 或
./start.sh

# 4. 选择选项:
#    1 - 开发模式 (热重载, http://localhost:3000)
#    2 - 构建项目
#    3 - 运行生产版本
#    4 - 生成静态站点
#    5 - 预览构建结果
#    6 - 清理缓存
#    7 - 检查项目状态
#    0 - 退出
```

#### 方式二: 直接运行

```bash
# 1. 安装依赖
npx pnpm install

# 2. 开发模式 (支持热重载,适合开发调试)
npx pnpm dev
# 访问: http://localhost:3000
# 按 Ctrl+C 停止服务

# 3. 生产模式 (构建后运行,性能更好)
npx pnpm build
npx pnpm start
# 访问: http://localhost:3000
# 按 Ctrl+C 停止服务
```

#### 方式三: 使用 Docker

```bash
# 1. 安装 Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# 重新登录以使组权限生效

# 2. 构建并运行 (使用 docker-compose)
docker-compose up -d

# 3. 查看服务状态
docker-compose ps

# 4. 查看日志
docker-compose logs -f

# 5. 停止服务
docker-compose down

# 6. 停止并删除数据卷
docker-compose down -v
```

### Windows

#### 环境准备

**方式一: 使用 WSL2 (推荐)**

```powershell
# 1. 启用 WSL2
wsl --install

# 2. 在 WSL Ubuntu 中安装 Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. 安装 pnpm
npm install -g pnpm
```

**方式二: 使用 Git Bash**

1. 下载并安装 [Git for Windows](https://git-scm.com/download/win)
2. 下载并安装 [Node.js LTS](https://nodejs.org/)
3. 打开 Git Bash 执行命令

**方式三: 使用 PowerShell/CMD**

1. 下载并安装 [Node.js LTS](https://nodejs.org/)
2. 打开 PowerShell 安装 pnpm: `npm install -g pnpm`

#### 部署方式

**方式一: 使用 Git Bash / WSL**

```bash
# 1. 克隆项目
git clone https://github.com/huxuancheng/totoro-paradise-custom.git
cd totoro-paradise-custom

# 2. 运行启动脚本
bash start.sh

# 或直接运行开发模式
npx pnpm dev
```

**方式二: 使用 PowerShell**

```powershell
# 1. 克隆项目
git clone https://github.com/huxuancheng/totoro-paradise-custom.git
cd totoro-paradise-custom

# 2. 安装依赖
pnpm install

# 3. 开发模式
pnpm dev

# 4. 生产模式
pnpm build
pnpm start
```

**方式三: 使用 Docker Desktop**

1. 下载并安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
2. 启动 Docker Desktop
3. 在 PowerShell 或 CMD 中执行:

```powershell
# 克隆项目
git clone https://github.com/huxuancheng/totoro-paradise-custom.git
cd totoro-paradise-custom

# 构建并运行
docker-compose up -d

# 访问 http://localhost:3000
```

### Docker 部署 (跨平台通用)

```bash
# 1. 克隆项目
git clone https://github.com/huxuancheng/totoro-paradise-custom.git
cd totoro-paradise-custom

# 2. 构建 Docker 镜像
docker build -t totoro-paradise .

# 3. 运行容器
docker run -d \
  --name totoro-paradise \
  -p 3000:3000 \
  --restart unless-stopped \
  totoro-paradise

# 4. 查看容器状态
docker ps

# 5. 查看日志
docker logs -f totoro-paradise

# 6. 停止容器
docker stop totoro-paradise

# 7. 删除容器
docker rm totoro-paradise

# 使用 docker-compose (推荐)
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
