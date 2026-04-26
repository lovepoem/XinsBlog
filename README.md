# 王欣说AI

![CI](https://github.com/lovepoem/XinsBlog/workflows/CI/badge.svg)
![wangxin.io deploy](https://github.com/lovepoem/XinsBlog/workflows/wangxin.io%20deploy/badge.svg)

> 基于Hexo的个人技术博客，专注于RPC、云原生、性能优化、信息安全、AIGC等技术分享。
> 
> 🌐 **在线访问**: https://wangxin.io/

## 🚀 快速开始

### 环境要求
- Node.js 14+ 
- npm 6+
- Git

### 安装依赖
```bash
npm install --ignore-scripts
```

### 写作流程
1. 在 `source/_posts/` 目录下创建或编辑文章
2. 使用Markdown格式编写内容
3. 运行构建和部署命令

## 📦 构建部署

### 🎯 推荐方式（完整优化）
```bash
./build-final.sh
```
**包含功能**:
- ✅ 图片自动压缩（JPEG/PNG优化，压缩率高达80%+）
- ✅ Sass编译和CSS优化
- ✅ HTML/CSS/JS压缩
- ✅ Gzip压缩文件生成
- ✅ 性能检测和报告

### 🛡️ 稳定版本（兼容性优先）
```bash
./build-basic.sh
```
适合环境配置有问题时使用，跳过可能有兼容性问题的功能。

### ⚡ 快速构建（开发调试）
```bash
./build.sh
```
标准Hexo构建，无额外优化，适合快速预览。

## 📊 性能监控

```bash
node performance-check.js
```
- 检测网站响应时间
- 分析压缩和缓存状态  
- 生成详细性能报告

## 🔧 故障排除

### 图片优化工具安装
```bash
# macOS
brew install jpegoptim optipng

# Ubuntu/Debian
sudo apt-get install jpegoptim optipng
```

### Sass编译问题
```bash
npm uninstall sass hexo-renderer-sass
npm install sass hexo-renderer-sass --save
```

## 📈 优化成果

- **文件数量**: ~294个（包含压缩文件）
- **原始文件**: ~171个静态文件
- **Gzip文件**: ~123个压缩文件
- **总大小**: ~6.8MB
- **图片压缩**: 高达81.99%压缩率
- **构建时间**: ~2秒

## 📚 技术栈

- **静态站点生成**: [Hexo](https://hexo.io/)
- **主题**: [hexo-theme-skapp](https://github.com/Mrminfive/hexo-theme-skapp)
- **评论系统**: [Gitalk](https://github.com/gitalk/gitalk)
- **部署**: GitHub Pages
- **优化**: 图片压缩、代码压缩、Gzip压缩

## 📖 详细文档

- [BUILD_GUIDE.md](./BUILD_GUIDE.md) - 构建脚本详细说明
- [OPTIMIZATION_GUIDE.md](./OPTIMIZATION_GUIDE.md) - 性能优化指南

## 🔗 相关链接

- **博客地址**: https://wangxin.io/
- **GitHub**: https://github.com/lovepoem
- **Hexo官网**: https://hexo.io/
- **主题仓库**: https://github.com/Mrminfive/hexo-theme-skapp

---

**作者**: 王欣 | Apache Dubbo项目committer/PMC、Apache Seata项目PPMC
