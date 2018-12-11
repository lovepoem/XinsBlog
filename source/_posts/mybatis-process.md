---
title: mybatis调用流程
cover: /images/mybatis.png
subtitle:  MyBatis 是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架。避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集。可以对配置和原生Map使用简单的 XML 或注解，将接口和 Java 的 POJOs(Plain Old Java Objects,普通的 Java对象)映射成数据库中的记录。MyBatis并不刻意于完成ORM(对象映射)的完整概念，而是旨在更简单、更方便地完成数据库操作功能，减轻开发人员的工作量.
author: 
  nick: 王欣
  link: http://lovepoem.github.io
tags: 
- mybatis
categories: 
- mybatis 
date: 2014-07-05 02:01:02
---
[TOC]
### 一、什么是MyBatis      

​     MyBatis 是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架。避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集。可以对配置和原生Map使用简单的 XML 或注解，将接口和 Java 的 POJOs(Plain Old Java Objects,普通的 Java对象)映射成数据库中的记录。MyBatis并不刻意于完成ORM(对象映射)的完整概念，而是旨在更简单、更方便地完成数据库操作功能，减轻开发人员的工作量.

​       1.根据 JDBC 规范建立与数据库的连接；

​       2.通过反射打通 Java 对象与数据库参数交互之间相互转化关系。

### 二、MyBatis简单示例

#### 1、mybatis实例

​      虽然在使用MyBatis时一般都会使用XML文件，但是本文为了分析程序的简单性，简单的测试程序将不包含XML配置，该测试程序包含一个接口、一个启动类：

 ```java
public interface UserMapper {
  @Select("SELECT * FROM user WHERE id = #{id}")
  User selectUser(intid);
}
  
public class MybatisTest {
    public static void main(String[] args) {
        SqlSessionFactory sqlSessionFactory = initSqlSessionFactory();
        SqlSession session = sqlSessionFactory.openSession();
        try {
            User user = (User) session.selectOne("testmybatis.UserMapper.selectUser", 1);
            //int total = session.delete("testmybatis.UserMapper.deleteById", 1);
            //System.out.println("total-----"+total);
            System.out.println(user.getAddress());
            System.out.println(user.getName());
        } finally {
            session.close();
        }
    }
 
    private static SqlSessionFactory initSqlSessionFactory() {
        DataSource dataSource = new PooledDataSource("com.mysql.jdbc.Driver", "jdbc:mysql://localhost:3306/test", "root", "root");
        TransactionFactory transactionFactory = new JdbcTransactionFactory();
        Environment environment = new Environment("development", transactionFactory, dataSource);
        Configuration configuration = new Configuration(environment);
        configuration.addMapper(UserMapper.class);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(configuration);
 
        return sqlSessionFactory;
    }
}
 ```

　　UserMapper是一个接口，我们在构建sqlSessionFactory时通过configuration.addMapper(UserMapper.class)把该接口注册进了sqlSessionFactory中。从上面的代码中我们可以看出，要使用MyBatis，我们应该经过以下步骤：1、创建sqlSessionFactory（一次性操作）；2、用sqlSessionFactory对象构造sqlSession对象；3、调用sqlSession的相应方法；4、关闭sqlSession对象。

    在main方法中，我们没有配置sql，也没有根据查询结果拼接对象，只需在调用sqlSession方法时传入一个命名空间以及方法参数参数即可，所有的操作都是面向对象的。在UserMapper接口中，我们定制了自己的sql，MyBatis把书写sql的权利给予了我们，方便我们进行sql优化及sql排错。

#### 2、JDBC基础回顾

​      直接使用JDBC是很痛苦的，JDBC连接数据库包含以下几个基本步骤：1、注册驱动 ；2、建立连接(Connection)；3、创建SQL语句(Statement)；4、执行语句；5、处理执行结果(ResultSet)；6、释放资源，示例代码如下：

