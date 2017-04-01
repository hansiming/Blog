---
layout: post
title:  "Effective Java 3 用私有构造器或者枚举类型强化Singleton属性"
date:   2017-03-31 07:22:23
categories: effective_java
permalink: /archivers/effective_java_3
---
# Effective Java 3 用私有构造器或者枚举类型强化Singleton属性
----
----
## Singleton是指仅仅被实例化一次的类。实现方法如下：

----

### 第一种方法 共有静态成员是个final域
{% highlight java %}
//method 1
public class Elvis {

    //Singleton with public final field
    public static final Elvis INSTANCE = new Elvis();

    //private constructor
    private Elvis() {}
}
{% endhighlight %}

----

### 第二种方法 公有的成员是个静态工厂方法
{% highlight java %}
//method 2
public class Elvis {

    //Singleton with private final field
    private static final Elvis INSTANCE = new Elvis();

    //private constructor
    private Elvis() {}

    //static factory method
    public static Elvis getInstance() {
        return INSTANCE;
    }
}
{% endhighlight %}
