# Electron 独立窗口启动器

将 Totoro-paradise 打包为独立桌面应用,无需依赖浏览器运行。

## 快速开始

### Linux / macOS

```bash
# 1. 安装依赖
npm install --no-save electron electron-builder cross-env

# 2. 构建项目
npx pnpm build

# 3. 启动独立窗口
bash electron/launcher.sh

# 或直接运行
NODE_ENV=production node electron/main.js
```

### Windows

```powershell
# 1. 安装依赖
npm install --no-save electron electron-builder cross-env

# 2. 构建项目
npx pnpm build

# 3. 启动独立窗口
electron\launcher.bat

# 或直接运行
set NODE_ENV=production
node electron\main.js
```

## 功能特性

- ✨ 独立窗口运行,不依赖浏览器
- ✨ 跨平台支持 (Windows/macOS/Linux)
- ✨ 开发模式支持热重载
- ✨ 生产模式性能优化
- ✨ 可打包为可执行文件分发

## 使用说明

### 方式一: 使用启动脚本 (推荐)

**Linux/macOS:**
```bash
bash electron/launcher.sh
```

**Windows:**
```cmd
electron\launcher.bat
```

菜单选项:
- 1. 启动独立窗口 (生产模式)
- 2. 启动独立窗口 (开发模式)
- 3. 构建桌面应用 (可分发)
- 4. 安装 Electron 依赖
- 5. 检查依赖

### 方式二: 直接运行

**生产模式:**
```bash
# 先构建项目
npx pnpm build

# 启动独立窗口
NODE_ENV=production node electron/main.js
```

**开发模式:**
```bash
# 启动开发服务器并打开独立窗口
NODE_ENV=development node electron/main.js
```

### 方式三: 打包桌面应用

构建可分发的桌面应用安装包:

**所有平台:**
```bash
npx electron-builder
```

**仅 Windows:**
```bash
npx electron-builder --win
```

**仅 macOS:**
```bash
npx electron-builder --mac
```

**仅 Linux:**
```bash
npx electron-builder --linux
```

输出文件位于 `dist-electron/` 目录:

| 平台 | 输出格式 |
|------|----------|
| Windows | .exe (NSIS 安装程序) / .exe (便携版) |
| macOS | .dmg / .zip |
| Linux | .AppImage / .deb / .rpm |

## 配置说明

### 窗口配置

编辑 `electron/main.js` 可以修改窗口配置:

```javascript
const mainWindow = new BrowserWindow({
  width: 1280,        // 窗口宽度
  height: 800,        // 窗口高度
  minWidth: 800,     // 最小宽度
  minHeight: 600,    // 最小高度
  title: 'Totoro-paradise 跑步打卡工具',  // 窗口标题
})
```

### 应用图标

将图标文件放入 `build/` 目录:
- Windows: `icon.ico`
- macOS: `icon.icns`
- Linux: `icon.png`

## 注意事项

1. **首次使用前必须构建项目**: `npx pnpm build`
2. **生产模式占用资源更少**: 推荐生产模式使用
3. **开发模式支持热重载**: 适合开发调试
4. **打包应用前先构建**: 确保项目已构建

## 常见问题

### Q: 启动时提示找不到模块?

A: 确保已安装 Electron 依赖:
```bash
npm install --no-save electron electron-builder cross-env
```

### Q: 窗口打开后显示空白?

A: 确保已构建项目:
```bash
npx pnpm build
```

### Q: 如何禁用开发者工具?

A: 在 `electron/main.js` 中删除以下行:
```javascript
mainWindow.webContents.openDevTools()
```

## 技术栈

- **Electron** - 桌面应用框架
- **Node.js** - 运行时环境
- **Nuxt 3** - Web 框架

## 许可证

AGPL-3.0
