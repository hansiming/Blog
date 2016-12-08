---
layout: post
title:  "LeetCode : Distinct Subsequences"
date:   2016-12-05 22:22:23
categories: leetcode
permalink: /archivers/distinct_subsequences
---
# LeetCode : Distinct Subsequences
----
----
### 问题描述

---
> Given a string S and a string T, count the number of distinct subsequences of T in S.

> A subsequence of a string is a new string which is formed from the original string by deleting some (can be none) of the characters

> without disturbing the relative positions of the remaining characters. (ie,"ACE"is a subsequence of"ABCDE"while"AEC"is not).

> Here is an example:

> S ="rabbbit", T ="rabbit"

> Return3.

### 思路整理

----
> 刚拿到题的时候，选择了用dfs去求解，结果应该美什么问题，但是因为有大量的递归，所以超时，优化以后还是超时，就不得不选择换个方法。

> 网上看到了他们使用动态规划来解这道题，很棒，下面是大概的思路。

>   * 初始化一个S.length() * T.length()大小的矩阵。
>   * 其中矩阵的值代表的是，当前T的子串在当前S的子串中可以出现几次。
>   * 因为当T为空串的时候，无论S的子串为什么，都只能出现一次，所以，第一列的值都为1.
>   * 当S.charAt(i - 1) != T.charAt(j - 1),针对S来说，这个字符只能被忽略，所以值为dp[i - 1][j]。
>   * 当S.charAt(i - 1) == T.charAt(j - 1)，针对S来说，就包含了忽略该字符，和不忽略该字符，所以矩阵值为dp[i - 1][j - 1] + dp [i - 1][j]
