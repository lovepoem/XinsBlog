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
**问题一：** Redis是单线程还是多线程？为什么redis会被认为读写都快呢？

   **单线程的**, Redis6 之后多线程IO

  1.redis是基于内存的，内存的读写速度非常快；

  2.redis是单线程的，省去了很多上下文切换线程的时间；

  3.redis使用多路复用技术，可以处理并发的连接。非阻塞IO 内部实现采用epoll，采用了epoll+自己实现的简单的事件框架。epoll中的读、写、关闭、连接都转化成了事件，然后利用epoll的多路复用特性，绝不在io上浪费一点时间。

**问题二：**Redis都有什么数据结构，内部存储数据结构是啥？

​    String——字符串 简单动态字符串(SDS[Simple Dynamic String])

​	Hash——字典

​	List——列表

​	Set——集合

​	Sorted Set——有序集合

**skiplist数据结构**

 skiplist作为zset的存储结构，整体存储结构如下图，核心点主要是包括一个dict对象和一个skiplist对象。dict保存key/value，key为元素，value为分值；skiplist保存的有序的元素列表，每个元素包括元素和分值。两种数据结构下的元素指向相同的位置。



**问题三** Redis的持久化策略有哪些?

Redis两种持久化方式(RDB&AOF) 

**[RDB](https://github.com/sripathikrishnan/redis-rdb-tools/wiki/Redis-RDB-Dump-File-Format)**每次进行快照方式会重新记录整个数据集的所有信息。RDB在恢复数据时更快，可以最大化redis性能，子进程对父进程无任何性能影响。

**[AOF](https://redis.io/topics/persistence)**有序的记录了redis的命令操作。意外情况下数据丢失甚少。AOF同步也是一种把记录写到硬盘上的行为，在上述两个步骤之外，Redis额外加一步命令，Redis先把记录追加到自己维护的一个aof_buf中。所以AOF持久化分为三步：1、命令追加 2、文件写入 3.文件同步





 