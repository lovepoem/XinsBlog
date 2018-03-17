---
title: Apache 提交者注册流程
---
[TOC]

## 前言：
   中国互联网公司这十几年的蓬勃发展，涌现了BAT、华为等一批公司开源项目的领军者，不少个人开发者也不断闪耀在开源领域。
   我最近有幸参与了一个Apache项目的孵化初始化过程，从一个committer的视角将一些注册的流程记录一下。

## 一、项目提交apache孵化器
###  书写孵化项目提案
   在孵化项目提案中，会有初始化提交者列表这一选项。确认你是初始化提交者的一员。项目在apache孵化器社区投票通过后，提交者可以开始准备注册账户了。
## 二、个人开发者提交ICLA

###1、选apache id
   在[apache提交者列表页](http://people.apache.org/committer-index.html)查看可用的apache id，
###2、个人提交者授权协议（ICLA）：
   下载[ICLA模板](https://www.apache.org/licenses/icla.pdf)，查找可用的id。将icla.pdf个人信息填写正确后发送邮件给秘书 secretary@apache.org,秘书会帮忙创建apache 用户id。同时会创建一个your id@apache.org的邮箱，可以在[apache提交者列表页](http://people.apache.org/committer-index.html)查看查找用户是否已经创建。

## 三、加入apache开发者组
   1、登入[Apache账户工具](https://id.apache.org/)，首次登入可以选忘记密码获得初始化密码，会发送到forward邮箱
   2、修改编辑页面的homepage url，[apache提交者列表页](http://people.apache.org/committer-index.html)中你的账户能加主页链接。
   3、修改编辑页面的github账户，会发有邮件邀请你加入github.com/apache组。
## 四、获得提交者对项目的写权限

[GitBox账户链接工具](https://gitbox.apache.org/setup/)的填写

###1、Apache账户授权
   按照提示授权Apache账户OAuth登入
###2、Github账户授权
   按照提示授权Github账户OAuth登入
###3、在github.com设置github账户两因素授权（2FA）
   按照[授权GitHub 2FA wiki](https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/)操作如下：
1、在手机安装 “google身份验证器” app
2、按照[授权GitHub 2FA wiki](https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/)一步一步操作。

   在[两因素授权验证(2. Scan this barcode with your app.)](https://github.com/settings/two_factor_authentication/verify)界面，不选择建议用手机扫描二维码，因为有些手机会扫描不出来。
   请打开手机 “google身份验证器” app，点“+”选择“输入提供的秘钥”： “账户名”填入github账户，“您的秘钥”填打开网页中“enter this text code” 链接里面的文本。手机app点”添加“后将为此账户生成的6位数字动态。将此6位数字填入网页中的文本框，然后点“Enable”。这样2fa就设置成功了。

3、退出并重新登入Github，输入用户名、密码后会多一步。动态密码的填写，用app的动态密码
4、需要约半个小时,会有邮件通知加入xx project-committers开发者组。或者自己去[apache teams](https://github.com/orgs/apache/teams) 查看。
5、2fa提交后你已经clone的项目会有权限校验问题，解决方法为：
  1).申请Access Token
   在github上 生成access token 后，指令行需要密码的地方就粘贴token。
   参考官网[帮助链接一](https://help.github.com/articles/https-cloning-errors/#provide-access-token-if-2fa-enabled)和[帮助链接二](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
  2). 改用ssh
   ssh-keygen 然后把pub文件中的内入粘贴到github上
*注意*：一定要保证github的2fa为"enable"状态。当你将2fa设置为"off"时候，将会被对应的apache committer写权限组除名，直到你再次设置成功。
## 四、The apache way
   社区重于代码
   如果没有在社区(邮件列表)谈过，就当没有发生过