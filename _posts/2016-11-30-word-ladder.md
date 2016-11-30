---
layout: post
title:  "LeetCode : Word Ladder"
date:   2016-11-29 18:05:13
categories: leetcode
permalink: /archivers/word_ladder
---
# LeetCode : Word Ladder
----
----

### 问题描述

----
> Given two words (start and end), and a dictionary, find the length of shortest transformation sequence from start to end, such that:

> Only one letter can be changed at a time

> Each intermediate word must exist in the dictionary

> For example,

> Given:

> start ="hit"

> end ="cog"

> dict =["hot","dot","dog","lot","log"]

> As one shortest transformation is"hit" -> "hot" -> "dot" -> "dog" -> "cog",

> return its length5.

> Note:

> Return 0 if there is no such transformation sequence.

> All words have the same length.

> All words contain only lowercase alphabetic characters.

### 思路整理

----
> 题目的意思大概就是，给定两个单词，分别时start和end， 再给定一个单词数组，找到从start跳转到end的最短序列长度。

> 跳转的条件就是只能有一个字符的更改，而且两个单词只能有一个字符的差距，且该单词在给定的单词数组中。

> 解题思路如下：

>   * 设置两个队列，queue1和queue2，queue1来存储当前步数可以达到的单词，queue2存储下一步可以到达的单词
>   * 遍历queue1的单词，首先判断能否跳转至end，如果不能则看能否跳转至单词数组中的某个单词，如果可以，加至queue2中（防止重复，形成死循环）。
>   * 交换queue1和queue2，如果queue1为空，则不能到达end。

### 代码

----

{% highlight java %}

import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;

/**
 * Created by hansiming on 2016/11/29.
 */
public class Solution {
    public int ladderLength(String start, String end, HashSet<String> dict) {

        if(dict == null || dict.size() == 0)
            return 0;

        dict.remove(start) ;
        dict.remove(end) ;

        //bfs广度优先算法
        Queue<String> queue1 = new LinkedList<>();
        Queue<String> queue2 = new LinkedList<>();
        Queue<String> tempQueue;

        int count = 0;

        queue1.offer(start);

        while(queue1.size() != 0) {
            count++;
            while(queue1.size() != 0) {
                String str = queue1.poll();
                if(isLadder(str, end)) {
                    return count + 1;
                }
                Iterator<String> i = dict.iterator();
                while(i.hasNext()) {
                    String temp = i.next();
                    if(isLadder(str, temp) && dict.contains(temp)) {
                        i.remove();
                        queue2.offer(temp);
                    }
                }
            }
            tempQueue = queue1;
            queue1 = queue2;
            queue2 = tempQueue;
        }

        return 0;
    }

    public boolean isLadder(String src, String dist) {
        int sameCount = 0;
        for(int i = 0; i < src.length(); i++) {
            if(src.charAt(i) != dist.charAt(i))
                sameCount++;
            if(sameCount > 1) {
                return false;
            }
        }
        return true;
    }
}

{% endhighlight %}
