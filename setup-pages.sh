#!/bin/bash

# GitHub Pages 自动设置脚本
# 作者: Awesome Solana Libraries
# 用途: 一键配置 GitHub Pages 环境

set -e  # 遇到错误立即退出

echo "🚀 设置 GitHub Pages 环境..."
echo "==============================="

# 检查是否在 Git 仓库中
if [ ! -d ".git" ]; then
    echo "❌ 错误: 当前目录不是 Git 仓库"
    exit 1
fi

# 检查是否有未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  警告: 存在未提交的更改"
    echo "是否继续? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "操作已取消"
        exit 0
    fi
fi

echo "📝 检查配置文件..."

# 检查 _config.yml 是否存在
if [ -f "_config.yml" ]; then
    echo "✅ _config.yml 已存在"
else
    echo "❌ _config.yml 不存在，请先运行主配置脚本"
    exit 1
fi

# 检查 Gemfile 是否存在
if [ -f "Gemfile" ]; then
    echo "✅ Gemfile 已存在"
else
    echo "❌ Gemfile 不存在，请先运行主配置脚本"
    exit 1
fi

# 本地测试环境设置
echo ""
echo "🔧 本地测试环境设置..."
echo "========================"

# 检查 Ruby 是否安装
if command -v ruby &> /dev/null; then
    echo "✅ Ruby 已安装: $(ruby --version)"
else
    echo "❌ Ruby 未安装"
    echo "请运行: brew install ruby"
    exit 1
fi

# 检查 Bundler 是否安装
if command -v bundle &> /dev/null; then
    echo "✅ Bundler 已安装: $(bundle --version)"
else
    echo "📦 安装 Bundler..."
    gem install bundler
fi

# 安装依赖
echo "📦 安装 Jekyll 依赖..."
bundle install --quiet

echo ""
echo "🚀 启动本地预览服务器..."
echo "========================="
echo "访问地址: http://localhost:4000/awesome-solana-libraries/"
echo "按 Ctrl+C 停止服务器"
echo ""

# 启动 Jekyll 服务器
bundle exec jekyll serve --livereload --port 4000 --host 0.0.0.0 &
SERVER_PID=$!

echo "服务器进程 ID: $SERVER_PID"
echo ""
echo "🔍 快速检查命令:"
echo "  - 查看构建状态: bundle exec jekyll build --verbose"
echo "  - 清理缓存: bundle exec jekyll clean"
echo "  - 停止服务器: kill $SERVER_PID"
echo ""
echo "📋 GitHub Pages 设置步骤:"
echo "1. 访问: https://github.com/$(git remote get-url origin | sed 's/.*github.com[\/:]//g' | sed 's/.git$//g')/settings/pages"
echo "2. Source: Deploy from a branch"
echo "3. Branch: main"
echo "4. Folder: / (root)"
echo "5. 点击 Save"
echo ""
echo "⏰ 等待 2-10 分钟后访问:"
echo "https://$(git remote get-url origin | sed 's/.*github.com[\/:]//g' | sed 's/.git$//g' | sed 's/\//.github.io\//g')/"

# 等待用户输入来停止服务器
echo ""
echo "按 Enter 键停止本地服务器..."
read -r
kill $SERVER_PID 2>/dev/null || true
echo "✅ 服务器已停止"