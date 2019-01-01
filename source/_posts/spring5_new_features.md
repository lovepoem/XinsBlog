---
title: 升级到Spring Framework 5.x.须知
cover: /images/spring.png
subtitle:  升级到Spring Framework 5.x.须知
author: 
  nick: 王欣
  link: http://lovepoem.github.io
tags: 
- spring5
categories: 
- spring 
date: 2018-09-05 02:01:02   
---

## 一、spring5.0 做了哪些改变
首先我们先看一下官网文档[《升级到Spring Framework 5.x.》]( https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x).细节已经讲的很清楚，我们再做一些分析。


### spring5.0 新的改变
- Spring Framework 5.0需要JDK 8（Java SE 8）或更高版本，因为它的整个代码库现在基于Java 8源代码级别	

- 为Spring WebFlux添加了Netty 4.1和Undertow 1.4

### 用spring5 以后哪些不兼容的组件

#### 删除了的包，类和方法

- 包beans.factory.access（BeanFactoryLocator机制）。

  - 包括`SpringBeanAutowiringInterceptor`基于这种静态共享上下文的EJB3。最好通过CDI集成Spring后端。

- 包jdbc.support.nativejdbc（NativeJdbcExtractor机制）。

  - 被`Connection.unwrap`JDBC中的本机机制所取代。目前，即使针对Oracle JDBC驱动程序，也几乎不需要解包。

- 包`mock.staticmock`从spring-aspects`模块中删除。

  - 不再支持`AnnotationDrivenStaticEntityMockingControl`了。
- 包`web.view.tiles2`和`orm.hibernate3/hibernate4`丢弃。
  - 最低要求：现在为Tiles 3和Hibernate 5。

#### 放弃了支持的三方包

Spring Framework不再支持：Portlet，Velocity，JasperReports，XMLBeans，JDO，Guava（由Caffeine支持取代）。如果这些对您的项目至关重要，那么您应该继续使用Spring Framework 4.3.x（支持到2020年）。或者，您可以在自己的项目中创建自定义适配器类（可能从Spring Framework 4.x派生）

## 二、spring5.1 做了哪些改变
对于JDK 11的支持 ，ASM和CGLIB做了以及的升级，以支持最新的这些jdk

## 三、我们该怎么办？
   我的一个观点是积极拥抱新的spring5包，尤其是新项目。
  - 首先新的特性是一个框架资源投入的方向

  - 你会使用到webflux等一些等的异步特性；

  - 强制使用用java8以上，可以体验一些lamba表达式语法糖等功能。理解在java一直被吐槽代码太多的情况下，jdk对于动态语言的一些学习吸收。

  反过来思考，一些老项目升级成新版本以后，会发现有一些jdk删除的包和不支持的包。这个比较麻烦，一个老的项目可以需要业务全面回归来应对框架的升级。

​        对于[dubbo](https://github.com/apache/incubator-dubbo)项目来说，我的观点是在一个比较激进的新的分支上升级到spring5,比如正在开发的异步版本[3.0](https://github.com/apache/incubator-dubbo/tree/3.x-dev)开始使用，这样可以充分测试一些新的feature，早点发现问题。