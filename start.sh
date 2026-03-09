#!/bin/bash
# Totoro-paradise 应用启动脚本

PROJECT_DIR="$HOME/Desktop/totoro-paradise"
cd "$PROJECT_DIR" || exit 1

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
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

# 显示菜单
show_menu() {
    echo ""
    echo "╔═════════════════════════════════════════════════════╗"
    echo "║     Totoro-paradise 应用启动菜单                    ║"
    echo "╚═════════════════════════════════════════════════════╝"
    echo ""
    echo "  1. 开发模式 (Development Mode)"
    echo "  2. 构建项目 (Build Project)"
    echo "  3. 运行生产版本 (Run Production)"
    echo "  4. 生成静态站点 (Generate Static Site)"
    echo "  5. 预览构建结果 (Preview Build)"
    echo "  6. 清理缓存 (Clean Cache)"
    echo "  7. 检查项目状态 (Check Status)"
    echo "  8. 查看日志 (View Logs)"
    echo "  0. 退出 (Exit)"
    echo ""
}

# 开发模式
dev_mode() {
    print_info "启动开发模式..."
    echo ""
    echo "访问地址: http://localhost:3000"
    echo "按 Ctrl+C 停止"
    echo ""
    npx pnpm dev
}

# 构建项目
build_project() {
    print_info "构建项目..."
    npx pnpm build

    if [ $? -eq 0 ]; then
        print_success "构建成功！"
        print_info "运行 'npx pnpm start' 启动生产版本"
    else
        print_error "构建失败"
    fi
}

# 运行生产版本
run_production() {
    if [ ! -d ".output" ]; then
        print_warning "未找到构建输出，正在构建..."
        build_project
    fi

    print_info "启动生产版本..."
    echo ""
    echo "访问地址: http://localhost:3000"
    echo "按 Ctrl+C 停止"
    echo ""
    npx pnpm start
}

# 生成静态站点
generate_static() {
    print_info "生成静态站点..."
    npx pnpm generate

    if [ $? -eq 0 ]; then
        print_success "静态站点生成成功！"
        print_info "输出目录: .output/public"
        print_info "使用 'npx pnpm preview' 预览"
    else
        print_error "生成失败"
    fi
}

# 预览构建
preview_build() {
    if [ ! -d ".output" ]; then
        print_error "未找到构建输出，请先运行 'npx pnpm build'"
        return
    fi

    print_info "预览构建结果..."
    echo ""
    echo "访问地址: http://localhost:3000"
    echo "按 Ctrl+C 停止"
    echo ""
    npx pnpm preview
}

# 清理缓存
clean_cache() {
    print_info "清理缓存..."
    print_warning "这将删除以下目录："
    echo "  - .nuxt/"
    echo "  - .output/"
    echo "  - node_modules/.cache/"
    echo ""

    read -p "确认清理？(y/N): " confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        rm -rf .nuxt .output node_modules/.cache
        print_success "缓存清理完成"
    else
        print_info "已取消"
    fi
}

# 检查状态
check_status() {
    echo ""
    echo "╔═════════════════════════════════════════════════════╗"
    echo "║     项目状态检查                                      ║"
    echo "╚═════════════════════════════════════════════════════╝"
    echo ""

    # Node.js 版本
    echo -n "Node.js 版本: "
    node -v 2>/dev/null && print_success "" || print_error "未安装"

    # npm 版本
    echo -n "npm 版本: "
    npm -v 2>/dev/null && print_success "" || print_error "未安装"

    # pnpm 版本
    echo -n "pnpm 版本: "
    npx pnpm --version 2>/dev/null && print_success "" || print_error "未安装"

    echo ""

    # 检查 node_modules
    if [ -d "node_modules" ]; then
        print_success "node_modules 存在"
        package_count=$(ls -1 node_modules 2>/dev/null | wc -l)
        echo "  已安装 $package_count 个包"
    else
        print_warning "node_modules 不存在"
    fi

    # 检查构建输出
    if [ -d ".output" ]; then
        print_success ".output 构建输出存在"
    else
        print_warning ".output 构建输出不存在"
    fi

    # 检查缓存
    if [ -d ".nuxt" ]; then
        print_success ".nuxt 缓存存在"
    else
        print_warning ".nuxt 缓存不存在"
    fi

    echo ""

    # 项目信息
    if [ -f "package.json" ]; then
        name=$(grep '"name"' package.json | head -1 | cut -d'"' -f4)
        version=$(grep '"version"' package.json | head -1 | cut -d'"' -f4)
        print_info "项目名称: $name"
        print_info "项目版本: $version"
    fi

    # Git 信息
    if [ -d ".git" ]; then
        branch=$(git branch --show-current 2>/dev/null)
        commit=$(git rev-parse --short HEAD 2>/dev/null)
        print_info "Git 分支: $branch"
        print_info "Git 提交: $commit"
    fi

    echo ""
}

# 查看日志
view_logs() {
    print_info "最近的构建日志..."
    echo ""

    if [ -f ".npm/_logs" ]; then
        ls -t .npm/_logs/*.log | head -1 | xargs cat 2>/dev/null || print_warning "未找到日志文件"
    else
        print_warning "未找到日志目录"
    fi

    echo ""
    print_info "查看完整日志: ~/.npm/_logs/"
}

# 主循环
main() {
    check_dependencies

    while true; do
        show_menu
        read -p "请选择 (0-8): " choice
        echo ""

        case $choice in
            1)
                dev_mode
                ;;
            2)
                build_project
                ;;
            3)
                run_production
                ;;
            4)
                generate_static
                ;;
            5)
                preview_build
                ;;
            6)
                clean_cache
                ;;
            7)
                check_status
                ;;
            8)
                view_logs
                ;;
            0)
                print_info "再见！"
                exit 0
                ;;
            *)
                print_error "无效选择，请重试"
                ;;
        esac

        echo ""
        read -p "按 Enter 继续..."
        clear
    done
}

# 启动主程序
main
