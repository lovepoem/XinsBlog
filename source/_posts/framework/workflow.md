---
title: 浅谈工作流引擎
cover: /images/workflow.png
subtitle:  工作流(Workflow) 是对工作流程及其各操作步骤之间业务规则的抽象、概括描述。工作流建模，即将工作流程中的工作如何前后组织在一起的逻辑和规则，在计算机中以恰当的模型表达并对其实施计算。工作流要解决的主要问题是：为实现某个业务目标，利用计算机在多个参与者之间按某种预定规则自动传递文档、信息或者任务。（维基百科[工作流技术](https://zh.wikipedia.org/wiki/工作流技术) ）
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
    - 工作流
categories: 
    - 工作流
date: 2014-06-05 02:01:02        
---

## 一、工作流相关概念
  * 工作流(Workflow)
      *   是对工作流程及其各操作步骤之间业务规则的抽象、概括描述。工作流建模，即将工作流程中的工作如何前后组织在一起的逻辑和规则，在计算机中以恰当的模型表达并对其实施计算。工作流要解决的主要问题是：为实现某个业务目标，利用计算机在多个参与者之间按某种预定规则自动传递文档、信息或者任务。（维基百科[工作流技术](https://zh.wikipedia.org/wiki/工作流技术) ）

  * BPMN(Business Process Model and Notation)
  *    BPMN 是目前被各 BPM 厂商广泛接受的 BPM 标准，全称为 Business Process Model and Notation，由 OMG 组织进行维护，2011 年 1 月份发布了其 2.0 的正式版。BPMN 2.0 对比于第一个版本，其最重要的变化在于其定义了流程的元模型和执行语义，即它自己解决了存储、交换和执行的问题。这代表着 BPMN 2.0 流程定义模型不仅仅可以在任何兼容 BPMN 2.0 的引擎中执行，而且也可以在图形编辑器间交换。作为一个标准，BPMN 2.0 统一了工作流社区。
  * 有穷状态机
  	工作流流程定义图要求：必须是有一个起点和一个终点的有向图
  
  * XPDL（XML Process Definition Language）WFMC 
    WFMC工作流定义语言，流程模型文档规范。
    (![流程示例](http://img.blog.csdn.net/20151228065630522))

## 二、工作流的特点？

### 工作流参考模型
(![流程架构](http://img.blog.csdn.net/20151228065316082))

## 三、jBPM技术体系

     * jbpm VS activiti
     地址：
     http://www.activiti.org/download.html  activiti
    
     * jBPM是目前市场上主流开源工作引擎之一，在创建者Tom Baeyens离开JBoss后，jBPM的下一个版本jBPM5完全放弃了jBPM4的基础代码，基于Drools Flow重头来过，目前官网已经推出了jBPM6的beta版本；Tom Baeyens加入Alfresco后很快推出了新的基于jBPM4的开源工作流系统Activiti。
    
     * 都是BPMN2过程建模和执行环境。
     * 都是BPM系统（符合BPM规范）。
     * 都是开源项目-遵循ASL协议（ Apache的 软件许可）。
     * 都源自JBoss（Activiti5是jBPM4的衍生，jBPM5则基于Drools Flow）。
     * 都很成熟，从无到有，双方开始约始于2年半前。
     * 都有对人工任务的生命周期管理。 Activiti5和jBPM5唯一的区别是jBPM5基于WebService - HumanTask标准来描述人工任务和管理生命周期。 如有兴趣了解这方面的标准及其优点，可参阅WS - HT规范介绍  。
     * 都使用了不同风格的 Oryx 流程编辑器对BPMN2建模。 jBPM5采用的是 Intalio 维护的开源项目分支。 Activiti5则使用了Signavio维护的分支。

优劣对比：
优劣对比：

从技术组成来看，Activiti最大的优势是采用了PVM（流程虚拟机），支持除了BPMN2.0规范之外的流程格式，与外部服务有良好的集成能力，延续了jBPM3、jBPM4良好的社区支持，服务接口清晰，链式API更为优雅；劣势是持久化层没有遵循JPA规范。

jBPM最大的优势是采用了Apache Mina异步通信技术，采用JPA/JTA持久化方面的标准，以功能齐全的Guvnor作为流程仓库，有RedHat(jBoss.org被红帽收购)的专业化支持；但其劣势也很明显，对自身技术依赖过紧且目前仅支持BPMN2。

## 三、activiti
       *  咖啡兔博客： http://www.kafeitu.me/
       *  activiti demo  http://demo.kafeitu.me:8080/kft-activiti-demo/login/

## 四、jBPM的几个元素
        * 流程设计器
        * 自定义表单
        * 流程自动化与数据统计

###  一些思考
###  一些思考
  *  引擎的两个极端：一飞冲天的动力之源？  为解决拥堵而变成新拥堵的制造者？
   
    | 飞机引擎        |         |
   | --------   | -----       | ----       |
   |  ![飞机引擎](http://img.blog.csdn.net/20151228065159929) |
    | 西直门立交桥        |         |
   | ![这里写图片描述](http://img.blog.csdn.net/20151228065548780)  |

