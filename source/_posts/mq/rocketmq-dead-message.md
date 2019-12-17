---
title: RocketMQ的死信队列你了解多少？怎么实现的？
cover: /images/java.png
subtitle:  RocketMQ的死信队列你了解多少？怎么实现的？
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- hide
categories: 
- hide
date: 2019-12-08 21:01:02      
---

​     在使用MQ的过程中，常常有这种情形：生产者向一个topic发送消息后，如果消费者一直消费失败。要确保消息不被丢弃，直到消费者服务正常消费这个条消息为止。这个在`RocketMQ` 中的实现正是**死信队列**。

​        
