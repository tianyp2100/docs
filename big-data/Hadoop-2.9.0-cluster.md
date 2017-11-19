Hadoop-2.9.0集群安装
================================
### 1.安装参数: ubuntu: 14.04.5; hadoop: 2.9.0; jdk: 1.8.0_121
### 2:下载安装软件包
#### 2.1: hadoop安装包下载地址
```
http://archive.apache.org/dist/hadoop/core/
http://archive.apache.org/dist/hadoop/core/stable2/hadoop-2.9.0.tar.gz
https://dist.apache.org/repos/dist/release/hadoop/common/
http://mirror.bit.edu.cn/apache/hadoop/common/
```
#### 2.2: jdk安装包下载地址
```
http://www.oracle.com/technetwork/java/javase/archive-139210.html
```
#### 2.3: Hadoop 0.18文档
```
http://hadoop.apache.org/docs/r1.0.4/cn/
```
#### 2.4: 这里准备的安装包
```
hadoop-2.9.0.tar.gz
jdk-8u121-linux-x64.tar.gz
```
#### 2.5: Ubuntu14.04.5操作系统安装，[Ubuntu-14.04.5 LTS trusty](https://github.com/loveshareme/docs/blob/master/Ubuntu-14.04.5%20LTS%20trusty.md)
### 3:安装hadoop所有必需依赖软件
#### 3.1: 安装jdk（JavaTM1.5.x+），建议选择Sun公司发行的Java版本，[Jdk1.8.0_121](https://github.com/loveshareme/docs/blob/master/server-software/Jdk1.8.0_121.md)
##### 3.1.1: Java的jdk安装包jdk-8u121-linux-x64.tar.gz解压
```
$ tar zxvf jdk-8u121-linux-x64.tar.gz -C /usr/local
```
##### 3.1.2: Java的环境变量配置 (最后加入)
```
$ vim /etc/profile
#Jdk
export JAVA_HOME=/usr/local/jdk1.8.0_121
export CLASSPATH=$JAVA_HOME/lib:.

export PATH=$PATH:$JAVA_HOME/bin
```
##### 3.1.3: 生效环境变量，注：ubuntu系统每次登录都要生效操作
```
$ source /etc/profile
```
##### 3.1.4: Java版本检查
```
$ java -version
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)
```
