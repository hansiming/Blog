---
layout: post
title:  "LeetCode : Sum Root To Leaf Numbers"
date:   2016-11-27 23:12:13
categories: leetcode
permalink: /archivers/surrounded_regions
---
# LeetCode : Surrounded Regions
----
----

### 问题描述

----
> Given a binary tree containing digits from0-9only, each root-to-leaf path could represent a number.

> An example is the root-to-leaf path1->2->3which represents the number123.

> Find the total sum of all root-to-leaf numbers.

> For example,

>    1

>   / \

>  2   3

> The root-to-leaf path1->2represents the number12.

> The root-to-leaf path1->3represents the number13.

> Return the sum = 12 + 13 =25.

### 思路整理

----
> 题目意思比较好理解，就是给定一个二叉树，然后每个节点都有一个整型的值，从根到叶子进行叠加，树的深底加一，该节点表示的值就要除以10。

> 第一个想法就是，先找到根，然后倒着加回去，就是因为不能确定根的倍数到底是多少，所以没有办法从根开始计算。

> 但是很快就又遇到了一个问题，就是每个节点可能会加两次，因为有左右节点，感觉不是太好计算，然后就看了下别人的解法，很犀利，大概思想如下：

> 类似于二叉树的先序遍历，根--》左--》右 进行递归求值，如果当前节点有子节点，那么当前节点的值可以传入子节点中，然后在子节点中*10。

### 代码

----

```Java
/**
 * Created by hansiming on 2016/11/28.
 */
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int x) { val = x; }
}

public class Solution {

    public int sumNumbers(TreeNode root) {
        if(root == null)
            return 0;
        return dfs(root, 0);
    }

    public int dfs(TreeNode node, int sum) {
        if(node == null) {
            return 0;
        }
        //父节点 * 10 + 当前节点
        sum = sum * 10 + node.val;
        if(node.left == null && node.right == null)
            return sum;

        return dfs(node.left, sum) + dfs(node.right, sum);
    }
}
```