```java
public static void test()throwsSQLException{
    // 1.注册驱动
    Class.forName("com.mysql.jdbc.Driver");
   
    // 2.建立连接  url格式 - JDBC:子协议:子名称//主机名:端口/数据库名？属性名=属性值&...
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc","root","";
   
    // 3.创建语句
    Statement st = conn.createStatement();
   
    // 4.执行语句
    ResultSet rs = st.executeQuery("select * from user");
   
    // 5.处理结果
    while(rs.next()) {　
    　User user =newUser(rs.getObject(1), rs.getObject(2));
    }
   
    // 6.释放资源
    rs.close();
    st.close();
    conn.close();
}
```

　　可以看到与直接使用JDBC相比，MyBatis为我们简化了很多工作：

​      1、把创建连接相关工作抽象成一个sqlSessionFactory对象，一次创建多次使用；

​      2、把sql语句从业务层剥离，代码逻辑更加清晰，增加可维护性；

​      3、自动完成结果集处理，不需要我们编写重复代码。

​      但是，我们应该知道的是，框架虽然能够帮助我们简化工作，但是框架底层的代码肯定还是最基础的JDBC代码，因为这是Java平台连接数据库的通用方法，今天我将分析一下MyBatis源码，看看MyBatis是如何把这些基础代码封装成一个框架的。

### 三、mybatis 的架构体系

#### 1、Mybatis的功能架构

**分为三层（图片借用了百度百科）：**

1)       API接口层：提供给外部使用的接口API，开发人员通过这些本地API来操纵数据库。接口层一接收到调用请求就会调用数据处理层来完成具体的数据处理。

2)       数据处理层：负责具体的SQL查找、SQL解析、SQL执行和执行结果映射处理等。它主要的目的是根据调用的请求完成一次数据库操作。

