---
title: 血的教训：线程池定义一定要全局化，共享使用
cover: /images/java.png
subtitle: 在我们业务项目上线过程中，有同事大意将线程池的的定义放到了局部变量中，导致服务运行一段后Java进程僵死，宿主机也处于僵死状态。血的教训：线程池使用时候一定注意要全局化，共享使用。
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- 多线程
categories: 
- 多线程
date: 2018-10-05 02:01:02  
---

###  一、发现问题  
​	最近我们上线了一个比较底层的业务服务，上线后研发也去盯着服务器看了日志，没有发现有啥问题，就将服务全量上线了。谁知道过了15分钟左右，上游业务方打电话过来了，说报调用我们的业务服务出现超时。
这时候研发赶紧登上相关的机器去看，发现日志量很少，机器很卡。再有人去登入这台机器的时候就登入不了。研发初步考虑是网络问题或者宿主机问题，于是找来运维。

   运维登入进去机器通过
```shell
ps -ef  | wc -l
```
查看运行的进程数,结果为60000多。通过脚本查看linux进程的进程限制：

```shell 
cat /etc/security/limits.conf
```
，结果是
```
root soft nofile 65535
root hard nofile 65535
```
​	进程总数差不多进程总数的限制。考虑到半小时前更新了新服务，去服务的日志看了看，原来tomcat有jvm内存溢出的日志:
```verilog
java 进程out of memeory
Java HotSpot(TM) 64-Bit Server VM warning: Exception java.lang.OutOfMemoryError occurred dispatching signal SIGTERM to handler- the VM may need to be forcibly terminatedy
```

###  二、查找和解决问题

​	通过上面的一些现象，赶紧将刚才的发布的机器回滚了，避免更大的问题。观察了半个小时，上游再也没有发现我们的服务报错的问题了。于是我们终端review了刚刚上线的一个pr，
​      发现线程池的代码竟然定义在方法体里面：

```java
public class BizService{
    ...... 
    pulic processBiz(){
    ExecutorService fixedThreadPool = Executors.newFixedThreadPool(8);
    ......
   } 
   ......
}
```
这样每次调用这个方法，就构建一个新的线程池，开启了新的8个线程。又查找了[《Java线程与Linux内核线程的映射关系》[1]](http://blog.sina.com.cn/s/blog_605f5b4f010198b5.html) , 发现：JVM线程跟内核轻量级进程有一一对应的关系。线程数达到60000多，处级进程上限65535。    每开启一个进程。
​        对于应用进程发生：out of memory，是因为多线程的开销内存超过jvm的最大堆内存限制。 没开启一个进程，都有内存开销，内存超过linux内存的上限了，怪不得机器快僵死。
​        为了验证这个猜想，于是将有错误的代码进行压测，果然问题复现，出OutOfMemoryError和机器被拖挂。然后将代码修改为:
```java
public class BizService{
    ExecutorService fixedThreadPool = Executors.newFixedThreadPool(8);
    ...... 
    pulic processBiz(){
    ......
   } 
   ......
}
```
然后进行了压测，问题没有复现，问题解决。
###  三、事后review和处理方案：
​       复盘会议上，qa和相关人一起提出了如下方案来避免类似问题：
#### 1、完善监控指标
​      本次线程池超限，java进程也有报错，就是报```OutOfMemoryError```,可是报警系统竟然没有第一时间收到。查了监控系统，在前一段项目进程了重构，日志路径修改了，原来的采集配置竟然没有同时修改。导致造成损失却没有收到警报。
#### 2、代码review一定要做，并且认真做
​      本次程序员的线程池代码为低级失误，review认真是可以看出来的。
#### 3、有大的优化要进行压测
​      本次pr，有线程池的使用，所以要进行压测
#### 4、添加平台监控
​     添加平台监控，当linux进程大于20000个时候就就对进程数进行报警
**参考：**
[1] http://blog.sina.com.cn/s/blog_605f5b4f010198b5.html



**修改记录：**

2019-07-18 丰富了案例的描述