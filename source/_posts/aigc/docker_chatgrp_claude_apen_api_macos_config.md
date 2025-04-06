---
title: Macos上跑Docker Desktop遇到registry-1.docker.io网络不通问题填坑笔记
subtitle:  docker、chatgpt、claudeai等国外的站点对国内IP有限制，使用vpn时候的注意点
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- 大模型,AIGC  
categories: 
- 大模型
date: 2024-11-08 10:01:02
---

### 问题：

docker、openai、claudeai等国外的站点对国内IP有限制，所以在使用vpn等要注意一些点

### 原因：

当使用docker指令启动项目，报错

```Prolog
Error response from daemon: Get "https://registry-1.docker.io/v2/": EOF(base) wx@wxs-MacBook-Pro docker 
```

![img](/images/docker_error.jpeg)

是因为：registry-1.docker.io被墙

### 解决方法：

#### 1）切记VPN要设置“全局代理”

在使用docker desktop、或者直接调用claude/chatgpt的open api时候，也需要设置**“全局代理”**

例如我用的VPN是XXXXXVpn，是设置**"安全模式"**

![img](/images/vpn_config.png)

可以在一个网站查看是否生效：https://whatismyipaddress.com

![img](/images/proxy_success.png)

如图，我的已经生效。如果一直不生效，请在**无痕模式**下打开浏览器

#### 2）添加国内代理站点：

请将下面的代码：

```CMake
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "debug": true,
  "dns": [
    "8.8.8.8",
    "114.114.114.114"
  ],
  "experimental": true,
  "proxies": {
    "http-proxy": "http://127.0.0.1:7890",
    "https-proxy": "http://127.0.0.1:7890",
    "no-proxy": "localhost,127.0.0.0/8"
  },
  "registry-mirrors": [
    "https://hub.rat.dev"
  ]
}
```

拷贝到  Docker Desktop的  设置按钮--> Docker Engine 文本框

![img](/images/docker_daemon.png)

对应文件的磁盘存储路径为：~/.docker/daemon.json

