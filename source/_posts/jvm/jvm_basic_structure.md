---
title: JVM基本结构
cover: /images/java.png
subtitle:  我们知道，java语言不像C++，将内存的分配和回收给程序员来处理。java用统一的垃圾回收机制来管理java进程的内存，就是通常所说的垃圾回收：GC（Garbage Collection）
author: 
  nick: 王欣
  link: http://lovepoem.github.io
tags: 
- jvm
categories: 
- jvm基本结构
date: 2018-10-08 02:01:02      
---

### 一、什么是 Java GC (垃圾回收) ?
​       我们知道，java语言不像C++，将内存的分配和回收给程序员来处理。java用统一的垃圾回收机制来管理java进程的内存，就是通常所说的垃圾回收：**GC（Garbage Collection）**。
先到维基百科上看一下[Garbage Collection](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science))的概念:
​      In computer science, **garbage collection** (**GC**) is a form of automatic [memory management](https://en.wikipedia.org/wiki/Memory_management). The *garbage collector*, or just *collector*, attempts to reclaim *garbage*, or memory occupied by objectst that are no longer in use by the program. Garbage collection was invented by [John McCarthy](https://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist)) around 1959 to simplify manual memory management in Lisp.
​     这就面临一些问题：java进程到底是什么样的结构？java进程的内存哪些需要被回收，在什么条件下才回收，谁来回收？我们首先来看一些概念

### 二、什么是JVM ? 
从维基百科上看[jvm的定义](https://en.wikipedia.org/wiki/Java_virtual_machine):
   A Java virtual machine (JVM) is a virtual machine that enables a computer to run Java programs as well as programs written in other languages that are also compiled to Java bytecode.         

### 三、Java进程对内存管理的结构
在Java语言中，采用的是共享内存模型来实现多线程之间的信息交换和数据同步的。 

​      



  