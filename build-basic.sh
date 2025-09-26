#!/usr/bin/env bash

echo "🚀 开始基础构建（无优化）..."

# 临时移除有问题的插件
echo "🔧 临时禁用有问题的插件..."
mv node_modules/hexo-renderer-sass node_modules/hexo-renderer-sass.disabled 2>/dev/null || true
mv node_modules/hexo-filter-cleanup node_modules/hexo-filter-cleanup.disabled 2>/dev/null || true

# 清理旧文件
echo "🧹 清理旧文件..."
rm -rf public/*

# 生成静态文件
echo "🔨 生成静态文件..."
npx hexo generate

if [ $? -eq 0 ]; then
    echo "✅ 构建成功！"
    echo "📊 文件统计："
    du -sh public/ 2>/dev/null || echo "public目录大小统计失败"
    
    # 检查生成的文件
    echo "📁 生成的主要文件："
    ls -la public/ | head -10
    
    # 部署
    echo "🚀 开始部署..."
    npx hexo deploy
    
    if [ $? -eq 0 ]; then
        echo "🎉 部署完成！"
        echo "🌐 访问地址: https://wangxin.io/"
        
        # 运行性能检测
        echo "📊 运行性能检测..."
        node performance-check.js 2>/dev/null || echo "性能检测脚本执行失败"
    else
        echo "❌ 部署失败"
    fi
else
    echo "❌ 构建失败"
fi

# 恢复插件
echo "🔄 恢复插件..."
mv node_modules/hexo-renderer-sass.disabled node_modules/hexo-renderer-sass 2>/dev/null || true
mv node_modules/hexo-filter-cleanup.disabled node_modules/hexo-filter-cleanup 2>/dev/null || true

echo "📝 注意：为了兼容性，已禁用了Sass渲染器和图片优化功能"
echo "💡 建议：考虑升级到更新的Node.js版本或安装Python环境以支持完整功能"
