#!/bin/bash
# Totoro-paradise 独立窗口启动器

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR" || exit 1

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 检查依赖
check_dependencies() {
    print_info "检查依赖..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js 未安装"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm 未安装"
        exit 1
    fi
    
    print_success "依赖检查通过"
}

# 安装 Electron 依赖
install_electron_deps() {
    print_info "安装 Electron 依赖..."
    
    if [ ! -d "node_modules/electron" ]; then
        npm install --no-save electron electron-builder cross-env
        print_success "Electron 依赖安装完成"
    else
        print_success "Electron 依赖已存在"
    fi
}

# 启动独立窗口
launch_app() {
    print_info "启动独立窗口应用..."
    print_warning "请确保已运行 'pnpm build' 构建项目"
    echo ""
    
    NODE_ENV=production node electron/main.js
}

# 开发模式启动
launch_dev() {
    print_info "启动开发模式..."
    print_warning "这将启动开发服务器并打开独立窗口"
    echo ""
    
    NODE_ENV=development node electron/main.js
}

# 构建桌面应用
build_app() {
    print_info "构建桌面应用..."
    
    # 先构建 Nuxt 项目
    print_info "构建 Nuxt 项目..."
    npx pnpm build
    
    if [ $? -ne 0 ]; then
        print_error "Nuxt 项目构建失败"
        exit 1
    fi
    
    print_success "Nuxt 项目构建完成"
    
    # 构建桌面应用
    print_info "构建桌面应用包..."
    npx electron-builder
    
    if [ $? -eq 0 ]; then
        print_success "桌面应用构建完成!"
        print_info "输出目录: dist-electron/"
    else
        print_error "桌面应用构建失败"
        exit 1
    fi
}

# 显示菜单
show_menu() {
    echo ""
    echo "╔═════════════════════════════════════════════════════╗"
    echo "║     Totoro-paradise 独立窗口启动器                   ║"
    echo "╚═════════════════════════════════════════════════════╝"
    echo ""
    echo "  1. 启动独立窗口 (生产模式)"
    echo "  2. 启动独立窗口 (开发模式)"
    echo "  3. 构建桌面应用 (可分发)"
    echo "  4. 安装 Electron 依赖"
    echo "  5. 检查依赖"
    echo "  0. 退出"
    echo ""
}

# 主函数
main() {
    while true; do
        show_menu
        read -p "请选择 (0-5): " choice
        echo ""
        
        case $choice in
            1)
                launch_app
                break
                ;;
            2)
                launch_dev
                break
                ;;
            3)
                build_app
                break
                ;;
            4)
                install_electron_deps
                ;;
            5)
                check_dependencies
                ;;
            0)
                print_info "再见!"
                exit 0
                ;;
            *)
                print_error "无效选择,请重试"
                ;;
        esac
        
        echo ""
        read -p "按 Enter 继续..."
        clear
    done
}

# 运行主函数
main
