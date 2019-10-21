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

  

**问题二：**Redis都有什么数据结构，内部存储数据结构是啥？

​       

**问题三**  Redis的持久化策略有哪些

Redis两种持久化方式(RDB&AOF) 

**[RDB](https://github.com/sripathikrishnan/redis-rdb-tools/wiki/Redis-RDB-Dump-File-Format)**每次进行快照方式会重新记录整个数据集的所有信息。RDB在恢复数据时更快，可以最大化redis性能，子进程对父进程无任何性能影响。

**[AOF](https://redis.io/topics/persistence)**有序的记录了redis的命令操作。意外情况下数据丢失甚少。AOF同步也是一种把记录写到硬盘上的行为，在上述两个步骤之外，Redis额外加一步命令，Redis先把记录追加到自己维护的一个aof_buf中。所以AOF持久化分为三步：1、命令追加 2、文件写入 3.文件同步





 