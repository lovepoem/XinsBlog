---
title: Java lambda表达式(一)——语法
cover: /images/java.png
subtitle: 长期以来，Java语言被吐槽”臃肿不堪“，不如Ruby、python、groovy等”动态“原因简介明了。所谓简明了，大家一般指的是下面这些,代码行数多。jdk开发者从Java 8 开始，提供了越来越丰富的语法糖，各种lambda 表达式让代码越来越简明。比如 for each、 java bean的getter、setter，所以Java程序员的代码量一般很高。Lambda 表达式是一个匿名方法，将行为像数据一样进行传递
author: 
  nick: 王欣
  link: http://wangxin.io
tags:
- java8
- lambda
categories: 
- java
- lambda表达式 
date: 2018-07-08 11:01:02
---
##  一.为什么要用lambda 表达式

###  1. 为什么要用lambda表达式？
​         长期以来，Java语言被吐槽”臃肿不堪“，不如Ruby、python、groovy等”动态“原因简介明了。所谓简明了，大家一般指的是下面这些：

 * 代码行数多。比如 for each、 java bean的getter、setter，所以Java程序员的代码量一般很高。

 * api不够自然表意，不如动态语言的”语法糖“丰富。

​         Java平台是不断进化的，针对这些”槽点“，jdk开发者从`Java 8` 开始，提供了越来越丰富的语法糖，各种`lambda 表达式`让代码越来越简明 。甚至在`Java 11`的[里程碑计划中](http://openjdk.java.net/projects/jdk/11/), `var`关键字已经本采用了，所以Java”越来越Scala化“了。作为开发者，要了解这些特性，并熟练掌握，为我所用。  

### 2. 什么是Java lambda表达式？   
 *  Lambda 表达式是一个匿名方法，将行为像数据一样进行传递
 *  Lambda 表达式的基本结构：`BinaryOp<Integer> add = (x+y) -> x+y` 
 *  函数接口指具有单个抽象方法的接口，用来表示 Lambda表达式的类型

##  二.lambda 表达式的使用方式

### 1、流(stream)
`Stream` 即为`java.util.stream.Stream`

我们有这一样一个例子：计算一个小组中男人的数量。
**外部迭代**
我们一般会用for循环来计算
```
 int count = 0;
for(Member meber : allMembers){
     if(member.isMale()){
       count++; 
    }
} 
```
for循环其实是封装了迭代的语法糖Iterator对象

```
int count = 0;
Iterator<Member> iterator = allMembers.iterator(); 
while(iterator.hasNext()){
   Member meber =iterator.next();
     if(member.isMale()){
       count++; 
    }
} 
```
**内部迭代**
```
int count  allMembers.stream().filter().count(member -> member.isMale());
```
### 2、常用流操作
#### collect(toList())
#### map
#### flatMap
#### max和min
#### rduce

### 3、集合和收集器
`Collectors` 即为`java.util.stream.Collectors`
#### 转换成其他集合
```
/** 转换成TreeSet **/
List<Member> allMembers = new ArrayList<>();
TreeSet set  = allMembers.stream().collect(ToCollection(TreeSet::new));
```
#### 转换成值
```
/** 转换成TreeSet **/
List<Member> allMembers = new ArrayList<>();
TreeSet set  = allMembers.stream().collect(ToCollection(TreeSet::new));
```
#### 数据分组
```
/** 使用主唱对专辑分组 **/
/** 类似于sql的group by **/
private Map<Artist,List<Album>> albumByArtist(Stream<Album> albums){
   return albums.collect(groupingBy(album -> album.getMainMusician()));
}
```
#### 组合收集器
```
/** 使用收集器求每个艺术家的专辑名 **/
private Map<Artist,List<Album>> nameOfAllAlbums(Stream<Album> albums){
   return albums.collect(groupingBy(album -> album.getMainMusician(),mapping(Album::getName,toList())));
}
```

### 4、利用lambda表达式编写并发程序
非阻塞IO，异步IO,可以并发处理大量网络连接。Lambda可以方便api处理

#### 聊天室(回调) TODO

#### 利用java8的CompletableFuture异步并行操作(Future)
示例代码见：[《Java lambda表达式(二)---利用java8的CompletableFuture异步并行操作》](https://wangxin.io/2018/08/08/java/parallel_operation_by_completable_future/)


参考：《Java 8函数式编程》https://book.douban.com/subject/26346017/
