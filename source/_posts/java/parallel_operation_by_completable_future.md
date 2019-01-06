---
title: Java lambda表达式(二)————利用java8的CompletableFuture异步并行操作
cover: /images/java.png
subtitle:  业务上常常有这样一个需求：一个服务常常会从多个数据源取得数据，然后并成一个结果。现在java8提供了一个很好的CompletableFuture工具。 一般的异步异步设计方案为：起一个业务的线程池，并发执行业务，然后一个守护的线程等各个业务结束(时间为业务执行最长的时间)，获取所有数据，这样明显执行时间会小于3个业务时间之和（例如下面的getAllInfoByProductId）。而是用了执行最长的业务时间，加上守护线程的消耗。
author: 
  nick: 王欣
  link: http://lovepoem.github.io
tags: 
- 并行 
- 异步 
- java8
categories: 
- java
- lambda表达式 
date: 2018-08-08 12:01:02
---
**需求点**：业务上常常有这样一个需求：一个服务常常会从多个数据源取得数据，然后并成一个结果。
   这个操作，假设有3个数据源，同步处理通常的做法是：需要queryData1，queryData2，queryData3。执行时间会是3个时间之和。
​      一般的异步设计方案为：起一个业务的线程池，并发执行业务，然后由一个守护的线程等各个业务结束(时间为业务执行最长的时间)，获取所有数据。这样明显执行时间会小于3个业务时间之和（例如下面的getAllInfoByProductId）。因为：消耗时间=执行最长的业务时间+守护线程的时间。

​      例如用 jdk的Future和线程池实现类似功能，自己造了轮子各种调试。

​     现在java8提供了一个很好的CompletableFuture工具，非常爽。Talk is cheap, show you the code：

 ```java
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

/**
 * 并行获取各个数据源的数据合并成一个数据组合
 */
public class ParallelTest {
    /**
     * 获取基本信息
     *
     * @return
     */
    public String getProductBaseInfo(String productId) {
        return productId + "商品基础信息";
    }

    /**
     * 获取详情信息
     *
     * @return
     */
    public String getProductDetailInfo(String productId) {
        return productId + "商品详情信息";
    }

    /**
     * 获取sku信息
     *
     * @return
     */
    public String getProductSkuInfo(String productId) {
        return productId + "商品sku信息";
    }

    /**
     * 取得一个商品的所有信息（基础、详情、sku）
     *
     * @param productId
     * @return
     */
    public String getAllInfoByProductId(String productId) {
        CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> getProductBaseInfo(productId));
        CompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> getProductDetailInfo(productId));
        CompletableFuture<String> f3 = CompletableFuture.supplyAsync(() -> getProductSkuInfo(productId));
        //等待三个数据源都返回后，再组装数据。这里会有一个线程阻塞
        CompletableFuture.allOf(f1, f2, f3).join();
        try {
            String baseInfo = f1.get();
            String detailInfo = f2.get();
            String skuInfo = f3.get();
            return baseInfo + "" + detailInfo + skuInfo;
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }
   /**
    *   并行获取数据的计算
    */
    @Test
    public void testGetAllInfoParalleByProductId() throws ExecutionException, InterruptedException {
        ParallelTest test = new ParallelTest();
        String info = test.getAllInfoByProductId("1111");
        Assertions.assertNotNull(info);
    }
   /**
    *   同步获取执行的处理
    */
    @Test
    public void testGetAllInfoDirectly() throws ExecutionException, InterruptedException {
        ParallelTest test = new ParallelTest();
        String info1 = getProductBaseInfo("1111");
        String info2 = getProductDetailInfo("1111");
        String info3 = getProductSkuInfo("1111");
        String info=baseInfo + "" + detailInfo + skuInfo;
        Assertions.assertNotNull(info);
    }
}
 ```
allOf是等待所有任务完成，接触阻塞，获取各个数据源的数据。

**改进**
对于上面的例子，使用了默认的线程池，线程数为cpu核数-1。这个并不能很好地利用资源。下面为线程数计算的公式：

```
服务器端最佳线程数量=((线程等待时间+线程cpu时间)/线程cpu时间) * cpu数量
```
下面例子中也将executor线程池暴露出来，方便配置线程数和做一些其他处理。

```java
public class ParallelTest {
        ExecutorService executor = Executors.newFixedThreadPool(100);    
        /**
         * 取得一个商品的所有信息（基础、详情、sku）
         *
         * @param productId
         * @return
         */
        public String getAllInfoByProductId(String productId) {
            CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> getProductBaseInfo(productId),executor);
            CompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> getProductDetailInfo(productId),executor);
            CompletableFuture<String> f3 = CompletableFuture.supplyAsync(() -> getProductSkuInfo(productId),executor);
    
            try {
                String baseInfo = f1.get();
                String detailInfo = f2.get();
                String skuInfo = f3.get();
                return baseInfo + "" + detailInfo + skuInfo;
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (ExecutionException e) {
                e.printStackTrace();
            }
            return null;
        }
    }
```

当然还有其他的类似处理：
   以前在处理类似问题的时候，用了twitter的一个util工具（scala语言实现）

 ```xml
<dependency>
	<groupId>com.twitter</groupId>
	<artifactId>util-core_2.11</artifactId>
	<version>${util-core_2.11.version}</version>
</dependency>
 ```
 用这个工具包的Future实现了类似的功能，但是多加了一种语言依赖

 参考：
 https://blog.csdn.net/u011726984/article/details/79320004
 http://iamzhongyong.iteye.com/blog/1924745
