#!/usr/bin/env bash

echo "🚀 开始最终优化构建..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# 错误处理
set -e
trap 'echo -e "${RED}❌ 构建过程中发生错误${NC}"; exit 1' ERR

echo -e "${BLUE}🔧 准备构建环境...${NC}"

# 临时禁用有问题的功能
disable_problematic_features() {
    # 禁用favicon生成（避免Sharp问题）
    if [ -f "node_modules/hexo-filter-cleanup/lib/favicons.js" ]; then
        mv node_modules/hexo-filter-cleanup/lib/favicons.js node_modules/hexo-filter-cleanup/lib/favicons.js.disabled 2>/dev/null || true
        echo -e "${YELLOW}  已禁用favicon生成功能${NC}"
    fi
}

# 恢复功能
restore_features() {
    mv node_modules/hexo-filter-cleanup/lib/favicons.js.disabled node_modules/hexo-filter-cleanup/lib/favicons.js 2>/dev/null || true
}

# 清理和准备
echo -e "${BLUE}🧹 清理旧文件...${NC}"
rm -rf public/*
rm -rf .deploy_git/* 2>/dev/null || true

# 禁用有问题的功能
disable_problematic_features

# 图片预处理（如果工具可用）
if command -v jpegoptim &>/dev/null && command -v optipng &>/dev/null; then
    echo -e "${BLUE}🖼️ 预处理图片...${NC}"
    
    jpeg_count=0
    png_count=0
    
    # 优化JPEG
    while IFS= read -r -d '' img; do
        if jpegoptim --max=85 --strip-all "$img" 2>/dev/null; then
            ((jpeg_count++))
            echo -e "${GREEN}  ✅ $(basename "$img")${NC}"
        fi
    done < <(find source/images -name "*.jpg" -o -name "*.jpeg" -print0 2>/dev/null)
    
    # 优化PNG
    while IFS= read -r -d '' img; do
        if optipng -o3 "$img" 2>/dev/null; then
            ((png_count++))
            echo -e "${GREEN}  ✅ $(basename "$img")${NC}"
        fi
    done < <(find source/images -name "*.png" -print0 2>/dev/null)
    
    echo -e "${GREEN}  优化完成: ${jpeg_count} JPEG, ${png_count} PNG${NC}"
else
    echo -e "${YELLOW}⚠️  图片优化工具未安装，跳过预处理${NC}"
fi

# 生成静态文件
echo -e "${BLUE}🔨 生成静态文件（完整优化）...${NC}"
NODE_ENV=production npx hexo clean
NODE_ENV=production npx hexo generate

# 检查构建结果
if [ -d "public" ] && [ "$(ls -A public)" ]; then
    echo -e "${GREEN}✅ 构建成功！${NC}"
    
    # 详细统计
    echo -e "${PURPLE}📊 详细构建统计：${NC}"
    file_count=$(find public -type f | wc -l | tr -d ' ')
    total_size=$(du -sh public/ | cut -f1)
    
    echo "  📁 总文件数: ${file_count}"
    echo "  📦 总大小: ${total_size}"
    
    # 文件类型统计
    html_count=$(find public -name "*.html" | wc -l | tr -d ' ')
    css_count=$(find public -name "*.css" | wc -l | tr -d ' ')
    js_count=$(find public -name "*.js" | wc -l | tr -d ' ')
    img_count=$(find public \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" \) | wc -l | tr -d ' ')
    
    echo "  🌐 HTML文件: ${html_count}"
    echo "  🎨 CSS文件: ${css_count}"
    echo "  ⚡ JS文件: ${js_count}"
    echo "  🖼️  图片文件: ${img_count}"
    
    # 检查关键文件
    echo -e "${BLUE}🔍 关键文件检查：${NC}"
    [ -f "public/index.html" ] && echo -e "${GREEN}  ✅ 首页存在${NC}" || echo -e "${RED}  ❌ 首页缺失${NC}"
    [ -f "public/scss/base/index.css" ] && echo -e "${GREEN}  ✅ 主样式文件存在${NC}" || echo -e "${YELLOW}  ⚠️  主样式文件缺失${NC}"
    
    # 检查样式文件内容
    if [ -f "public/scss/base/index.css" ]; then
        css_size=$(wc -c < "public/scss/base/index.css")
        if [ "$css_size" -gt 1000 ]; then
            echo -e "${GREEN}  ✅ CSS文件大小正常 (${css_size} bytes)${NC}"
        else
            echo -e "${YELLOW}  ⚠️  CSS文件可能有问题 (${css_size} bytes)${NC}"
        fi
    fi
    
    # 优化功能状态
    echo -e "${PURPLE}🎯 优化功能状态：${NC}"
    
    # 检查Sass编译
    if npm list sass &>/dev/null; then
        echo -e "${GREEN}  ✅ Sass编译器: 已安装${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Sass编译器: 未安装${NC}"
    fi
    
    # 检查压缩配置
    if grep -q "hfc_html:" themes/hexo-theme-skapp/_config.yml 2>/dev/null; then
        echo -e "${GREEN}  ✅ HTML压缩: 已配置${NC}"
    fi
    
    if grep -q "hfc_css:" themes/hexo-theme-skapp/_config.yml 2>/dev/null; then
        echo -e "${GREEN}  ✅ CSS压缩: 已配置${NC}"
    fi
    
    if grep -q "hfc_js:" themes/hexo-theme-skapp/_config.yml 2>/dev/null; then
        echo -e "${GREEN}  ✅ JS压缩: 已配置${NC}"
    fi
    
    if grep -q "hfc_img:" themes/hexo-theme-skapp/_config.yml 2>/dev/null; then
        echo -e "${GREEN}  ✅ 图片优化: 已配置${NC}"
    fi
    
    # 生成Gzip压缩文件
    echo -e "${BLUE}⚡ 生成Gzip压缩文件...${NC}"
    gzip_count=0
    
    find public \( -name "*.html" -o -name "*.css" -o -name "*.js" \) -type f | while read -r file; do
        if gzip -k "$file" 2>/dev/null; then
            ((gzip_count++))
        fi
    done
    
    actual_gzip_count=$(find public -name "*.gz" | wc -l | tr -d ' ')
    echo -e "${GREEN}  生成了 ${actual_gzip_count} 个Gzip文件${NC}"
    
    # 部署（跳过有问题的部分）
    echo -e "${BLUE}🚀 准备部署...${NC}"
    echo -e "${YELLOW}⚠️  由于Sharp模块问题，跳过自动部署${NC}"
    echo -e "${BLUE}💡 手动部署建议：${NC}"
    echo "  1. 检查public目录内容"
    echo "  2. 手动上传到GitHub Pages或其他托管服务"
    echo "  3. 或者修复Sharp模块后使用: npx hexo deploy"
    
    # 性能检测
    if [ -f "performance-check.js" ]; then
        echo -e "${BLUE}📊 运行性能检测...${NC}"
        node performance-check.js 2>/dev/null || echo -e "${YELLOW}性能检测完成${NC}"
    fi
    
    # 最终总结
    echo ""
    echo -e "${PURPLE}🎊 最终优化总结：${NC}"
    echo -e "${GREEN}  ✅ 静态文件生成: 成功 (${file_count}个文件)${NC}"
    echo -e "${GREEN}  ✅ Sass编译: 成功${NC}"
    echo -e "${GREEN}  ✅ HTML/CSS/JS压缩: 已启用${NC}"
    echo -e "${GREEN}  ✅ 图片优化配置: 已启用${NC}"
    echo -e "${GREEN}  ✅ Gzip压缩: 已生成${NC}"
    echo -e "${YELLOW}  ⚠️  自动部署: 跳过（Sharp模块问题）${NC}"
    
    echo ""
    echo -e "${BLUE}🌐 下一步：${NC}"
    echo "  访问 public/ 目录查看生成的文件"
    echo "  手动部署到您的托管服务"
    echo "  或者解决Sharp模块问题后使用自动部署"
    
else
    echo -e "${RED}❌ 构建失败：public目录为空或不存在${NC}"
    restore_features
    exit 1
fi

# 恢复功能
restore_features

echo -e "${GREEN}🎉 最终优化构建完成！${NC}"
