---
title: MQ组件盘点，哪些你用在了生产中？
cover: /images/java.png
subtitle:  对比分析一下市面上都有哪些mq，区别一下这些消息队列的不同，分析其优缺点。
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- mq
categories: 
- mq
date: 2019-10-31 02:01:02      
---

   市面上的MQ也好几种了，ActiveMq、RabbitMq、rocketMq、kafka、Pulsar。最近国内又陆陆续续开源了几个MQ，如：去哪儿网开源的qmq、腾讯开源的TubeMq、拍拍贷开源的pmq。
   现在想需要对比区别一下这些消息队列的不同，分析其优缺点。

### 一、基本比较

|          | ActiveMQ | RabbitMQ   | RocketMQ| Kafka            | Pulsar      |
| -------- | -------- | ---------- | ------- | ---------- | ----------- |
| **代码地址** |[apache/activemq](https://github.com/apache/activemq) | [apache/rabbitmq-server](https://github.com/rabbitmq/rabbitmq-server) | [apache/rocketmq](https://github.com/apache/rocketmq) | [apache/kafka](https://github.com/apache/kafka) |[apache/pulsar](https://github.com/apache/pulsar)  |
| **PRODUCER-COMSUMER** | 支持      | 支持           | 支持           | 支持             | 支持 |
| **PUBLISH-SUBSCRIBE**| 支持       | 支持           | 支持           | 支持             | 支持 |
| **REQUEST-REPLY**| 支持           | 支持            |              |                  |                  |
| **API完奋性**     |高              | 高             | 高            | 高               |  |
| **多语言支持**    | 支持，IAVA优先  | 语言无关         | 支持| 支持，java优先   |    |
| **单机吞吐量**   | 万级           | 万级            | 万级           | 十万级        | 单个分区高达 1.8 M 消息/秒 |
| **消息延迟**     |               | 微秒级          | 毫秒级      | 毫秒级  | 99% 的生产延迟小于5ms。 |
| **可用性**       | 高（主从）     | 高（主从）       | 非常高（分布式） | 非常高（分布式） | 高 |
| **消息丢失**     | 低            | 低              | 理论上不会丢失  | 理论上不会丢失 |  |
| **消息重复**     |               | 可控制          |               | 理论上会有重复   |    |
| **文挡完备性**   | 高             | 高             | 高             | 高               | 高 |
| **提供快速入门** | 有             | 有             | 有             | 有               | 有 |
| **首次部署难度** |                | 低             |                | 中               | 高 |
| **社区活跃度**   | 高             | 高             | 高            | 高               | 高 |
| **商业支持**     | 无             | 无             | 阿里云         | 无               |                |
| **成熟度**      | 成熟           | 成熟            | 成熟       | 成熟日志领域   |    |
| **支持协议**    | OpenWire、STOMP、REST、 XMPP、AMQP | AMQP | 白己定义的一套，社区提供JMS，不成熟）    |  |  |
| **持久化**      | 内存、文件、数据库              | 内存、文件     | 磁盘文件       | PageCache ->磁盘 | [Apache BookKeeper](https://github.com/apache/bookkeeper) |
| **事务**       | 支持           | 支持           | 支持           |                  |                  |
| **负载均衡**   | 支持           | 支持           | 支持           |                  |                  |
| **管理界面**   | 一般           | 好             | 有web console实现                 |                  |                  |
| **部署方式**   | 独立、嵌入   | 独立         | 独立         |                  |                  |
| **特点**      | 功能齐全，被大 望开源项目使用| 由于Erlang语言的并发能力，性能很好| 各个环节分布式扩展设计，主从HA；支持上万个队列；多 种消费模式；性能很好|                  |                  |
| **评价：优点** | 成熟的产品，已经在很多公司得到应用（非大规横场景）；有较多的文档；备种协议支持较好；有多重语富的成熟的客户端；| 由于erlang语富的特 性，mq性能较好；管埋界面 较丰富，在互联网公司也有 较大规棋的应用；支持amqp协议，有多种语言且支持 amqp的客户端可用； | 模型简单，接口易用（JMS接口在很多场合并不太实用）；在阿里大规棋应用；目前支付宝中的余额宝等新兴产品均使用rocketmq；集群规棋大槪在50台左右，单日处理消息上百亿；性能非常好，可以大量消息堆积在broker中；支持多种消费：包括集群消费、广播消费等；社区活跃，版本更新很快。 |                  | 地域复制、多租户、扩展性、读写隔离等等;对 Kubernetes 的友好支持。 |
| **评价：缺点** | 根据其他用户反馈，会出现莫名其妙的问题，且会丢消息。目前社区不活跃；不适合用于上千个队列的应用场景。 | erlang语言难度较大。集群不支持动态扩展。 | 多语言客户端支持需加强 |                  | 部署相对复杂；新来者，文档较少 |


### 二、各自优缺点

#### 1、Kafka

   大数据行业标配组件

#### 2、RocketMq

​    有事务性消息、私信队列等支持，适合交易场景    

#### 3、Pulsar

​     新贵，地域复制、多租户、扩展性比较好 

#### 4、RabbitMq

​      erlang编写，性能较好。有不少互联网公司用。不过因为erlang，社区开发者较少

#### 5、ActiveMq

   项目较老，不够活跃，会丢消息，不适合在互联网项目使用

### 三、一些问题
   
   #### 1、Kafka的数据丢失问题
   一开始就是存储在PageCache上的，定期flush到磁盘上的，也就是说，不是每个消息都被存储在磁盘了，如果出现断电或者机器故障等，PageCache上的数据就丢失了。 
这个是总结出的到目前为止没有发生丢失数据的情况

```java   
     //producer用于压缩数据的压缩类型。默认是无压缩。正确的选项值是none、gzip、snappy。压缩最好用于批量处理，批量处理消息越多，压缩性能越好
     props.put("compression.type", "gzip");
     //增加延迟
     props.put("linger.ms", "50");
     //这意味着leader需要等待所有备份都成功写入日志，这种策略会保证只要有一个备份存活就不会丢失数据。这是最强的保证。，
     props.put("acks", "all");
     //无限重试，直到你意识到出现了问题，设置大于0的值将使客户端重新发送任何数据，一旦这些数据发送失败。注意，这些重试与客户端接收到发送错误时的重试没有什么不同。允许重试将潜在的改变数据的顺序，如果这两个消息记录都是发送到同一个partition，则第一个消息失败第二个发送成功，则第二条消息会比第一条消息出现要早。
     props.put("retries ", MAX_VALUE);
     props.put("reconnect.backoff.ms ", 20000);
     props.put("retry.backoff.ms", 20000);
     
     //关闭unclean leader选举，即不允许非ISR中的副本被选举为leader，以避免数据丢失
     props.put("unclean.leader.election.enable", false);
     //关闭自动提交offset
     props.put("enable.auto.commit", false);
     限制客户端在单个连接上能够发送的未响应请求的个数。设置此值是1表示kafka broker在响应请求之前client不能再向同一个broker发送请求。注意：设置此参数是为了避免消息乱序
     props.put("max.in.flight.requests.per.connection", 1);
``` 
   #### 2、Kafka重复消费原因
强行kill线程，导致消费后的数据，offset没有提交，partition就断开连接。比如，通常会遇到消费的数据，处理很耗时，导致超过了Kafka的session timeout时间（0.10.x版本默认是30秒），那么就会re-blance重平衡，此时有一定几率offset没提交，会导致重平衡后重复消费。
如果在close之前调用了consumer.unsubscribe()则有可能部分offset没提交，下次重启会重复消费

kafka数据重复 kafka设计的时候是设计了(at-least once)至少一次的逻辑，这样就决定了数据可能是重复的，kafka采用基于时间的SLA(服务水平保证)，消息保存一定时间（通常为7天）后会被删除
