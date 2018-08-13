#!/usr/bin/env bash
npm uninstall hexo
npm install hexo --no-optional
npm uninstall hexo-cli -g
npm install hexo-cli -g
npm install hexo-deployer-git --save
npm install hexo-toc --save
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
hexo generate
hexo deploy
