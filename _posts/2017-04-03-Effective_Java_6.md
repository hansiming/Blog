---
layout: post
title:  "Effective Java 6 消除过期的对象引用"
date:   2017-04-03 07:22:23
categories: effective_java
permalink: /archivers/effective_java_6
---

# Effective Java 6 消除过期的对象引用

----

##

{% highlight java %}

import java.util.Arrays;
import java.util.EmptyStackException;

public class Stack {

    private Object[] elements;
    private int size = 0;
    private int DEFAULT_INITIAL_CAPACITY = 16;

    public Stack() {
        elements = new Object[DEFAULT_INITIAL_CAPACITY];
    }

    public void push(Object e) {
        ensureCapacity();
        elements[size++] = e;
    }

    public Object pop() {
        if(size == 0)
            throw new EmptyStackException();
        return elements[--size];
    }

    private void ensureCapacity() {
        if(elements.length == size) {
            elements = Arrays.copyOf(elements, 2 * size + 1);
        }
    }
}

{% endhighlight %}
