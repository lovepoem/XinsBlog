---
title:  一些有用的github配置
cover: /images/github.jpg
subtitle:  在github的使用过程中，一些有用的github配置，明显改进了流程，方便了开发，随手记录了下来
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- github
categories: 
- github
date: 2019-07-23 19:40:02
---

Github是Git的一个商业化平台，git对应的一些功能在Github上都有体现。 在github的使用过程中，一些有用的github配置，明显改进了流程，方便了开发，随手记录了下来。

###  1、pr完毕联动直接关闭issue ：
**功能：** 当committer合并别人提交的`pull request`的时候，同时联动关闭问题issue
**配置：** https://help.github.com/cn/articles/closing-issues-using-keywords

### 2、设置成sqash 合并提交点：
**功能：** 当committer合并别人提交的选择将提交点进行合并,类似于指令`git squash`
**配置：** https://help.github.com/cn/articles/about-merge-methods-on-github

### 3、更新其他人的分支代码：
**功能：** committer或者pr的提交可以在github界面手动同步主分支的最新代码
类似于指令
```
   git remote update -p
   git pull origin master 
```
**配置：** https://help.github.com/cn/articles/enabling-required-status-checks

### 4、添加测试覆盖率travis-ci 和codecov
**功能：** 用junit、travis-ci 和codecov等采集项目的测试覆盖率，从而进行持续集成
**配置：** 

* Travis CI + Codecov + Junit5 + jacoco + Maven + java8 above Java Example
https://github.com/lovepoem/codecov-travis-maven-junit5-example

* Travis CI + Codecov + Junit4 + cobertura + java1.7 + Maven Java Example
https://github.com/lovepoem/codecov-travis-maven-junit4-example

### 5、添加状态检查

在合作开发中，一些分支的提交者好久没有活动了，远程分支已经修改了很多东西。这个时候就需要提交权限的人来合并。

配置方法如下：

![](/images/enforce-update.png)

效果： 

![](/images/update-branch.png)

参考：

启用必须状态检查：
https://help.github.com/cn/github/administering-a-repository/enabling-required-status-checks

关于必需状态检查：
https://help.github.com/cn/github/administering-a-repository/about-required-status-checks