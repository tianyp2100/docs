Hadoop-2.9.0集群安装
================================
### 1.安装说明
#### 1.1: 安装参数: ubuntu: 14.04.5; hadoop: 2.9.0; jdk: 1.8.0_121
#### 1.2: 配置集群机器：三台主机（或虚拟机）搭建分布式集群环境(Ubuntu-14.04.5)(同一局域网)(可先准备一台):
|ip|hostname|comment
|---|---|---
|192.168.1.203| hadoop-master| Master
|192.168.1.204| hadoop-slave01| Slave 01    
|192.168.1.205| hadoop-slave02| Slave 02  
#### 1.3. 查看ip: 
```
$ ifconfig
```
###### 注：inet addr:192.168.1.203
#### 1.4. 配置ip:
```
$ vim /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address 192.168.1.203
netmask 255.255.255.0
gateway 192.168.1.1
```
```
$ vim /etc/resolvconf/resolv.conf.d/base
nameserver 192.168.1.1
nameserver 8.8.8.8
```
```
/etc/init.d/networking restart
```
#### 1.5. 查看主机名称:
```
$ hostname
```
#### 1.6. 修改主机名称:
```
$ vim /etc/hostname
hadoop-master
$ reboot
```
###### 注：主机名称，为一个自定义字符串,此处为: hadoop-master。重启生效。
#### 1.7. 配置ip地址和对应主机名(三台主机添加同样的配置):
```
$ vim /etc/hosts
127.0.0.1 localhost
192.168.1.203 hadoop-master
192.168.1.204 hadoop-slave01
192.168.1.205 hadoop-slave02
```
---
#### 温馨提示：只准备一台机器192.168.1.203（此处虚拟机），以下操作先在203上完成，最后备份主机镜像导入修改ip为集群！
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
#### 3.2: 安装ssh、rsync、openssh-server
```
$ sudo apt-get install ssh 
$ sudo apt-get install rsync
$ sudo apt-get install openssh-server
```
```
$ dpkg -l |grep ssh
ii  openssh-client                     1:6.6p1-2ubuntu2.8                         amd64        secure shell (SSH) client, for secure access to remote machines
ii  openssh-server                     1:6.6p1-2ubuntu2.8                         amd64        secure shell (SSH) server, for secure access from remote machines
ii  openssh-sftp-server                1:6.6p1-2ubuntu2.8                         amd64        secure shell (SSH) sftp server module, for SFTP access from remote machines
ii  ssh                                1:6.6p1-2ubuntu2.8                         all          secure shell client and server (metapackage)
ii  ssh-import-id                      3.21-0ubuntu1                              all          securely retrieve an SSH public key and install it locally
$ dpkg -l |grep rsync
ii  rsync                              3.1.0-2ubuntu0.2                           amd64        fast, versatile, remote (and local) file-copying tool
```
###### 注：ssh目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。必须安装并且保证sshd一直运行，以便用Hadoop脚本管理远端Hadoop守护进程。
###### 注：rsync是类unix系统下的数据镜像备份工具。使用快速增量备份（第一次同步时rsync会复制全部内容，但在下一次只传输修改过的文件。）工具Remote Sync可以远程同步，支持本地复制，或者与其他SSH、rsync主机同步。rsync可以镜像保存整个目录树和文件系统。可以很容易做到保持原来文件的权限、时间、软硬链接等等。rsync 在传输数据的过程中可以实行压缩及解压缩操作，因此可以使用更少的带宽。可以使用scp、ssh等方式来传输文件，当然也可以通过直接的socket连接。支持匿名传输，以方便进行网站镜象。
###### 注：openssh-server生成ssh密钥（私钥、公钥）
### 4. 创建目录、用户、组、密码、所属：
```
$ mkdir -p /hadoop/bin
$ mkdir -p /hadoop/tmp
$ mkdir -p /hadoop/dfs/data
$ mkdir -p /hadoop/dfs/name
$ groupadd hadoop
$ useradd hadoop -g hadoop -d /hadoop -s /bin/bash
$ grep hadoop /etc/passwd
$ passwd hadoop
$ chown -R hadoop:hadoop /hadoop
```
###### 注：查看用户的根目录: $ ls ~
#### 5: 免密码ssh设置
##### 5.1: 生成密钥和添加免密码ssh集群用户公钥/授权，配置ssh无密码登录本机和访问集群机器(注:~ = $HOME):
```
$ ssh-keygen -t dsa -P '' -f ~/.ssh/id_rsa 
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```
##### 5.2: 检查：确认能否不输入口令就用ssh登录localhost:
```
$ ssh localhost
```
###### 注: 第一次"Are you sure you want to continue connecting (yes/no)? "，yes就好，进入后可用: $ exit 退出。 
#### 6: 安装hadoop
```
$ tar zxvf hadoop-2.9.0.tar.gz -C /hadoop/bin/
```
#### 6: 修改Hadoop配置文件
##### 注：Hadoop配置文件都位于此目录下：/hadoop/bin/hadoop-2.9.0/etc/hadoop/
##### 6.1: 修改JAVA_HOME：设置为Java安装根路径（hadoop/yarn）:
###### 6.1.1: 修改配置文件:hadoop-env.sh
```
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/hadoop-env.sh
```
###### 注：hadoop-env.sh文件“# The java implementation to use.”后加入: 
```
export JAVA_HOME=/usr/local/jdk1.8.0_121
```
###### 6.1.1: 修改配置文件:yarn-env.sh
```
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/yarn-env.sh
```
###### 注：yarn-env.sh文件“# some Java parameters.”后加入: 
```
export JAVA_HOME=/usr/local/jdk1.8.0_121
```
##### 6.2: 修改slaves
###### 注：把DataNode的主机名写入该文件，每行一个。这里让hadoop-master节点主机仅作为NameNode使用。
```
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/slaves 
hadoop-slave01
hadoop-slave02
```
##### 6.3: 修改core-site.xml
```
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/core-site.xml
<configuration>
  <property>
	  <name>hadoop.tmp.dir</name>
	  <value>file:/hadoop/tmp</value>
	  <description>Abase for other temporary directories.</description>
  </property>
  <property>
	  <name>fs.defaultFS</name>
	  <value>hdfs://hadoop-master:9000</value>
  </property>
</configuration>
```
##### 6.4: 修改hdfs-site.xml
```
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/hdfs-site.xml
<configuration>
	<property>
		<name>dfs.replication</name>
		<value>3</value>
	</property>
	<property>  
		<name>dfs.namenode.name.dir</name>  
		<value>file:/hadoop/dfs/name</value>  
	</property>  
	<property>  
		<name>dfs.datanode.data.dir</name>  
		<value>file:/hadoop/dfs/data</value>  
	</property>  
</configuration>
```
##### 6.5: 修改mapred-site.xml
```
$ cp /hadoop/bin/hadoop-2.9.0/etc/hadoop/mapred-site.xml.template /hadoop/bin/hadoop-2.9.0/etc/hadoop/mapred-site.xml
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/mapred-site.xml
<configuration>
<property>
	<name>mapreduce.framework.name</name>
	<value>yarn</value>
</property>
</configuration>
```
##### 6.6: 修改yarn-site.xml文件:
```
$ vim /hadoop/bin/hadoop-2.9.0/etc/hadoop/yarn-site.xml 
<configuration>
<!-- Site specific YARN configuration properties -->
  <property>
	  <name>yarn.nodemanager.aux-services</name>
	  <value>mapreduce_shuffle</value>
  </property>
  <property>
	  <name>yarn.resourcemanager.hostname</name>
	  <value>hadoop-master</value>
  </property>
</configuration>
```
---
#### 温馨提示：此处192.168.1.203（此处虚拟机），配置已全部完成，现在备份主机（192.168.1.203）镜像导入204和205其他两台主机（此处虚拟机：VirtualBox-5.1.30）！




