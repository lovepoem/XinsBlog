---
title: 线程池使用中遇到的问题
cover: /images/java.png
subtitle:  对于一个线程池使用的低级错误的分析
author: 
  nick: 王欣
  link: http://lovepoem.github.io
tags: 
- 性能
categories: 
- 性能
date: 2018-10-05 02:01:02  
---
最近上线程序，犯了一个低级错误

java的线程和linux进程的映射关系
java 进程out of memeory
Java HotSpot(TM) 64-Bit Server VM warning: Exception java.lang.OutOfMemoryError occurred dispatching signal SIGTERM to handler- the VM may need to be forcibly terminatedy
1、进程数达到限制
一条Java线程就映射到一条轻量级进程之中
线程数达到 31982  32000

2、每启一个进程
内存超过linux内存阈值，
应用进程out of memory



处理方案：
1、线程池的使用压测
2、系统加监控，当大于20000个进程数就开始报警

