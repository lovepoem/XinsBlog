#!/usr/bin/env bash
npm uninstall hexo
npm install hexo@4.0.0 --no-optional
npm uninstall hexo-cli -g
npm install hexo-cli@2.0.0 -g
npm install hexo-deployer-git --save
npm install hexo-toc --save
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
npm install hexo-generator-baidu-urls --save
npm install --save hexo-autoprefixer gitalk hexo-filter-cleanup hexo-generator-feed hexo-renderer-sass hexo-renderer-swig lunr moment node-sass object-assign
rm -rf public/*
hexo generate
hexo deploy
