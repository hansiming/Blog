---
layout: post
title:  "LeetCode : Surrounded Regions"
date:   2016-11-27 23:12:13
categories: leetcode
permalink: /archivers/surrounded_regions
---

# LeetCode : Surrounded Regions
----
----

### 问题描述

----

> Given a 2D board containing'X'and'O', capture all regions surrounded by'X'.
> A region is captured by flipping all'O's into'X's in that surrounded region .
> For example,

> X X X X

> X O O X

> X X O X

> X O X X

> After running your function, the board should be:

> X X X X

> X X X X

> X X X X

> X O X X

### 思路整理

----

> 在2D Board中，但凡是能连着触碰到边界的‘O’都不能被变为‘X’，例如：

> X X X X

> O O X X

> X X X X 

> 在上面的2D Board中，第二行的两个O是连着触碰到了边界，所以这两个O都不能变为'X'
> 根据上述很容易就想到方法：
>1. 遍历边界，如果是‘O’，则通过dfs递归上下左右，找到连着的‘O’，并做上标记，修改为‘*’
>2. 便利2D Board将标记为‘*’的修改为‘O’， 标记为‘O’的修改为‘X’

### 代码

----

```Java
/**
 * Created by hansiming on 2016/11/24.
 */
public class Solution {
    public void solve(char[][] board) {
        if(board == null || board.length == 0)
            return;
        int rows = board.length;
        int cols = board[0].length;
        for(int i = 0; i < rows; i++) {
            dfs(board, i, 0);
            dfs(board, i, cols - 1);
        }
        for(int i = 0; i < cols; i++) {
            dfs(board, 0, i);
            dfs(board, rows - 1, i);
        }
        for(int i = 0; i < rows; i++) {
            for(int j = 0; j < cols; j++) {
                if(board[i][j] == 'O')
                    board[i][j] = 'X';
                if(board[i][j] == '*')
                    board[i][j] = 'O';
            }
        }
    }

    public void dfs(char[][] board, int row, int col) {
        if(board[row][col] == 'X' || board[row][col] == '*')
            return;
        if(board[row][col] == 'O') {
            board[row][col] = '*';
        }
        if(row != 0) {
            dfs(board, row - 1, col);
        }
        if(row != board.length - 1) {
            dfs(board, row + 1, col);
        }
        if(col != 0) {
            dfs(board, row, col - 1);
        }
        if(col != board[0].length - 1) {
            dfs(board, row, col + 1);
        }
    }

//    public static void main(String args[]) {
////        char[][] board = { {'X', 'O', 'X', 'O', 'X'},
////                          {'X', 'X', 'X', 'X', 'X'},
////                          {'X', 'O', 'X', 'X', 'X'},
////                          {'X', 'X', 'X', 'X', 'X'} };
////        char[][] board = { {'O'} };
//        char[][] board = { {'O', 'X', 'O'}, {'X', 'O', 'X'}, {'O', 'X', 'O'} };
//        new Solution().solve(board);
//        for(int i = 0; i < board.length; i++) {
//            for(int j = 0; j < board[0].length; j++) {
//                System.out.print(board[i][j]);
//            }
//            System.out.println();
//        }
//    }
}
```