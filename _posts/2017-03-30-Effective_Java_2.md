---
layout: post
title:  "Effective Java 2 遇到多个构造器参数的时候考虑使用构建器(Builder)"
date:   2017-03-30 07:22:23
categories: effective_java
permalink: /archivers/effective_java_2
---
# Effective Java 2 遇到多个构造器参数的时候考虑使用构建器(Builder)
----
----
## 当遇到构造器有很多参数的时候，该如何做呢？一种方法是重叠构造器(telescoping constructor)，如下代码：

{% highlight java %}
package com.cszjo.test;

public class NutritionFacts {

    private final int servingSize;    //required 必须
    private final int servings;       //required 必须
    private final int calories;       //optional 可选
    private final int fat;            //optional 可选
    private final int sodium;         //optional 可选
    private final int carbohydrate;   //optional 可选

    public NutritionFacts(int servingSize, int servings) {
        this(servingSize, servings, 0);
    }

    public NutritionFacts(int servingSize, int servings, int calories) {
        this(servingSize, servings, calories, 0, 0, 0);
    }

    public NutritionFacts(int servingSize, int servings, int calories, int fat, int sodium, int carbohydrate) {
        this.servingSize = servingSize;
        this.servings = servings;
        this.calories = calories;
        this.fat = fat;
        this.sodium = sodium;
        this.carbohydrate = carbohydrate;
    }
}
{% endhighlight %}

## 在客户端实例化的时候可以

{% highlight java %}
NutritionFacts facts = new NutritionFacts(0, 0, 0, 0, 0, 0);
{% endhighlight %}

## 不足：但是当参数过多的时候，客户端编写代码就很困难，而且并不知道填写的每个参数分别是什么意思。

---------------------

## 例外的一种方式就是JavaBean模式

{% highlight java %}
package com.cszjo.test;

public class NutritionFacts {

    private int servingSize;    //required 必须
    private int servings;       //required 必须
    private int calories;       //optional 可选
    private int fat;            //optional 可选
    private int sodium;         //optional 可选
    private int carbohydrate;   //optional 可选

    public int getServingSize() {
        return servingSize;
    }

    public void setServingSize(int servingSize) {
        this.servingSize = servingSize;
    }

    public int getServings() {
        return servings;
    }

    public void setServings(int servings) {
        this.servings = servings;
    }

    public int getCalories() {
        return calories;
    }

    public void setCalories(int calories) {
        this.calories = calories;
    }

    public int getFat() {
        return fat;
    }

    public void setFat(int fat) {
        this.fat = fat;
    }

    public int getSodium() {
        return sodium;
    }

    public void setSodium(int sodium) {
        this.sodium = sodium;
    }

    public int getCarbohydrate() {
        return carbohydrate;
    }

    public void setCarbohydrate(int carbohydrate) {
        this.carbohydrate = carbohydrate;
    }
}
{% endhighlight %}

## 不足：该方法可能会处于不一致性的状态，因为各个参数都不能设置为final。

----------------------

## 第三个方法是构建器(builder)方法：
{% highlight java %}
package com.cszjo.test;

public class NutritionFacts {

    private final int servingSize;    //required 必须
    private final int servings;       //required 必须
    private final int calories;       //optional 可选
    private final int fat;            //optional 可选
    private final int sodium;         //optional 可选
    private final int carbohydrate;   //optional 可选

    public static class Builder {

        private final int servingSize;    //required 必须
        private final int servings;       //required 必须
        private int calories      = 0;    //optional 可选
        private int fat           = 0;    //optional 可选
        private int sodium        = 0;    //optional 可选
        private int carbohydrate  = 0;    //optional 可选

        public Builder(int servingSize, int servings) {
            this.servingSize = servingSize;
            this.servings = servings;
        }

        public Builder calories(int calories) {
            this.calories = calories;
            return this;
        }

        public Builder fat(int fat) {
            this.fat = fat;
            return this;
        }

        public Builder sodium(int sodium) {
            this.sodium = sodium;
            return this;
        }

        public Builder carbohydrate(int carbohydrate) {
            this.carbohydrate = carbohydrate;
            return this;
        }

        public NutritionFacts build() {
            return new NutritionFacts(this);
        }
    }

    public NutritionFacts(Builder builder) {
        this.servingSize = builder.servingSize;
        this.servings = builder.servings;
        this.calories = builder.calories;
        this.fat = builder.fat;
        this.sodium = builder.sodium;
        this.carbohydrate = builder.carbohydrate;
    }
}
{% endhighlight %}  

## 客户端调用方法

{% highlight java %}
NutritionFacts nutritionFacts = new NutritionFacts.Builder(1, 2).fat(1).build();
{% endhighlight %}

-------------------------------------------------

# 如果类的构造器或者静态工厂中具有多个参数，设计这种类时，Builder模式就是种不错的选择。
