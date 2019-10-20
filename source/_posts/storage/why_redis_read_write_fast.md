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

**AOF**有序的记录了redis的命令操作。意外情况下数据丢失甚少。他不断地对aof文件添加操作日志记录，你可能会说，这样的文件得多么庞大呀。是的，的确会变得庞大，但redis会有优化的策略，比如你对一个**key1**键的操作，set key1 001 , set key1 002, set key1 003。那优化的结果就是将前两条去掉咯，那具体优化的配置在配置文件中对应的是

https://redis.io/topics/persistence



 