---
layout: post
title:  "Effective Java 4 通过私有构造器强化不可实例化的能力"
date:   2017-03-31 07:22:23
categories: effective_java
permalink: /archivers/effective_java_4
---
# Effective Java 4 通过私有构造器强化不可实例化的能力
----
----
## 有这样的一种工具类(utility class)，该类只包含静态方法和静态域，类似与java.lang.Math和java.util.Collections
## 这样的工具类不希望被实例化，因此我们只要让这个类包含私有构造器，它就不能被实例化了。

{% highlight java %}
//Noninstantiable utility class
public class UtilityClass {

    // 私有化，且无法被实例化，以及防止反射实例化
    private UtilityClass() {
        throw new AssertionError();
    }
}
{% endhighlight %}
