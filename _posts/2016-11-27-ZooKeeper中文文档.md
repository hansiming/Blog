---
layout: post
title:  "ZooKeeper中文文档"
date:   2016-11-27 21:11:13
categories: ZooKeeper
permalink: /archivers/zookeeper_overview
---

# ZooKeeper 中文文档
------
----
>    ZooKeeper是一个开源的分布式服务框架，它是Apache Hadoop项目的一个子项目，主要用来解决分布式应用场景中存在的一些问题，如：**统一命名服务、状态同步服务、集群管理、分布式应用配置管理**等，它支持*Standalone模式和分布式模式*，在分布式模式下，能够为分布式应用提供高性能和可靠地协调服务，而且使用ZooKeeper可以大大简化分布式协调服务的实现，为开发分布式应用极大地降低了成本。详见[官方文档](http://zookeeper.apache.org/ "官方文档")。

------

### 总体架构

![总体架构](http://zookeeper.apache.org/doc/trunk/images/zkservice.jpg)


* ZooKeeper集群由一组Server节点组成，这一组Server节点中存在一个角色为Leader的节点，其他节点都为Follower。当客户端Client连接到ZooKeeper集群，并且执行写请求时，这些请求会被发送到Leader节点上，然后Leader节点上数据变更会同步到集群中其他的Follower节点。
* Leader节点在接收到数据变更请求后，首先将变更写入本地磁盘，以作恢复之用。当所有的写请求持久化到磁盘以后，才会将变更应用到内存中。
* ZooKeeper使用了一种自定义的原子消息协议，在消息层的这种原子特性，保证了整个协调系统中的节点数据或状态的一致性。Follower基于这种消息协议能够保证本地的ZooKeeper数据与Leader节点同步，然后基于本地的存储来独立地对外提供服务。
* 当一个Leader节点发生故障失效时，失败故障是快速响应的，消息层负责重新选择一个Leader，继续作为协调服务集群的中心，处理客户端写请求，并将ZooKeeper协调系统的数据变更同步（广播）到其他的Follower节点。

-----

### 设计要点

*  简单<br/>

分布式应用中的各个进程可以通过ZooKeeper的命名空间（Namespace）来进行协调，这个命名空间是共享的、具有层次结构的，更重要的是它的结构足够简单，像我们平时接触到的文件系统的目录结构一样容易理解，如图所示：

![分层的命名空间](http://zookeeper.apache.org/doc/trunk/images/zknamespace.jpg)

在ZooKeeper中每个命名空间（Namespace）被称为 **ZNode**，你可以这样理解，每个ZNode包含一个路径和与之相关的元数据，以及继承自该节点的孩子列表。与传统文件系统不同的是，ZooKeeper中的数据保存在内存中，实现了分布式*高吞吐和低延迟。
在上图示例的ZooKeeper的数据模型中，有如下要点：

    * 每个节点（ZNode）中存储的是同步相关的数据（这是ZooKeeper设计的初衷，数据量很小，大概B到KB量级），例如状态信息、配置内容、位置信息等。
    * 一个ZNode维护了一个状态结构，该结构包括：版本号、ACL变更、时间戳。每次ZNode数据发生变化，版本号都会递增，这样客户端的读请求可以基于版本号来检索状态相关数据。
    * 每个ZNode都有一个ACL，用来限制是否可以访问该ZNode。
    * 在一个命名空间中，对ZNode上存储的数据执行读和写请求操作都是原子的。
    * 客户端可以在一个ZNode上设置一个监视器（Watch），如果该ZNode数据发生变更，ZooKeeper会通知客户端，从而触发监视器中实现的逻辑的执行。
    * 每个客户端与ZooKeeper连接，便建立了一次会话（Session），会话过程中，可能发生CONNECTING、CONNECTED和CLOSED三种状态。
    * ZooKeeper支持临时节点（Ephemeral Nodes）的概念，它是与ZooKeeper中的会话（Session）相关的，如果连接断开，则该节点被删除。

*  可靠<br/>

ZooKeeper被设计为复制集群架构，每个节点的数据都可以在集群中复制传播，使集群中的每个节点数据同步一致，从而达到服务的可靠性和可用性。前面说到，ZooKeeper将数据放在内存中来提高性能，为了避免发生单点故障（SPOF），支持数据的复制来达到冗余存储，这是必不可少的。

*  有序<br/>

ZooKeeper使用时间戳来记录导致状态变更的事务性操作，也就是说，一组事务通过时间戳来保证有序性。基于这一特性。ZooKeeper可以实现更加高级的抽象操作，如同步等。

*  快速<br/>

ZooKeeper包括读写两种操作，基于ZooKeeper的分布式应用，如果是读多写少的应用场景（读写比例大约是10:1），那么读性能更能够体现出高效。

-----

### 数据结构

* Zookeeper 会维护一个具有层次关系的数据结构，它非常类似于一个标准的文件系统，如图所示：

![ZooKeeper数据结构](http://www.ibm.com/developerworks/cn/opensource/os-cn-zookeeper/image001.gif)

>1. 每个子目录项如 NameService 都被称作为 znode，这个 znode 是被它所在的路径唯一标识，如 Server1 这个 znode 的标识为 /NameService/Server1。
>2. znode 可以有子节点目录，并且每个 znode 可以存储数据，注意 EPHEMERAL 类型的目录节点不能有子节点目录。
>3. znode 是有版本的，每个 znode 中存储的数据可以有多个版本，也就是一个访问路径中可以存储多份数据。
>4. znode 可以是临时节点，一旦创建这个 znode 的客户端与服务器失去联系，这个 znode 也将自动删除，Zookeeper 的客户端和服务器通信采用长连接方式，每个客户端和服务器通过心跳来保持连接，这个连接状态称为 session，如果 znode 是临时节点，这个 session 失效，znode 也就删除了。
>5. znode 的目录名可以自动编号，如 App1 已经存在，再创建的话，将会自动命名为 App2。
>6. znode 可以被监控，包括这个目录节点中存储的数据的修改，子节点目录的变化等，一旦变化可以通知设置监控的客户端，这个是 Zookeeper 的核心特性，Zookeeper 的很多功能都是基于这个特性实现的，后面在典型的应用场景中会有实例介绍。

* Watches（监视）

>1. ZooKeeper中的Watch是只能触发一次。也就是说，如果客户端在指定的ZNode设置了Watch，如果该ZNode数据发生变更，ZooKeeper会发送一个变更通知给客户端，同时触发设置的Watch事件。如果ZNode数据又发生了变更，客户端在收到第一次通知后没有重新设置该ZNode的Watch，则ZooKeeper就不会发送一个变更通知给客户端。
>2. ZooKeeper异步通知设置Watch的客户端。但是ZooKeeper能够保证在ZNode的变更生效之后才会异步地通知客户端，然后客户端才能够看到ZNode的数据变更。由于网络延迟，多个客户端可能会在不同的时间看到ZNode数据的变更，但是看到变更的顺序是能够保证有序一致的。
>3. ZNode可以设置两类Watch，一个是Data Watches（该ZNode的数据变更导致触发Watch事件），另一个是Child Watches（该ZNode的孩子节点发生变更导致触发Watch事件）。调用getData()和exists() 方法可以设置Data Watches，调用getChildren()方法可以设置Child Watches。调用setData()方法触发在该ZNode的注册的Data Watches。调用create()方法创建一个ZNode，将触发该ZNode的Data Watches；调用create()方法创建ZNode的孩子节点，则触发ZNode的Child Watches。调用delete()方法删除ZNode，则同时触发Data Watches和Child Watches，如果该被删除的ZNode还有父节点，则父节点触发一个Child Watches。
>4. 如果客户端与ZooKeeper Server断开连接，客户端就无法触发Watches，除非再次与ZooKeeper Server建立连接。

* Sequence Nodes（序列节点)

在创建ZNode的时候，可以请求ZooKeeper生成序列，以路径名为前缀，计数器紧接在路径名后面，例如，会生成类似如下形式序列：

  >qn-0000000001, qn-0000000002, qn-0000000003, qn-0000000004, qn-0000000005, qn-0000000006, qn-0000000007
  
对于ZNode的父节点来说，序列中的每个计数器字符串都是唯一的，最大值为2147483647。

* ACLs（访问控制列表）

ACL可以控制访问ZooKeeper的节点，只能应用于特定的ZNode上，而不能应用于该ZNode的所有孩子节点上。它主要有如下五种权限：

>1. CREATE 允许创建Child Nodes
>2. READ 允许获取ZNode的数据，以及该节点的孩子列表
>3. WRITE 可以修改ZNode的数据
>4. DELETE 可以删除一个孩子节点
>5. ADMIN 可以设置权限

ZooKeeper内置了4种方式实现ACL：

>1. world 一个单独的ID，表示任何人都可以访问
>2. auth 不使用ID，只有认证的用户可以访问
>3. digest 使用username:password生成MD5哈希值作为认证ID
>4. ip 使用客户端主机IP地址来进行认证

---------

### 参考链接

* [http://shiyanjun.cn/archives/474.html](http://shiyanjun.cn/archives/474.html "http://shiyanjun.cn/archives/474.html")
* [http://www.ibm.com/developerworks/cn/opensource/os-cn-zookeeper/](http://www.ibm.com/developerworks/cn/opensource/os-cn-zookeeper/ "http://www.ibm.com/developerworks/cn/opensource/os-cn-zookeeper/")