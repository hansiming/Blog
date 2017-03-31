---
layout: post
title:  "Effective Java 1 考虑用静态工厂方法代替构造器"
date:   2016-12-15 22:22:23
categories: effective_java
permalink: /archivers/effective_java_1
---
# Effective Java 1 考虑用静态工厂方法代替构造器
----
----
## 类可以提供一个共有的静态工厂方法（static factory method），它只是一个返回类的实例的静态方法。下面是一个来自Boolean的简单实例：

{% highlight java %}
public static Boolean valueOf(boolean b) {
    return (b ? TRUE : FALSE);
}
{% endhighlight %}

## 静态工厂方法与构造器不同的优势是：

* 它们有名称。

* 不必在每次调用它们的时候都创建一个新对象。这使得不可变类可以使用预先构建好的实例，或者将构建好的实例缓存起来，进行重复利用。

* 它们可以返回原返回类型的任何子类型的对象。在Java框架中就有这样的体现，例如在java.util.Collections 类中。分别提供了不可修改的集合，同步集合等等。几乎所有这些实现都通过静态工厂方法在一个不可实例化的类中导出。

* 4.在创建参数化类型实例的时候，它们使得代码更简洁。在Guava框架对集合的增强很明显。

{% highlight java %}
//传统实例化一个HashMap的方法
Map<String, List<String>> map = new HashMap<String, List<String>>();
//在Guava框架中,明显简洁了不少
Map<String, List<String>> map = Maps.newHashMap();
{% endhighlight %}

## 但是也存在着缺点：

* 类如果不含公有的或者受保护的 构造器就不能被子类化。
* 它们与其他的静态方法实际上没有任何区别。
推荐的几个命名方法：valueOf , of , getInstance , getType , getTypes
