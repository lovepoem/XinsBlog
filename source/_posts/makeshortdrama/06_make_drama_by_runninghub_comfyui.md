---
title: 第6章：工具篇——使用 RunningHub（ComfyUI）生成短剧
subtitle: 从工作流思维出发，掌握RunningHub云端ComfyUI在短剧创作中的进阶用法
cover: /images/makedrama.png
author:
  nick: 王欣
  link: https://wangxin.io
tags:
- AI短剧
- 短剧制作
categories:
- 短剧制作
date: 2026-04-29 19:35:00
---

# 第6章：工具篇——使用 RunningHub（ComfyUI）生成短剧

上一章我们用小云雀Agent走通了"一键式"短剧生产流程。它的优势是门槛低、全流程封装，但相应地，你能控制的东西也有限——模型不能换、节点不能调、渲染参数不能改。

这一章，我们把引擎盖掀开。

**ComfyUI**是目前AI视频创作领域最主流的开源工作流引擎，而**RunningHub**（runninghub.cn）是它的云端托管版本。你可以把它理解为：小云雀是"自动挡轿车"，RunningHub 上的 ComfyUI 就是"手动挡赛车"——更灵活、更强大，但需要你理解每一个零件怎么配合。

本章将从核心概念讲起，再通过两个实战案例（广告生成 + 短剧整集制作），带你掌握这套进阶工具链。

------

# **一、核心概念：先搞懂三个词**

## **1. 工作流（Workflow）**

工作流是 ComfyUI 的核心概念。简单说，它是一张**可视化的流程图**：每个功能模块是一个"节点"，节点之间用线连接，数据从左到右流动，最终输出图片或视频。

你可以把它想象成一条**可自由拼装的生产流水线**——输入端放原材料（文字、图片、参考图），中间是各种加工站（大模型推理、风格迁移、超分辨率），输出端就是成品。

工作流的强大之处在于：**每一个环节都可以替换、调参、插入新模块。**这是它和封装式工具最本质的区别。

## **2. ComfyUI**

ComfyUI 是一个开源的AI图像/视频生成界面，通过"拖拽节点、连线组网"的方式构建工作流。它支持市面上几乎所有主流模型（Stable Diffusion、Flux、Seedance 等），社区生态极其活跃，工作流模板和自定义节点数量庞大。

**本地安装的门槛不低**：

| **条件** | **要求** |
| -------- | -------------------------------------------- |
| 操作系统 | Windows（需NVIDIA显卡）或 macOS（M系列芯片） |
| 硬件投入 | 中高端显卡起步，高阶玩家往往需要数万元配置 |
| 技术门槛 | 需要一定的环境配置和调试能力 |

- 官方下载：https://www.comfy.org/zh-cn/
- GitHub 仓库：https://github.com/Comfy-Org/ComfyUI

<div style="background-color: #fff3e8; border: 1px solid #ffcc99; border-radius: 12px; padding: 16px 20px; line-height: 1.6;">
  <div style="display: flex; align-items: flex-start; gap: 10px;">
    <span style="font-size: 22px; line-height: 1.6;">🪦</span>
    <div>
      <p style="margin: 0 0 8px 0; font-size: 16px; color: #333;">兑换合集可以阅读剩余的1% ，立即前往微信合集《怎么用AI从0做出短剧/漫剧？》：</p>
      <p style="margin: 0; font-size: 15px; word-break: break-all;">
        <a href="https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzY4NzAzOTMxMQ==&action=getalbum&album_id=4470953841336942601&from_itemidx=1&from_msgid=2247483869#wechat_redirect" style="color: #3b82f6; text-decoration: none;">
          https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzY4NzAzOTMxMQ==&action=getalbum&album_id=4470953841336942601&from_itemidx=1&from_msgid=2247483869#wechat_redirect
        </a>
      </p>
    </div>
  </div>
</div>

