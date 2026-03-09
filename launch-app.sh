#!/bin/bash
# 龙猫乐园 - 应用窗口启动器

PROJECT_DIR="$HOME/Desktop/totoro-paradise"
cd "$PROJECT_DIR" || exit 1

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} 启动龙猫乐园..."
echo ""

# 启动开发服务器（后台）
npx pnpm dev > /tmp/totoro-paradise.log 2>&1 &
SERVER_PID=$!

# 等待服务器启动
echo -e "${GREEN}[INFO]${NC} 等待服务器启动..."
sleep 3

# 检查服务器是否启动成功
if ! ps -p $SERVER_PID > /dev/null; then
    echo -e "${BLUE}[ERROR]${NC} 服务器启动失败，查看日志："
    cat /tmp/totoro-paradise.log
    exit 1
fi

# 打开浏览器应用模式窗口
if command -v chromium &> /dev/null; then
    chromium --app=http://localhost:3000 --new-window > /dev/null 2>&1 &
elif command -v google-chrome &> /dev/null; then
    google-chrome --app=http://localhost:3000 --new-window > /dev/null 2>&1 &
elif command -v firefox &> /dev/null; then
    firefox --new-window http://localhost:3000 > /dev/null 2>&1 &
else
    echo -e "${BLUE}[ERROR]${NC} 未找到支持的浏览器"
    kill $SERVER_PID
    exit 1
fi

echo -e "${GREEN}[SUCCESS]${NC} 龙猫乐园已启动！"
echo ""
echo "访问地址: http://localhost:3000"
echo "服务器 PID: $SERVER_PID"
echo ""
echo "关闭应用窗口后，运行以下命令停止服务器："
echo "  kill $SERVER_PID"
echo ""
