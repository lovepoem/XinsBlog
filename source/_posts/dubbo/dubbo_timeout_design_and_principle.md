---
title: Dubbo代码分析—超时和重试设计
cover: /images/dubbo.png
subtitle:  拿dubbo这个rpc框架的timeout机制，配合tcp的超时处理
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- dubbo
categories: 
- dubbo
date: 2019-02-11 18:01:02  
---

超时机制是dubbo中的一个很重要的机制。在“快速失败”设计中，能将客户端断掉，防止服务端资源耗尽而被压挂。

我们先看一下TCP协议中的超时机制是怎么实现的。**贴代码**分析一下堆栈情况，
TCP的

