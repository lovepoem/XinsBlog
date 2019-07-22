---
title: Dubbo代码分析---服务端线程池
cover: /images/java.png
subtitle: Dubbo代码分析---服务端线程池
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- dubbo
categories: 
- dubbo
date: 2019-01-01 02:01:02  
---

一、Dubbo服务端线程池耗尽问题

在使用Dubbo的过程中，在服务端压力大时候我们常常会遇到说线程池耗尽的这样一个错误日志：

```verilog
17:54:34,026 WARN [New I/O server worker #1-4] -  [DUBBO] Thread pool is EXHAUSTED! Thread Name: DubboServerHandler-10.8.64.57:20880, Pool Size: 300 (active: 300, core: 300, max: 300, largest: 300), Task: 5821 (completed: 5621), Executor status:(isShutdown:false, isTerminated:false, isTerminating:false), in dubbo://x.x.x.x:20880!, dubbo version: 2.6.5, current host: x.x.x.x
com.alibaba.dubbo.remoting.ExecutionException: class com.alibaba.dubbo.remoting.transport.dispatcher.all.AllChannelHandler error when process caught event .
	at com.alibaba.dubbo.remoting.transport.dispatcher.all.AllChannelHandler.caught(AllChannelHandler.java:67)
	at com.alibaba.dubbo.remoting.transport.AbstractChannelHandlerDelegate.caught(AbstractChannelHandlerDelegate.java:44)
	at com.alibaba.dubbo.remoting.transport.AbstractChannelHandlerDelegate.caught(AbstractChannelHandlerDelegate.java:44)
	at com.alibaba.dubbo.remoting.transport.AbstractPeer.caught(AbstractPeer.java:127)
	at com.alibaba.dubbo.remoting.transport.netty.NettyHandler.exceptionCaught(NettyHandler.java:112)
	at com.alibaba.dubbo.remoting.transport.netty.NettyCodecAdapter$InternalDecoder.exceptionCaught(NettyCodecAdapter.java:165)
	at org.jboss.netty.channel.Channels.fireExceptionCaught(Channels.java:432)
	at org.jboss.netty.channel.AbstractChannelSink.exceptionCaught(AbstractChannelSink.java:52)
	at org.jboss.netty.channel.Channels.fireMessageReceived(Channels.java:302)
	at com.alibaba.dubbo.remoting.transport.netty.NettyCodecAdapter$InternalDecoder.messageReceived(NettyCodecAdapter.java:148)
	at org.jboss.netty.channel.Channels.fireMessageReceived(Channels.java:274)
	at org.jboss.netty.channel.Channels.fireMessageReceived(Channels.java:261)
	at org.jboss.netty.channel.socket.nio.NioWorker.read(NioWorker.java:350)
	at org.jboss.netty.channel.socket.nio.NioWorker.processSelectedKeys(NioWorker.java:281)
	at org.jboss.netty.channel.socket.nio.NioWorker.run(NioWorker.java:201)
	at org.jboss.netty.util.internal.IoWorkerRunnable.run(IoWorkerRunnable.java:46)
	at java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:886)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:908)
	at java.lang.Thread.run(Thread.java:619)
 
Caused by: java.util.concurrent.RejectedExecutionException: Thread pool is EXHAUSTED! Thread Name: DubboServerHandler-10.8.64.57:20880, Pool Size: 300 (active: 300, core: 300, max: 300, largest: 300), Task: 5821
```
我们从错误堆栈可以看到，是服务端线程池溢出了。

**二、源码分析**
看一下服务端线程池代码是怎么写的，起到什么作用

画图 dubbo客户端调用服务端线程池的示意图

**三、线程池知识**

解释一下线程池的定义是用来干嘛的。

一些处理的办法：
适当加大服务端线程池，找到合理的配置。这个关联一线程池的配合准则，链接到老的文章。

**四、分析原因，处理建议**

为什么线程池升高呢？    主要从**流量、cpu数据率、负载、jvm日志**几方面分析
1）流量过大？(加缓存、对于上游上游服务)
2)   扩机器：cpu核数的增加
3)   宿主机此时负载高？
4）自己代码优化
5)  设置客户端快速失败

  程序慢？io过多？（并行io）






