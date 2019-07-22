---
title: 为什么Redis读写快？
cover: /images/java.png
subtitle:  为什么Redis读写快？
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- redis
categories: 
- 存储
- redis
date: 2019-02-13 18:01:02  
---
**一、问题：**

为什么redis会被认为读写都快呢？用了什么样的数据结构？

**二、redis代码分析**

代码类图，时序图

**三、redis和mysql比较**

1、读写速度

redis和mysql比有哪些优劣？redis一般用来做缓存

2、持久化的能力，防丢失能力

怎么解决持久化问题。需要持久化呢？怎么防止数据丢失

数据同步的策略（a/b）

