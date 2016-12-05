---
layout: post
title:  "LeetCode : Populating Next Right Pointers In Each Node"
date:   2016-12-03 22:22:23
categories: leetcode
permalink: /archivers/populating_next_right_pointers_in_each_node
---
# LeetCode : Pascals Triangle
----
----

### 问题描述

---

> Given a binary tree
>     struct TreeLinkNode {
>       TreeLinkNode *left;
>       TreeLinkNode *right;
>       TreeLinkNode *next;
>     }

> Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set toNULL.
> Initially, all next pointers are set toNULL.
> Note:
> You may only use constant extra space.
> You may assume that it is a perfect binary tree (ie, all leaves are at the same level, and every parent has two children).

> For example,
> Given the following perfect binary tree,

>          1

>        /  \

>       2    3

>      / \  / \

>     4  5  6  7

> After calling your function, the tree should look like:

>          1 -> NULL

>        /  \

>       2 -> 3 -> NULL

>      / \  / \

>     4->5->6->7 -> NULL

### 思路整理

----
> 该题难度不大，主要就是要注意，如上例中值为5的节点的next是6，可以通过2节点的next为3来获得。

### 代码

----
{% highlight java %}

public class Solution {
    public void connect(TreeLinkNode root) {
        if(root == null) {
            return;
        }
        if(root.left != null) {
            root.left.next = root.right;
        }
        if(root.right != null && root.next!=null) {
            root.right.next = root.next.left;
        }
            connect(root.left);
            connect(root.right);
    }
}

{% endhighlight %}
