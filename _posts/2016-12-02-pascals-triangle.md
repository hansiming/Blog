---
layout: post
title:  "LeetCode : Pascals Triangle"
date:   2016-12-02 22:01:23
categories: leetcode
permalink: /archivers/pascals_triangle
---
# LeetCode : Pascals Triangle
----
----

### 问题描述

---
> Given numRows, generate the first numRows of Pascal's triangle.

> For example, given numRows = 5,

> Return
> [

>      [1],

>     [1,1],

>    [1,2,1],

>   [1,3,3,1],

>  [1,4,6,4,1]

> ]

### 思路整理

----

> 在每个list的第一个和最后一个都是为1，设置一个队列，当队列的size大于1的时候，下一个list的值为队列中相邻的两个值之和。

### 代码

----

{% highlight java %}

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

/**
 * Created by hansiming on 2016/12/2.
 */
public class Solution {
    public ArrayList<ArrayList<Integer>> generate(int numRows) {
        ArrayList<ArrayList<Integer>> result = new ArrayList<>();
        if(numRows == 0) {
            return  result;
        }
        Queue<Integer> queue = new LinkedList<>();
        for(int i = 0; i < numRows; i++) {
            result.add(getList(queue));
        }
        return result;
    }

    public ArrayList<Integer> getList(Queue<Integer> queue) {
        ArrayList<Integer> list = new ArrayList<>();
        list.add(1);
        if(queue.size() == 0) {
            queue.offer(1);
            return list;
        }
        for(int i = 0; i < queue.size() - 1; i++) {
            int num1 = queue.poll();
            int num2 = queue.peek();
            int sum = num1 + num2;
            queue.offer(sum);
            list.add(sum);
        }
        list.add(1);
        queue.offer(1);
        return list;
    }
}


{% endhighlight %}
