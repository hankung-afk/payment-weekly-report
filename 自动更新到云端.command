#!/bin/bash

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "========================================="
echo "  自动推送配置到 GitHub"
echo "========================================="
echo ""

# 检查是否有 Git 仓库
if [ ! -d ".git" ]; then
    echo "❌ 错误: 此目录还未初始化为 Git 仓库"
    echo ""
    echo "请先按照 部署指南.md 完成以下步骤:"
    echo "1. 创建 GitHub 仓库"
    echo "2. 执行 git init"
    echo "3. 添加 remote 并首次推送"
    echo ""
    exit 1
fi

# 检查是否有改动
if git diff --quiet config.json && git diff --cached --quiet config.json; then
    echo "ℹ️  config.json 没有改动，无需推送"
    echo ""
    exit 0
fi

echo "📤 正在推送配置更新..."
echo ""

# 添加改动
git add config.json

# 提交
COMMIT_MSG="Auto update: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"

# 推送
if git push; then
    echo ""
    echo "========================================="
    echo "  ✅ 推送成功！"
    echo "========================================="
    echo ""
    echo "⏳ Cloudflare Pages 将在约1分钟后更新"
    echo "🔗 然后访问你的固定 URL 即可看到最新地址"
    echo ""
else
    echo ""
    echo "========================================="
    echo "  ❌ 推送失败"
    echo "========================================="
    echo ""
    echo "可能的原因:"
    echo "1. 网络连接问题"
    echo "2. GitHub 认证失败"
    echo "3. 没有推送权限"
    echo ""
    echo "请检查错误信息并重试"
    echo ""
    exit 1
fi

sleep 2
