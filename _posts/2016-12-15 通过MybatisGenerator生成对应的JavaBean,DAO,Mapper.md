---
layout: post
title:  "通过MybatisGenerator生成对应的JavaBean,DAO,Mapper"
date:   2016-12-15 22:22:23
categories: mysql
permalink: /archivers/mybatis_generator
---
# Mybatis 通过MybatisGenerator生成对应的JavaBean，DAO，Mapper
----
----

## 问题背景
----
  这两天在重新做个项目，因为要用Mybatis，但是写JavaBean，Mapper什么的，挺麻烦的，就找了MybatisGenerator来生成。

## 步骤方法
----

### 准备

![准备](/img/MybaitsGenerator.png)

  * generatorConfig.xml MybatisGenerator配置文件

  {% highlight xml %}

  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE generatorConfiguration
    PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
    "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
  <generatorConfiguration>
      <!--数据库驱动-->
      <classPathEntry    location="mysql-connector-java-5.1.37.jar"/>
      <context id="DB2Tables"    targetRuntime="MyBatis3">
          <commentGenerator>
              <property name="suppressDate" value="true"/>
              <property name="suppressAllComments" value="true"/>
          </commentGenerator>
          <!--数据库链接地址账号密码-->
          <jdbcConnection driverClass="com.mysql.jdbc.Driver" connectionURL="jdbc:mysql://localhost/aote" userId="root" password="root">
          </jdbcConnection>
          <javaTypeResolver>
              <property name="forceBigDecimals" value="false"/>
          </javaTypeResolver>
          <!--生成Model类存放位置-->
          <javaModelGenerator targetPackage="cn.edianzu.aote.entity" targetProject="src">
              <property name="enableSubPackages" value="true"/>
              <property name="trimStrings" value="true"/>
          </javaModelGenerator>
          <!--生成映射文件存放位置-->
          <sqlMapGenerator targetPackage="cn.edianzu.aote.mapper" targetProject="src">
              <property name="enableSubPackages" value="true"/>
          </sqlMapGenerator>
          <!--生成Dao类存放位置-->
          <javaClientGenerator type="XMLMAPPER" targetPackage="cn.edianzu.aote.dao" targetProject="src">
              <property name="enableSubPackages" value="true"/>
          </javaClientGenerator>
          <!--生成对应表及类名-->
          <table tableName="auth_user" domainObjectName="AuthUser" enableCountByExample="false" enableUpdateByExample="false" enableDeleteByExample="false" enableSelectByExample="false" selectByExampleQueryId="false"></table>
      </context>
  </generatorConfiguration>

  {% endhighlight %}

  * mybatis-generator-core-1.3.5.jar MybatisGenerator核心包，下载地址https://github.com/mybatis/generator/releases。

  * mysql-connector-java-5.1.37.jar Mysql驱动包，在配置文件中要写明该包的路径。

生成语句 java -jar mybatis-generator-core-1.3.2.jar -configfile generatorConfig.xml -overwrite