3)      基础支撑层：负责最基础的功能支撑，包括连接管理、事务管理、配置加载和缓存处理，这些都是共用的东西，将他们抽取出来作为最基础的组件。为上层的数据处理层提供最基础的支撑。
 ![img](http://img.blog.csdn.net/20130609212728328)
#### 2、整体流程图

![img](http://img.my.csdn.net/uploads/201306/09/1370783456_4126.JPG)

​     初始化Mybatis，所有的配置都在Configuration对象中 使用Mybatis，从SqlSessionFactory工厂中获取SqlSession，从Configuration对象中获取mapper对象，并返回结果 Mybatis在加载mapper的时候对mapper接口的注解进行解析 重要的几个包：io、session、builder、mapper（annotations、binding）、executor

​    源代码主要在org.apache.ibatis目录下，18个包，其中在应用中主要的包有：builder、session、cache、type、transaction、datasource、jdbc、mapping，提供支撑服务的包有annotation、binding、io、logging、plugin、reflection、scripting、exception、executor、parsing

#### 3、代码堆栈跟踪

我们最终调用的是sqlSession对象上的方法，所以我们先跟踪sqlSession的创建方法：sqlSessionFactory.openSession()，最终这个方法会调用到DefaultSqlSessionFactory的以下方法：
```java
private SqlSession openSessionFromDataSource(ExecutorType execType, TransactionIsolationLevel level,booleanautoCommit) {
    Transaction tx =null;
    try{
      finalEnvironment environment = configuration.getEnvironment();
      finalTransactionFactory transactionFactory = getTransactionFactoryFromEnvironment(environment);
      tx = transactionFactory.newTransaction(environment.getDataSource(), level, autoCommit);
      finalExecutor executor = configuration.newExecutor(tx, execType);
      returnnewDefaultSqlSession(configuration, executor, autoCommit);
    }catch(Exception e) {
      closeTransaction(tx);// may have fetched a connection so lets call close()
      throwExceptionFactory.wrapException("Error opening session.  Cause: "+ e, e);
    }finally{
      ErrorContext.instance().reset();
    }
  }
```
　　最终返回的对象是一个DefaultSqlSession对象，在调试模式下，我们看到autoCommit为false，executor为CachingExecutor类型，在CachingExecutor里面有属性delegate，其类型为simpleExecutor：

![img](http://images.cnitblog.com/blog/677938/201412/131414173377016.png)

​      现在，我们跟进DefaultSqlSession的selectOne()方法，查看该方法的调用流程，selectOne()方法又会调用selectList()方法：

```java
public <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds) {
  try{
    MappedStatement ms = configuration.getMappedStatement(statement);
    List<E> result = executor.query(ms, wrapCollection(parameter), rowBounds, Executor.NO_RESULT_HANDLER);
    returnresult;
  }catch(Exception e) {
    throwExceptionFactory.wrapException("Error querying database.  Cause: "+ e, e);
  }finally{
    ErrorContext.instance().reset();
  }
}
```
　　可以看到要得到查询结果，最终还是要调用executor上的query方法，这里的executor是CachingExecutor实例，跟进程序得到如下代码：

```java
public <E> List<E> query(MappedStatement ms, Object parameterObject, RowBounds rowBounds, ResultHandler resultHandler)throwsSQLException {
  BoundSql boundSql = ms.getBoundSql(parameterObject);
  CacheKey key = createCacheKey(ms, parameterObject, rowBounds, boundSql);
  returnquery(ms, parameterObject, rowBounds, resultHandler, key, boundSql);
}
  
public <E> List<E> query(MappedStatement ms, Object parameterObject, RowBounds rowBounds, ResultHandler resultHandler, CacheKey key, BoundSql boundSql)
    throwsSQLException {
  Cache cache = ms.getCache();
  if(cache !=null) {
    flushCacheIfRequired(ms);
    if(ms.isUseCache() && resultHandler ==null) {
      ensureNoOutParams(ms, parameterObject, boundSql);
      @SuppressWarnings("unchecked")
      List<E> list = (List<E>) tcm.getObject(cache, key);
      if(list ==null) {
        list = delegate.<E> query(ms, parameterObject, rowBounds, resultHandler, key, boundSql);
        tcm.putObject(cache, key, list);// issue #578. Query must be not synchronized to prevent deadlocks
      }
      returnlist;
    }
  }
  returndelegate.<E> query(ms, parameterObject, rowBounds, resultHandler, key, boundSql);
}
　　
```
MyBatis框架首先生成了一个boundSql和CacheKey，在boundSql中包含有我们传入的sql语句

​      生成boundSql和CacheKey后会调用一个重载函数，在重载函数中，我们会检测是否有缓存，这个缓存是MyBatis的二级缓存，我们没有配置，那么直接调用最后一句delegate.<E> query(ms, parameterObject, rowBounds, resultHandler, key, boundSql)，前面说过这个delagate其实就是simpleExecutor，跟进去查看一下：
```java
public <E> List<E> query(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, CacheKey key, BoundSql boundSql)throwsSQLException {
    ErrorContext.instance().resource(ms.getResource()).activity("executing a query").object(ms.getId());
    if(closed)thrownewExecutorException("Executor was closed.");
    if(queryStack ==0&& ms.isFlushCacheRequired()) {
      clearLocalCache();
    }
    List<E> list;
    try{
      queryStack++;
      list = resultHandler ==null? (List<E>) localCache.getObject(key) :null;
      if(list !=null) {
        handleLocallyCachedOutputParameters(ms, key, parameter, boundSql);
      }else{
        list = queryFromDatabase(ms, parameter, rowBounds, resultHandler, key, boundSql);
      }
    }finally{
      queryStack--;
    }
    if(queryStack ==0) {
      for(DeferredLoad deferredLoad : deferredLoads) {
        deferredLoad.load();
      }
      deferredLoads.clear();// issue #601
      if(configuration.getLocalCacheScope() == LocalCacheScope.STATEMENT) {
        clearLocalCache();// issue #482
      }
    }
    returnlist;
  }
```
　　关键代码是以下三行：
```java
list = resultHandler ==null? (List<E>) localCache.getObject(key) :null;
if (list != null) {
  handleLocallyCachedOutputParameters(ms, key, parameter, boundSql);
} else{
  list = queryFromDatabase(ms, parameter, rowBounds, resultHandler, key, boundSql);
}
```
　　首先尝试从localCache中根据key得到List，这里的localCache是MyBatis的一级缓存，如果得不到则调用queryFromDatabase()从数据库中查询：
```java

private <E> List<E> queryFromDatabase(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, CacheKey key, BoundSql boundSql)throwsSQLException {
  List<E> list;
  localCache.putObject(key, EXECUTION_PLACEHOLDER);
  try{
    list = doQuery(ms, parameter, rowBounds, resultHandler, boundSql);
  }finally{
    localCache.removeObject(key);
  }
  localCache.putObject(key, list);
  if(ms.getStatementType() == StatementType.CALLABLE) {
    localOutputParameterCache.putObject(key, parameter);
  }
  returnlist;
}
```
​      其中关键代码是调用doQuery()代码，SimpleExecutor的doQuery()方法如下：

```java
ThreadLocalContainer.setRequestString(paramString);
  
public <E> List<E> doQuery(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, BoundSql boundSql)throwsSQLException {
  Statement stmt =null;
  try{
    Configuration configuration = ms.getConfiguration();
    StatementHandler handler = configuration.newStatementHandler(wrapper, ms, parameter, rowBounds, resultHandler, boundSql);
    stmt = prepareStatement(handler, ms.getStatementLog());
    returnhandler.<E>query(stmt, resultHandler);
  }finally{
    closeStatement(stmt);
  }
}
```
　　调用了prepareStatement方法，该方法如下：

 

　　终于，我们看到熟悉的代码了，首先得到Connection，然后从Connection中得到Statement，同时在调试模式下我们看到，我们的sql语句已经被设置到stmt中了：

![img](http://images.cnitblog.com/blog/677938/201412/131511151502445.png)

　　现在Statement对象有了，sql也设置进去了，就只差执行以及对象映射了，继续跟进代码，我们会跟踪到org.apache.ibatis.executor.statement.

PreparedStatementHandler类的executor方法：
```java
public <E> List<E> query(Statement statement, ResultHandler resultHandler) throwsSQLException {
  PreparedStatement ps = (PreparedStatement) statement;
  ps.execute();
  return resultSetHandler.<E> handleResultSets(ps);
}
```
　　在这里，调用了ps.execute()方法执行sql，接下来调用的resultSetHandler.<E> handleResultSets(ps)方法明显是对结果集进行封装。     
```java
public class FastResultSetHandler implements ResultSetHandler {
public List handleResultSets(Statement stmt) throws SQLException {
        List multipleResults = new ArrayList();
        List resultMaps = mappedStatement.getResultMaps();
        int resultMapCount = resultMaps.size();
        int resultSetCount = 0;
        ResultSet rs = stmt.getResultSet();
        label0: do
            do {
                if (rs != null)
                    break label0;
                if (!stmt.getMoreResults())
                    continue label0;
                rs = stmt.getResultSet();
            } while (true);
        while (stmt.getUpdateCount() != -1);
        validateResultMapsCount(rs, resultMapCount);
        for (; rs != null && resultMapCount > resultSetCount; resultSetCount++) {
            ResultMap resultMap = (ResultMap) resultMaps.get(resultSetCount);
            handleResultSet(rs, resultMap, multipleResults);
            rs = getNextResultSet(stmt);
            cleanUpAfterHandlingResultSet();
        }
 
        return collapseSingleResultList(multipleResults);
    }
} 
```
### 四、api文档

#### 1、mybatis 中文

<http://mybatis.github.io/mybatis-3/zh/index.html>

#### 2、mybatis 接口

<http://mybatis.github.io/mybatis-3/zh/xref/index.html>