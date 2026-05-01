---
title: 第2篇：四项基本功——提示词、镜头语言、剪映、投流 - 怎么用AI从0做出短剧/漫剧？
subtitle: 开拍前必须掌握的四项底层能力：提示词工程、影视基础、剪映操作与投流分发
cover: /images/makedrama.webp
author:
  nick: 王欣
  link: https://wangxin.io
tags:
- AI短剧
- 短剧制作
categories:
- 短剧制作
date: 2026-04-14 10:00:00
---


## 前言

上一篇我们建立了认知：AI已经可以替代传统剧组中绝大部分执行角色，而你扮演的是导演加制片人——做决策、定方向、把控质量。但"知道能做"和"真正会做"之间，还隔着一层基本功。

这篇讲的就是你在正式动手之前，必须掌握的四项底层能力——**提示词工程、影视基础知识、剪映操作、投流与分发**。其中提示词工程是重中之重，它直接决定了AI给你交出来的东西是"可用的素材"还是"需要反复返工的废品"。这四项能力不难，但必须扎实，后面所有实操环节都建立在这个地基之上。

------

## 一、提示词工程（Prompt Engineering）：你跟AI说话的方式，决定了它交付的质量

### 1.1 提示词是什么？

提示词就是你输入给AI的那段文字指令。无论是让AI写剧本、画角色、生成视频还是配音，你输入的内容就是提示词。

一个残酷的事实是：**同一个AI模型，不同的提示词，输出质量可以差十倍。** 大部分人觉得AI"不好用"，问题往往不在AI，而在于他们不会"说话"。AI的输出质量，80%取决于你怎么提问。

### 1.2 提示词的本质：你是甲方，AI是乙方

你可以这样理解提示词的逻辑——你是甲方，AI是乙方。

你跟设计师说"帮我做个好看的海报"，设计师只能猜你想要什么，大概率交回来的东西你不满意。但如果你说"帮我做一张竖版海报，主色调深蓝，中间放产品图，顶部放slogan用白色无衬线字体，底部放二维码，整体风格参考苹果官网"——设计师一次就能做到八九不离十。

AI也一样。**需求越模糊，输出越随机。需求越具体，输出越可控。** 你写的每一个字，都在压缩AI的"随机性空间"。你留的空白越多，AI就越会按自己的"理解"去填充——而它的理解往往和你的不一样。

### 1.3 万能提示词框架：BROKE

不管你让AI做什么任务——写剧本、画角色、生成视频——都可以用这个框架来组织你的提示词：

**B — Background（背景）：** 这个任务的背景是什么？你在做什么项目？给AI足够的上下文信息，让它理解你所处的语境。

**R — Role（角色）：** 让AI扮演什么角色？比如"你是一个有十年经验的短剧编剧""你是一个擅长古风人物的插画师"。角色设定会显著影响AI的输出风格和专业度。

**O — Objective（目标）：** 具体要完成什么任务？目标越清晰、越单一，AI的输出越精准。不要一个提示词里塞五件事。

**K — Key Information（关键信息）：** 限制条件、风格要求、格式要求、参考素材、字数/时长/分辨率等硬性约束。这部分信息越详细，AI"跑偏"的概率越低。

**E — Example（示例）：** 给一个你期望的输出样例。这是提升提示词效果最立竿见影的方法。AI看到示例后，会模仿示例的结构、风格和细节程度来输出。

下面我用三个短剧制作中最常见的场景，来演示好提示词和差提示词之间的差距。


<div style="background-color: #fff3e8; border: 1px solid #ffcc99; border-radius: 12px; padding: 16px 20px; line-height: 1.6;">
  <div style="display: flex; align-items: flex-start; gap: 10px;">
    <span style="font-size: 22px; line-height: 1.6;">🪦</span>
    <div>
      <p style="margin: 0 0 8px 0; font-size: 16px; color: #333;">兑换合集可以阅读剩余的90% ，立即前往微信合集《怎么用AI从0做出短剧/漫剧？》：</p>
      <p style="margin: 0; font-size: 15px; word-break: break-all;">
        <a href="https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzY4NzAzOTMxMQ==&action=getalbum&album_id=4470953841336942601&from_itemidx=1&from_msgid=2247483869#wechat_redirect" style="color: #3b82f6; text-decoration: none;">
          https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzY4NzAzOTMxMQ==&action=getalbum&album_id=4470953841336942601&from_itemidx=1&from_msgid=2247483869#wechat_redirect
        </a>
      </p>
    </div>
  </div>
</div>
