---
title: JVM基本结构
cover: /images/java.png
subtitle:  本文讲述了jvm,gc等的基本概念和jvm的内存基本结构，对内存的访问定位等。
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- jvm
categories: 
- jvm
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

### 三、Jvm运行时数据区
在Java语言中，采用的是共享内存模型来实现多线程之间的信息交换和数据同步的。 根据[《Java虚拟机文档》](https://docs.oracle.com/javase/specs/index.html) 第七版的规定，Java虚拟机锁管理的内存包含下面几个运行时数据区域：
<img src="/images/jvmcons.png">
**方法区、虚拟机栈、本地方法栈、队、程序计数器**等。

- 程序计数器：

  一块较小的内存空间，可以看做是当前线程所执行的**字节码的行数指示器**。

- JAVA虚拟机栈：

  **虚拟机栈**描述的是Java方法执行的内存模型：每个方法在执行的同时会创建一个栈帧（Stack Frame）用于存储**局部变量表、操作数栈、动态链接、方法出口**等信息。

  **局部变量表**存放了编译器可知的：
    - **基本数据类型**（boolean、byte、char、short、int、float、long、double）  
    - **对象引用**：reference类型，可能是一个指向对象起始地址的引用指针，也可能是一个指向对象起始地址的引用指针
    - **returnAddress地址**：指向了一条字节码指令的地址

- 本地方法栈：

  为虚拟机使用到的Native方法服务，与虚拟机栈的作用类似。

- JAVA堆：

  Java堆是被所有线程共享的一块内存区域，此内存区域的唯一目的就是存放内存实例，所有的对象实例以及数组都要在堆上分配，是垃圾收集管理的主要区域。

- 方法区：
   和Java堆一样，是各个线程共享的内存区域，用于存储已被虚拟机加载的**类信息、常量、静态变量、即时编辑器编译后的代码**等 

- 运行时常量池

   是方法区的一部分。Class文件中除了有类的版本、字段、方法、接口等描述信息外，还有常量池来存放编译期生成的各种字面量和符号引用。

- 直接内存

   对外内存，不是jvm的存储，所以不受jvm的堆参数控制。NIO可以直接分配对外内存，可能会导致OutOfMemoryError，导致java进程僵死。

### 四、对象的访问定位

​        我们Java程序需要通过**栈上**的reference数据来操作**堆上**的具体对象。 有两种方式：**使用句柄访问**和**通过指针访问**。      
- 使用句柄

  Java堆中将会划分出一块内存来作为句柄池，reference中存储的就是对象的句柄地址，句柄中包含了对象实例与类型数据各自的具体地址信息。

  <img src="/images/jvmhandler.png">

- 通过指针

  Java堆对象的布局中就必须考虑如何放置访问类型数据的相关信息，而reference中存储的直接就是对象地址。       
  <img src="/images/jvmdirect.png">

**参考：**
- 《深入理解java虚拟机》周志明
- 图片来自网络
