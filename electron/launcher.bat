@echo off
REM Totoro-paradise 独立窗口启动器 (Windows)

chcp 65001 >nul
setlocal enabledelayedexpansion

cd /d "%~dp0.."

:menu
cls
echo ╔═════════════════════════════════════════════════════╗
echo ║     Totoro-paradise 独立窗口启动器                   ║
echo ╚═════════════════════════════════════════════════════╝
echo.
echo   1. 启动独立窗口 (生产模式)
echo   2. 启动独立窗口 (开发模式)
echo   3. 构建桌面应用 (可分发)
echo   4. 安装 Electron 依赖
echo   5. 检查依赖
echo   0. 退出
echo.

set /p choice=请选择 (0-5): 

if "%choice%"=="1" goto launch_prod
if "%choice%"=="2" goto launch_dev
if "%choice%"=="3" goto build_app
if "%choice%"=="4" goto install_deps
if "%choice%"=="5" goto check_deps
if "%choice%"=="0" goto exit

echo [ERROR] 无效选择,请重试
pause
goto menu

:launch_prod
echo [INFO] 启动独立窗口 (生产模式)...
echo [WARNING] 请确保已运行 'pnpm build' 构建项目
echo.
set NODE_ENV=production
node electron\main.js
goto end

:launch_dev
echo [INFO] 启动独立窗口 (开发模式)...
echo [WARNING] 这将启动开发服务器并打开独立窗口
echo.
set NODE_ENV=development
node electron\main.js
goto end

:build_app
echo [INFO] 构建桌面应用...
echo.
echo [INFO] 构建 Nuxt 项目...
call npx pnpm build
if %errorlevel% neq 0 (
    echo [ERROR] Nuxt 项目构建失败
    pause
    goto end
)
echo [SUCCESS] Nuxt 项目构建完成
echo.
echo [INFO] 构建桌面应用包...
call npx electron-builder
if %errorlevel% equ 0 (
    echo [SUCCESS] 桌面应用构建完成!
    echo [INFO] 输出目录: dist-electron\
) else (
    echo [ERROR] 桌面应用构建失败
)
goto end

:install_deps
echo [INFO] 安装 Electron 依赖...
if not exist "node_modules\electron" (
    call npm install --no-save electron electron-builder cross-env
    echo [SUCCESS] Electron 依赖安装完成
) else (
    echo [SUCCESS] Electron 依赖已存在
)
goto menu

:check_deps
echo [INFO] 检查依赖...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js 未安装
) else (
    echo [SUCCESS] Node.js 已安装: 
    node -v
)
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm 未安装
) else (
    echo [SUCCESS] npm 已安装: 
    npm -v
)
goto menu

:exit
echo [INFO] 再见!
exit /b 0

:end
pause
