---
title: rpc跟踪日志常用shell统计脚本
subtitle:  rpc跟踪日志作为时间序列数据，一般字段有：时间、traceId、接口名、执行时间ms、执行结果等。笔者将自己常用的shell统计脚本记录下来，也希望对大家有帮助。
author: 
  nick: 王欣
  link: https://wangxin.io
tags: 
- 统计
categories: 
- shell 
date: 2018-12-31 20:40:02

---

一、应用日志分析
rpc跟踪日志作为时间序列数据，一般字段有：时间、traceId、接口名、执行时间ms、执行结果等。笔者将自己常用的shell统计脚本记录下来，也希望读大家有帮助。

下面的日志信息`trace.log`,字段分别是：`时间| traceId|接口名|执行时间ms|执行结果`

```verilog
2018-10-01 14:00:00|1|getById|1|success|
2018-10-01 03:01:00|2|getById|100|fail|
2018-10-02 02:00:00|3|getById|1000|success|
2018-10-01 02:00:00|4|updateById|1000|success|
2018-10-01 02:00:00|5|getById|1000|success|
2018-10-01 02:00:00|6|updateById|200|success|
2018-10-02 14:56:00|7|updateById|20|success|
2018-10-01 02:00:00|8|updateById|60|fail|
2018-10-01 03:00:00|9|updateById|200|success|
2018-10-01 02:02:00|10|updateById|20|success|
2018-10-01 03:02:00|11|insert|20|success|
```
请实现如下需求：

1、执行结果大于200ms的记录

```shell
awk -F "|" '{if($4>=200){print $1" "$2" "$3" "$4 }}' trace.log
```

执行结果

```verilog
2018-10-02 02:00:00 3 getById 1000
2018-10-01 02:00:00 4 updateById 1000
2018-10-01 02:00:00 4 getById 1000
2018-10-01 02:00:00 5 updateById 200
2018-10-01 03:00:00 8 updateById 200
```

2、2018-10-01 日接口数量排行前3

```shell
awk '/2018-10-01/' trace.log |awk -F "|"	 '{print $3}'  |sort|uniq -c|sort -rn| head -3 
```

执行结果

```verilog
5 updateById
3 getById
1 insert
```

3、对于各个接口的执行时间ms按照(0-50,50-100，100-300，300以上)范围进行数量统计

```shell
     awk -F "|" '{totalCnt[$3]++;if($4<=50){ms50[$3]++};if($4>50 && $4<=100){ms100[$3]++};if($4>100 && $4<=300){ms300[$3]++};if($4>300){ms300b[$3]++}}END{for(i in totalCnt)print i,int(ms50[i]),int(ms100[i]),int(ms300[i]),int(ms300b[i])}' trace.log
```

执行结果

```verilog
getById 1 1 0 2
updateById 2 1 2 1
insert 1 0 0 0
```

4、查询trace.log文件各个接口的失败率

```shell
awk -F "|" '{totalCnt[$3]++;if($5=="fail"){failCnt[$3]++}}END{for(i in totalCnt)print i,(failCnt[i]/totalCnt[i])*100"%"}' trace.log
```

执行结果

```verilog
getById 25%
updateById 16.6667%
insert 0%
```

5、查询trace.log各个接口的平均耗时

```shell
awk -F "|" '{totalCnt[$3]++;{rtSum[$3]+=$4}}END{for(i in totalCnt)print i,(rtSum[i]/totalCnt[i])}' trace.log
```

执行结果

```verilog
getById 525.25
updateById 250
insert 20
```

二 、简单数据处理

1、删除id.txt重复id 

```shell
aaaaa
2
111
2
111
aaaaa
aaaaa
aaaaa
```

脚本

```shell
cat id.txt | sort | uniq
```

**执行结果**

```
111
2
aaaaa
```


一些参考：
http://techslides.com/grep-awk-and-sed-in-bash-on-osx
http://www.grapenthin.org/teaching/geop501/lectures/lecture_10_unix2.pdf
http://coewww.rutgers.edu/www1/linuxclass2005/lessons/lesson9/shell_script_tutorial.html
http://blog.chinaunix.net/uid-26736384-id-5756343.html
