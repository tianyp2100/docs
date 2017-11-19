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
#### 3.2: 安装ssh
```
$ sudo apt-get install ssh 
```
###### 注：ssh目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。必须安装并且保证sshd一直运行，以便用Hadoop脚本管理远端Hadoop守护进程。
#### 3.3: 安装rsync
```
$ sudo apt-get install rsync
```
###### 注：rsync是类unix系统下的数据镜像备份工具。使用快速增量备份（第一次同步时rsync会复制全部内容，但在下一次只传输修改过的文件。）工具Remote Sync可以远程同步，支持本地复制，或者与其他SSH、rsync主机同步。rsync可以镜像保存整个目录树和文件系统。可以很容易做到保持原来文件的权限、时间、软硬链接等等。rsync 在传输数据的过程中可以实行压缩及解压缩操作，因此可以使用更少的带宽。可以使用scp、ssh等方式来传输文件，当然也可以通过直接的socket连接。支持匿名传输，以方便进行网站镜象。
#### 3.3: 安装openssh-server
```
$ sudo apt-get install openssh-server
```
###### 注：生成ssh公钥
