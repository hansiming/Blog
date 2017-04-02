---
layout: post
title:  "Effective Java 5 避免创建不必要的对象"
date:   2017-04-01 07:22:23
categories: effective_java
permalink: /archivers/effective_java_5
---
# Effective Java 5 避免创建不必要的对象
----
----
## 一般来说，最好能重用对象而不是在每次需要的时候就创建一个相同功能的新对象。重用方式既快速，又流行。
## 如果对象是不可变的(immutable,类似于String类)，它就始终可以被重用。

### 下面是个极端的例子

{% highlight java %}
String s = new String("string"); //
{% endhighlight %}

### 传递给String构造器的"string"本身就是一个String实例，所以该语句每次被执行的时候就都会创建一个新的String实例。 当循环多次时，就会创建出很多的没有必要的String实例。

### 改进后的版本

{% highlight java %}
String s = "string"; //
{% endhighlight %}

----

## 除了重用不可变的对象之外，也可以重用那些已知不会被修改的可变对象

### 下面这个例子是关于计算一个人是否出生在生育高峰期（1946-1956）

{% highlight java %}
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

public class Person {

    private final Date birthDate;

    public Person(Date birthDate) {
        this.birthDate = birthDate;
    }

    public boolean isBabyBoomer() {

        //when use this method, gmtCal, boomStart, boomEnd would be instance
        Calendar gmtCal = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
        gmtCal.set(1946, Calendar.JANUARY, 1, 0, 0, 0);
        Date boomStart = gmtCal.getTime();
        gmtCal.set(1956, Calendar.JANUARY, 1, 0, 0, 0);
        Date boomEnd = gmtCal.getTime();
        return birthDate.compareTo(boomStart) >= 0 && birthDate.compareTo(boomEnd) < 0;
    }
}
{% endhighlight %}

### 可以很明显的看出来，每次调用isBabyBoomer这个方法时，gmtCal, boomStart, boomEnd这三个对象都会被实例化。
### 虽然Date是个可变对象，但是boomStart和boomEnd在该需求下是不会变的。

{% highlight java %}
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

public class Person {

    private final Date birthDate;
    private static final Calendar gmtCal;
    private static final Date BOOM_START;
    private static final Date BOOM_END;

    static {

        //when first use Person class, this field would instance,just only 1 time
        gmtCal = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
        BOOM_START = gmtCal.getTime();
        BOOM_END = gmtCal.getTime();
    }

    public Person(Date birthDate) {
        this.birthDate = birthDate;
    }

    public boolean isBabyBoomer() {

        gmtCal.set(1946, Calendar.JANUARY, 1, 0, 0, 0);
        gmtCal.set(1956, Calendar.JANUARY, 1, 0, 0, 0);
        return birthDate.compareTo(BOOM_START) >= 0 && birthDate.compareTo(BOOM_END) < 0;
    }
}
{% endhighlight %}

### 修改后的版本，Person类只在初始化的时候创建Calendar，Date的实例一次，而不是在调用方法的时候，每次都实例化。

----

## 在Java1.5中提出了自动装箱的概念，需要小心因为装箱而产生不必要的对象。

{% highlight java %}
public static void main(String[] args) {

      //use Long, would autoboxing, DONT DO THIS
      Long sum = 0L;
      for (int i = 0; i < Integer.MAX_VALUE; i++) {
          sum += i;
      }
}
{% endhighlight %}  

### 变量sum被声明成Long而不是long，意味着程序每次循环都需要构造出一个Long的实例。
### 要优先使用基本类型而不是装箱基本类型，要当心无意识的自动装箱。
