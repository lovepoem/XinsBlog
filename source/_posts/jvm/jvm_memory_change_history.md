---
title: JVM内存结构的历史 （从Jdk1.6、1.7、8）
cover: /images/java.png
subtitle:  从Jdk1.6、1.7、8，JVM内存结构经历了不少的变化，本文将按照时间说开去
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- hide
categories: 
- hide
date: 2019-10-31 09:01:02      
---

从JDK1.6到1.8, 运行时内存分配简图分别如下:

![Mechanism](/images/java1.6.png)

在JDK1.7中的HotSpot中，已经把原本放在方法区的字符串常量池移出。

　　从JDK7开始永久代的移除工作，贮存在永久代的一部分数据已经转移到了Java Heap或者是Native Heap。但永久代仍然存在于JDK7，并没有完全的移除：符号引用(Symbols)转移到了native heap;字面量(interned strings)转移到了java heap;类的静态变量(class statics)转移到了java heap。
![Mechanism](/images/java1.7.png)


随着JDK8的到来:

    JVM不再有PermGen。但类的元数据信息（metadata）还在，只不过不再是存储在连续的堆空间上，而是移动到叫做“Metaspace”的本地内存（Native memory）中。
![Mechanism](/images/java8.png)



### **一、java7到java8的第一部分变化：元空间**

下面来一张图看一下java7到8的内存模型吧（这个是在网上找的图，如有侵权问题请联系我删除。）

![img](https://pic1.zhimg.com/80/v2-d928d79855d4448af061752168967d04_hd.jpg)

### **二、java7到**



### **二、java7到java8的第二部分变化：运行时常量池**

运行时常量池（Runtime Constant Pool）的所处区域一直在不断的变化，在java6时它是方法区的一部分；1.7又把他放到了堆内存中；1.8之后出现了元空间，它又回到了方法区。







Metaspace 结构是怎么样的？

![Mechanism](/images/java8struct.jpeg)




参考:
————————————————
版权声明：本文为CSDN博主「划船一哥」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_42711325/article/details/86533192