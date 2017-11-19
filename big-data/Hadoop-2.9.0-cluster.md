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
#### 温馨提示：只准备一台机器192.168.1.203（此处虚拟机），以下操作先在203上完成，最后备份主机镜像导入修改ip为集群（此处以下操作都为root用户操作，也可以其他用户hadoop）！
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
### 4. 创建目录、用户、组、密码、所属 (此处三台主机均为)：
```
$ mkdir -p /hadoop/bin
$ mkdir -p /hadoop/tmp
$ mkdir -p /hadoop/dfs/data
$ mkdir -p /hadoop/dfs/name
$ groupadd hadoop
$ useradd hadoop -g hadoop -d /hadoop -s /bin/bash
$ grep hadoop /etc/passwd
$ chown -R hadoop:hadoop /hadoop
$ passwd hadoop
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
#### 7: Hadoop的环境变量配置
```
$ vim /etc/profile

#Jdk
export JAVA_HOME=/usr/local/jdk1.8.0_121
export CLASSPATH=$JAVA_HOME/lib:.
#Hadoop
export HADOOP_HOME=/hadoop/bin/hadoop-2.9.0

export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

$ source /etc/profile
$ chown -R hadoop:hadoop /hadoop
$ hadoop version
Hadoop 2.9.0
Subversion https://git-wip-us.apache.org/repos/asf/hadoop.git -r 756ebc8394e473ac25feac05fa493f6d612e6c50
Compiled by arsuresh on 2017-11-13T23:15Z
Compiled with protoc 2.5.0
From source with checksum 0a76a9a32a5257331741f8d5932f183
This command was run using /hadoop/bin/hadoop-2.9.0/share/hadoop/common/hadoop-common-2.9.0.jar
```
---
#### 温馨提示：此处192.168.1.203（此处虚拟机），配置已全部完成，现在备份主机（192.168.1.203）镜像导入204和205其他两台主机（此处虚拟机：VirtualBox-5.1.30）！
#### 8: 主机备份的镜像导入其他两台从主机（203为主）
##### 8.1: 修改204和205的ip和hostname：192.168.1.204 (hadoop-slave01), 192.168.1.205 (hadoop-slave02)，重启！
##### 8.2: ping双方的ip测试网络连通性(例: 192.168.1.203 (hadoop-master)):
```
$ ping 192.168.1.204
$ ping 192.168.1.205
$ ping hadoop-slave01
$ ping hadoop-slave02
```
##### 8.3: 添加免密码ssh集群用户公钥/授权:
###### 8.3.1: 保证了三台主机电脑ssh都能连接到本地localhost，还需要让master主机免密码登录slave01和slave02主机。在master执行如下命令，将master的id_rsa.pub传送给两台slave主机。
```
$ scp ~/.ssh/id_rsa.pub hadoop@hadoop-slave01:/hadoop/
$ scp ~/.ssh/id_rsa.pub hadoop@hadoop-slave02:/hadoop/
```
###### 8.3.2:接着在hadoop-slave01、hadoop-slave02主机上将hadoop-master的公钥加入各自authorized_keys(用户公钥):
```
$ cat /hadoop/id_rsa.pub >> ~/.ssh/authorized_keys
$ rm /hadoop/id_rsa.pub
```
###### 8.3.3: 集群Master免密码ssh登录Slave测试（hadoop-master上执行）:
```
$ ssh hadoop-slave01
$ ssh hadoop-slave02
```
###### 注: 如果Master主机和Slave主机的用户名不一样，还需要在Master修改~/.ssh/config文件，如果没有此文件，自己创建文件（此处无）。
```
Host hadoop-master
  user hadoop1
Host hadoop-slave01
  user hadoop2
```
#### 9: 格式化分布式文件系统，启动Hadoop集群 (hadoop-master上执行):、
```
$ /hadoop/bin/hadoop-2.9.0/bin/hdfs namenode -format
$ /hadoop/bin/hadoop-2.9.0/sbin/start-all.sh
```
#### 10: 关闭Hadoop集群
```
$ /hadoop/bin/hadoop-2.9.0/sbin/stop-all.sh
```
#### 11: 运行后，测试
##### 11.1: Java进程，在hadoop-master、hadoop-slave01、hadoop-slave02运行jps命令（显示当前所有java进程pid）
```
root@hadoop-master:/home/server# jps
1346 NameNode
1561 SecondaryNameNode
2009 Jps
1738 ResourceManager
root@hadoop-slave01:/home/server# jps
1718 Jps
1435 DataNode
1551 NodeManager
root@hadoop-slave02:/home/server# jps
1651 Jps
1371 DataNode
1487 NodeManager
```
##### 11.2: 端口:
```
root@hadoop-master:/home/server# netstat -tunlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:50070           0.0.0.0:*               LISTEN      1346/java       
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      801/sshd        
tcp        0      0 192.168.1.203:9000      0.0.0.0:*               LISTEN      1346/java       
tcp        0      0 0.0.0.0:50090           0.0.0.0:*               LISTEN      1561/java       
tcp6       0      0 :::22                   :::*                    LISTEN      801/sshd        
tcp6       0      0 192.168.1.203:8088      :::*                    LISTEN      1738/java       
tcp6       0      0 192.168.1.203:8030      :::*                    LISTEN      1738/java       
tcp6       0      0 192.168.1.203:8031      :::*                    LISTEN      1738/java       
tcp6       0      0 192.168.1.203:8032      :::*                    LISTEN      1738/java       
tcp6       0      0 192.168.1.203:8033      :::*                    LISTEN      1738/java  
root@hadoop-slave01:/home/server# netstat -tunlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      823/sshd        
tcp        0      0 0.0.0.0:50010           0.0.0.0:*               LISTEN      1435/java       
tcp        0      0 0.0.0.0:50075           0.0.0.0:*               LISTEN      1435/java       
tcp        0      0 127.0.0.1:36035         0.0.0.0:*               LISTEN      1435/java       
tcp        0      0 0.0.0.0:50020           0.0.0.0:*               LISTEN      1435/java       
tcp6       0      0 :::32979                :::*                    LISTEN      1551/java       
tcp6       0      0 :::22                   :::*                    LISTEN      823/sshd        
tcp6       0      0 :::13562                :::*                    LISTEN      1551/java       
tcp6       0      0 :::8040                 :::*                    LISTEN      1551/java       
tcp6       0      0 :::8042                 :::*                    LISTEN      1551/java  
root@hadoop-slave02:/home/server# netstat -tunlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      791/sshd        
tcp        0      0 0.0.0.0:50010           0.0.0.0:*               LISTEN      1371/java       
tcp        0      0 0.0.0.0:50075           0.0.0.0:*               LISTEN      1371/java       
tcp        0      0 0.0.0.0:50020           0.0.0.0:*               LISTEN      1371/java       
tcp        0      0 127.0.0.1:37261         0.0.0.0:*               LISTEN      1371/java       
tcp6       0      0 :::22                   :::*                    LISTEN      791/sshd        
tcp6       0      0 :::13562                :::*                    LISTEN      1487/java       
tcp6       0      0 :::8040                 :::*                    LISTEN      1487/java       
tcp6       0      0 :::8042                 :::*                    LISTEN      1487/java       
tcp6       0      0 :::41422                :::*                    LISTEN      1487/java  
```
##### 11.3: Web UI访问: 查看 NameNode 和DataNode信息，还可以在线查看HDFS中的文件:
```
http://192.168.1.203:50070
http://192.168.1.204:50075
http://192.168.1.205:50075
http://hadoop-master:50070
http://hadoop-slave01:50075
http://hadoop-slave02:50075
```
注:若windows系统则修改文件: 
```
C:\Windows\System32\drivers\etc\hosts
192.168.1.200       hadoop-master    
192.168.1.201       hadoop-slave01   
192.168.1.202       hadoop-slave02  
```
#### 12: HDFS中的文件简单操作
##### 12.1: 查看HDFS有没有文件或文件夹，第一次查看显示为空
```
$ hadoop fs -ls /
```
##### 12.2: 在HDFS下创建test1文件夹
```
$ hadoop fs -mkdir /test1
$ hadoop fs -ls /
Found 1 items
drwxr-xr-x   - root supergroup          0 2017-11-19 18:45 /test1
```
##### 12.3: 在HDFS下改变test1文件夹的拥有者
```
$ hadoop fs -chown -R hadoop:hadoop /test1
$ hadoop fs -ls /
Found 1 items
drwxr-xr-x   - hadoop hadoop          0 2017-11-19 18:45 /test1
```
##### 12.4: 在HDFS下改变test1文件夹的权限
```
$ hadoop fs -chmod 777 /test1
$ hadoop fs -ls /
Found 1 items
drwxrwxrwx   - hadoop hadoop          0 2017-11-19 18:45 /test1
```
##### 12.5:  在HDFS下向test1文件夹下复制“上传(put)”和“下载(get)”
```
$ touch 11111.txt
$ vim 11111.txt 
$ hadoop fs -put 11111.txt /test1
$ hadoop fs -ls /test1
Found 1 items
-rw-r--r--   3 root hadoop       1421 2017-11-19 19:06 /test1/11111.txt
$ hadoop fs -get /test1/11111.txt /home
$ ls /home/
11111.txt  server
```
##### 12.6: 在web页面的Utilities菜单下Browse the file system查看HDFS中的文件上传和下载。
```
$ hadoop fs -ls /test1
Found 2 items
-rw-r--r--   3 root   hadoop       1421 2017-11-19 19:06 /test1/11111.txt
-rwxr-xr-x   3 dr.who hadoop 1216816138 2017-11-19 19:12 /test1/卑鄙的我3_神偷奶爸.mp4
$ hadoop fs -du -h /test1
1.4 K  /test1/11111.txt
1.1 G  /test1/卑鄙的我3_神偷奶爸.mp4
```
### 附录1：格式化分布式文件系统: $ /hadoop/bin/hadoop-2.9.0/bin/hdfs namenode -format
```
17/11/19 18:27:17 INFO namenode.NameNode: STARTUP_MSG: 
/************************************************************
STARTUP_MSG: Starting NameNode
STARTUP_MSG:   host = hadoop-master/192.168.1.203
STARTUP_MSG:   args = [-format]
STARTUP_MSG:   version = 2.9.0
STARTUP_MSG:   classpath = /hadoop/bin/hadoop-2.9.0/etc/hadoop:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/nimbus-jose-jwt-3.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/zookeeper-3.4.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jersey-json-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/servlet-api-2.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jersey-core-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/paranamer-2.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jersey-server-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/log4j-1.2.17.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-cli-1.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/httpclient-4.5.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/json-smart-1.1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jsch-0.1.54.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/api-asn1-api-1.0.0-M20.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/apacheds-kerberos-codec-2.0.0-M15.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jets3t-0.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/api-util-1.0.0-M20.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jsr305-3.0.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jsp-api-2.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/slf4j-api-1.7.25.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jackson-core-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/hadoop-auth-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/mockito-all-1.8.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/netty-3.6.2.Final.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jackson-xc-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-lang3-3.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-beanutils-1.7.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jcip-annotations-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/hadoop-annotations-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/gson-2.2.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/guava-11.0.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/curator-framework-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-lang-2.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/junit-4.11.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-math3-3.1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jackson-jaxrs-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jettison-1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/curator-client-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/xmlenc-0.52.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/curator-recipes-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/stax-api-1.0-2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/httpcore-4.4.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/xz-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-digester-1.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-logging-1.1.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/avro-1.7.7.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-io-2.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/asm-3.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/java-xmlbuilder-0.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jaxb-impl-2.2.3-1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/htrace-core4-4.1.0-incubating.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-codec-1.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jetty-sslengine-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-net-3.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-configuration-1.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/apacheds-i18n-2.0.0-M15.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jackson-mapper-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/snappy-java-1.0.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jetty-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/stax2-api-3.1.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jaxb-api-2.2.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/jetty-util-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/activation-1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/protobuf-java-2.5.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-beanutils-core-1.8.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-collections-3.2.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/commons-compress-1.4.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/hamcrest-core-1.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/lib/woodstox-core-5.0.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/hadoop-nfs-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/hadoop-common-2.9.0-tests.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/common/hadoop-common-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/servlet-api-2.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jersey-core-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jackson-annotations-2.7.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/okhttp-2.4.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jersey-server-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/log4j-1.2.17.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/commons-cli-1.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/okio-1.4.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/hadoop-hdfs-client-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jsr305-3.0.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jackson-databind-2.7.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jackson-core-2.7.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jackson-core-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/netty-3.6.2.Final.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/leveldbjni-all-1.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/guava-11.0.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/commons-lang-2.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/xmlenc-0.52.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/commons-logging-1.1.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/commons-io-2.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/asm-3.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/xercesImpl-2.9.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/htrace-core4-4.1.0-incubating.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/commons-codec-1.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/commons-daemon-1.0.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/netty-all-4.0.23.Final.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jackson-mapper-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jetty-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/xml-apis-1.3.04.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/jetty-util-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/lib/protobuf-java-2.5.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-native-client-2.9.0-tests.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-2.9.0-tests.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-client-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-nfs-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-client-2.9.0-tests.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/hdfs/hadoop-hdfs-native-client-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/nimbus-jose-jwt-3.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/zookeeper-3.4.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/curator-test-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jersey-json-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/servlet-api-2.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jersey-core-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/paranamer-2.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jersey-server-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/ehcache-3.3.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/log4j-1.2.17.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-cli-1.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/guice-servlet-3.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/java-util-1.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/httpclient-4.5.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/json-smart-1.1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jsch-0.1.54.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/api-asn1-api-1.0.0-M20.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/apacheds-kerberos-codec-2.0.0-M15.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jets3t-0.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/api-util-1.0.0-M20.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jsr305-3.0.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jsp-api-2.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jackson-core-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/fst-2.50.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/mssql-jdbc-6.2.1.jre7.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/netty-3.6.2.Final.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jackson-xc-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/leveldbjni-all-1.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-math-2.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jersey-client-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-lang3-3.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-beanutils-1.7.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/zookeeper-3.4.6-tests.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jcip-annotations-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/gson-2.2.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/guava-11.0.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/curator-framework-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/javassist-3.18.1-GA.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-lang-2.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-math3-3.1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jackson-jaxrs-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jettison-1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/curator-client-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/xmlenc-0.52.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/curator-recipes-2.7.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/stax-api-1.0-2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/httpcore-4.4.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/xz-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-digester-1.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/javax.inject-1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-logging-1.1.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/avro-1.7.7.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/json-io-2.5.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-io-2.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/asm-3.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/metrics-core-3.0.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/java-xmlbuilder-0.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jaxb-impl-2.2.3-1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/geronimo-jcache_1.0_spec-1.0-alpha-1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/htrace-core4-4.1.0-incubating.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-codec-1.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jetty-sslengine-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-net-3.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-configuration-1.6.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/apacheds-i18n-2.0.0-M15.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/HikariCP-java7-2.4.12.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jackson-mapper-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/snappy-java-1.0.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jersey-guice-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jetty-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/aopalliance-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/guice-3.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/stax2-api-3.1.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jaxb-api-2.2.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/jetty-util-6.1.26.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/activation-1.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/protobuf-java-2.5.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-beanutils-core-1.8.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-collections-3.2.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/commons-compress-1.4.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/lib/woodstox-core-5.0.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-applications-unmanaged-am-launcher-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-client-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-resourcemanager-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-common-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-router-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-registry-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-sharedcachemanager-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-applicationhistoryservice-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-applications-distributedshell-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-timeline-pluginstorage-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-api-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-common-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-web-proxy-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-nodemanager-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/yarn/hadoop-yarn-server-tests-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/jersey-core-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/paranamer-2.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/jersey-server-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/log4j-1.2.17.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/guice-servlet-3.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/jackson-core-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/netty-3.6.2.Final.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/leveldbjni-all-1.8.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/hadoop-annotations-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/junit-4.11.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/xz-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/javax.inject-1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/avro-1.7.7.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/commons-io-2.4.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/asm-3.2.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/jackson-mapper-asl-1.9.13.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/snappy-java-1.0.5.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/jersey-guice-1.9.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/aopalliance-1.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/guice-3.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/protobuf-java-2.5.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/commons-compress-1.4.1.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/lib/hamcrest-core-1.3.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-app-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-common-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.9.0-tests.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-hs-plugins-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-shuffle-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-client-hs-2.9.0.jar:/hadoop/bin/hadoop-2.9.0/contrib/capacity-scheduler/*.jar
STARTUP_MSG:   build = https://git-wip-us.apache.org/repos/asf/hadoop.git -r 756ebc8394e473ac25feac05fa493f6d612e6c50; compiled by 'arsuresh' on 2017-11-13T23:15Z
STARTUP_MSG:   java = 1.8.0_121
************************************************************/
17/11/19 18:27:17 INFO namenode.NameNode: registered UNIX signal handlers for [TERM, HUP, INT]
17/11/19 18:27:17 INFO namenode.NameNode: createNameNode [-format]
Formatting using clusterid: CID-30e36383-87f2-48cc-bdfb-34ed5b983ee5
17/11/19 18:27:20 INFO namenode.FSEditLog: Edit logging is async:true
17/11/19 18:27:20 INFO namenode.FSNamesystem: KeyProvider: null
17/11/19 18:27:20 INFO namenode.FSNamesystem: fsLock is fair: true
17/11/19 18:27:20 INFO namenode.FSNamesystem: Detailed lock hold time metrics enabled: false
17/11/19 18:27:20 INFO namenode.FSNamesystem: fsOwner             = root (auth:SIMPLE)
17/11/19 18:27:20 INFO namenode.FSNamesystem: supergroup          = supergroup
17/11/19 18:27:20 INFO namenode.FSNamesystem: isPermissionEnabled = true
17/11/19 18:27:20 INFO namenode.FSNamesystem: HA Enabled: false
17/11/19 18:27:20 INFO common.Util: dfs.datanode.fileio.profiling.sampling.percentage set to 0. Disabling file IO profiling
17/11/19 18:27:21 INFO blockmanagement.DatanodeManager: dfs.block.invalidate.limit: configured=1000, counted=60, effected=1000
17/11/19 18:27:21 INFO blockmanagement.DatanodeManager: dfs.namenode.datanode.registration.ip-hostname-check=true
17/11/19 18:27:21 INFO blockmanagement.BlockManager: dfs.namenode.startup.delay.block.deletion.sec is set to 000:00:00:00.000
17/11/19 18:27:21 INFO blockmanagement.BlockManager: The block deletion will start around 2017 Nov 19 18:27:21
17/11/19 18:27:21 INFO util.GSet: Computing capacity for map BlocksMap
17/11/19 18:27:21 INFO util.GSet: VM type       = 64-bit
17/11/19 18:27:21 INFO util.GSet: 2.0% max memory 966.7 MB = 19.3 MB
17/11/19 18:27:21 INFO util.GSet: capacity      = 2^21 = 2097152 entries
17/11/19 18:27:21 INFO blockmanagement.BlockManager: dfs.block.access.token.enable=false
17/11/19 18:27:21 WARN conf.Configuration: No unit for dfs.namenode.safemode.extension(30000) assuming MILLISECONDS
17/11/19 18:27:21 INFO blockmanagement.BlockManagerSafeMode: dfs.namenode.safemode.threshold-pct = 0.9990000128746033
17/11/19 18:27:21 INFO blockmanagement.BlockManagerSafeMode: dfs.namenode.safemode.min.datanodes = 0
17/11/19 18:27:21 INFO blockmanagement.BlockManagerSafeMode: dfs.namenode.safemode.extension = 30000
17/11/19 18:27:21 INFO blockmanagement.BlockManager: defaultReplication         = 3
17/11/19 18:27:21 INFO blockmanagement.BlockManager: maxReplication             = 512
17/11/19 18:27:21 INFO blockmanagement.BlockManager: minReplication             = 1
17/11/19 18:27:21 INFO blockmanagement.BlockManager: maxReplicationStreams      = 2
17/11/19 18:27:21 INFO blockmanagement.BlockManager: replicationRecheckInterval = 3000
17/11/19 18:27:21 INFO blockmanagement.BlockManager: encryptDataTransfer        = false
17/11/19 18:27:21 INFO blockmanagement.BlockManager: maxNumBlocksToLog          = 1000
17/11/19 18:27:21 INFO namenode.FSNamesystem: Append Enabled: true
17/11/19 18:27:22 INFO util.GSet: Computing capacity for map INodeMap
17/11/19 18:27:22 INFO util.GSet: VM type       = 64-bit
17/11/19 18:27:22 INFO util.GSet: 1.0% max memory 966.7 MB = 9.7 MB
17/11/19 18:27:22 INFO util.GSet: capacity      = 2^20 = 1048576 entries
17/11/19 18:27:22 INFO namenode.FSDirectory: ACLs enabled? false
17/11/19 18:27:22 INFO namenode.FSDirectory: XAttrs enabled? true
17/11/19 18:27:22 INFO namenode.NameNode: Caching file names occurring more than 10 times
17/11/19 18:27:22 INFO snapshot.SnapshotManager: Loaded config captureOpenFiles: falseskipCaptureAccessTimeOnlyChange: false
17/11/19 18:27:22 INFO util.GSet: Computing capacity for map cachedBlocks
17/11/19 18:27:22 INFO util.GSet: VM type       = 64-bit
17/11/19 18:27:22 INFO util.GSet: 0.25% max memory 966.7 MB = 2.4 MB
17/11/19 18:27:22 INFO util.GSet: capacity      = 2^18 = 262144 entries
17/11/19 18:27:22 INFO metrics.TopMetrics: NNTop conf: dfs.namenode.top.window.num.buckets = 10
17/11/19 18:27:22 INFO metrics.TopMetrics: NNTop conf: dfs.namenode.top.num.users = 10
17/11/19 18:27:22 INFO metrics.TopMetrics: NNTop conf: dfs.namenode.top.windows.minutes = 1,5,25
17/11/19 18:27:22 INFO namenode.FSNamesystem: Retry cache on namenode is enabled
17/11/19 18:27:22 INFO namenode.FSNamesystem: Retry cache will use 0.03 of total heap and retry cache entry expiry time is 600000 millis
17/11/19 18:27:22 INFO util.GSet: Computing capacity for map NameNodeRetryCache
17/11/19 18:27:22 INFO util.GSet: VM type       = 64-bit
17/11/19 18:27:22 INFO util.GSet: 0.029999999329447746% max memory 966.7 MB = 297.0 KB
17/11/19 18:27:22 INFO util.GSet: capacity      = 2^15 = 32768 entries
17/11/19 18:27:22 INFO namenode.FSImage: Allocated new BlockPoolId: BP-665037173-192.168.1.203-1511087242885
17/11/19 18:27:23 INFO common.Storage: Storage directory /hadoop/dfs/name has been successfully formatted.
17/11/19 18:27:23 INFO namenode.FSImageFormatProtobuf: Saving image file /hadoop/dfs/name/current/fsimage.ckpt_0000000000000000000 using no compression
17/11/19 18:27:23 INFO namenode.FSImageFormatProtobuf: Image file /hadoop/dfs/name/current/fsimage.ckpt_0000000000000000000 of size 321 bytes saved in 0 seconds.
17/11/19 18:27:23 INFO namenode.NNStorageRetentionManager: Going to retain 1 images with txid >= 0
17/11/19 18:27:23 INFO namenode.NameNode: SHUTDOWN_MSG: 
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at hadoop-master/192.168.1.203
************************************************************/
```
### 附录2：启动Hadoop集群: $ /hadoop/bin/hadoop-2.9.0/sbin/start-all.sh
```
This script is Deprecated. Instead use start-dfs.sh and start-yarn.sh
Starting namenodes on [hadoop-master]
The authenticity of host 'hadoop-master (192.168.1.203)' can't be established.
ECDSA key fingerprint is 1b:49:c4:67:c0:74:d4:aa:af:d4:54:ba:26:bc:2a:bd.
Are you sure you want to continue connecting (yes/no)? yes
hadoop-master: Warning: Permanently added 'hadoop-master,192.168.1.203' (ECDSA) to the list of known hosts.
hadoop-master: starting namenode, logging to /hadoop/bin/hadoop-2.9.0/logs/hadoop-root-namenode-hadoop-master.out
hadoop-slave01: starting datanode, logging to /hadoop/bin/hadoop-2.9.0/logs/hadoop-root-datanode-hadoop-slave01.out
hadoop-slave02: starting datanode, logging to /hadoop/bin/hadoop-2.9.0/logs/hadoop-root-datanode-hadoop-slave02.out
Starting secondary namenodes [0.0.0.0]
The authenticity of host '0.0.0.0 (0.0.0.0)' can't be established.
ECDSA key fingerprint is 1b:49:c4:67:c0:74:d4:aa:af:d4:54:ba:26:bc:2a:bd.
Are you sure you want to continue connecting (yes/no)? yes
0.0.0.0: Warning: Permanently added '0.0.0.0' (ECDSA) to the list of known hosts.
0.0.0.0: starting secondarynamenode, logging to /hadoop/bin/hadoop-2.9.0/logs/hadoop-root-secondarynamenode-hadoop-master.out
starting yarn daemons
starting resourcemanager, logging to /hadoop/bin/hadoop-2.9.0/logs/yarn-root-resourcemanager-hadoop-master.out
hadoop-slave01: starting nodemanager, logging to /hadoop/bin/hadoop-2.9.0/logs/yarn-root-nodemanager-hadoop-slave01.out
hadoop-slave02: starting nodemanager, logging to /hadoop/bin/hadoop-2.9.0/logs/yarn-root-nodemanager-hadoop-slave02.out
```
### 附录3：关闭Hadoop集群: $ /hadoop/bin/hadoop-2.9.0/sbin/stop-all.sh
```
This script is Deprecated. Instead use stop-dfs.sh and stop-yarn.sh
Stopping namenodes on [hadoop-master]
hadoop-master: stopping namenode
hadoop-slave01: stopping datanode
hadoop-slave02: stopping datanode
Stopping secondary namenodes [0.0.0.0]
0.0.0.0: stopping secondarynamenode
stopping yarn daemons
stopping resourcemanager
hadoop-slave02: stopping nodemanager
hadoop-slave01: stopping nodemanager
hadoop-slave02: nodemanager did not stop gracefully after 5 seconds: killing with kill -9
hadoop-slave01: nodemanager did not stop gracefully after 5 seconds: killing with kill -9
no proxyserver to stop
```
### 附录4：Web文件上传日志: $ tail -f /hadoop/bin/hadoop-2.9.0/logs/hadoop-root-namenode-hadoop-master.log
```
2017-11-19 19:06:13,169 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741825_1001, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/11111.txt._COPYING_
2017-11-19 19:06:14,076 INFO org.apache.hadoop.hdfs.server.namenode.FSNamesystem: BLOCK* blk_1073741825_1001 is COMMITTED but not COMPLETE(numNodes= 0 <  minimum = 1) in file /test1/11111.txt._COPYING_
2017-11-19 19:06:14,487 INFO org.apache.hadoop.hdfs.StateChange: DIR* completeFile: /test1/11111.txt._COPYING_ is closed by DFSClient_NONMAPREDUCE_-1894088392_1
2017-11-19 19:10:30,011 INFO org.apache.hadoop.hdfs.server.namenode.FSEditLog: Number of transactions: 11 Total time for transactions(ms): 71 Number of transactions batched in Syncs: 1 Number of syncs: 10 SyncTimes(ms): 147 
2017-11-19 19:10:30,158 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741826_1002, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:10:46,787 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741827_1003, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:11:00,641 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741828_1004, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:11:13,782 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741829_1005, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:11:27,341 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741830_1006, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:11:40,664 INFO org.apache.hadoop.hdfs.server.namenode.FSEditLog: Number of transactions: 27 Total time for transactions(ms): 73 Number of transactions batched in Syncs: 8 Number of syncs: 19 SyncTimes(ms): 283 
2017-11-19 19:11:40,666 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741831_1007, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:11:56,154 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741832_1008, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:12:11,636 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741833_1009, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:12:25,754 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741834_1010, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:12:40,719 INFO org.apache.hadoop.hdfs.server.namenode.FSEditLog: Number of transactions: 39 Total time for transactions(ms): 74 Number of transactions batched in Syncs: 12 Number of syncs: 27 SyncTimes(ms): 422 
2017-11-19 19:12:40,722 INFO org.apache.hadoop.hdfs.StateChange: BLOCK* allocate blk_1073741835_1011, replicas=192.168.1.205:50010, 192.168.1.204:50010 for /test1/卑鄙的我3_神偷奶爸.mp4
2017-11-19 19:12:41,380 INFO org.apache.hadoop.hdfs.StateChange: DIR* completeFile: /test1/卑鄙的我3_神偷奶爸.mp4 is closed by DFSClient_NONMAPREDUCE_-934323569_29
```
### 附录4：帮助文档5: $ hadoop --help
```
Usage: hadoop [--config confdir] [COMMAND | CLASSNAME]
  CLASSNAME            run the class named CLASSNAME
 or
  where COMMAND is one of:
  fs                   run a generic filesystem user client
  version              print the version
  jar <jar>            run a jar file
                       note: please use "yarn jar" to launch
                             YARN applications, not this command.
  checknative [-a|-h]  check native hadoop and compression libraries availability
  distcp <srcurl> <desturl> copy file or directories recursively
  archive -archiveName NAME -p <parent path> <src>* <dest> create a hadoop archive
  classpath            prints the class path needed to get the
                       Hadoop jar and the required libraries
  credential           interact with credential providers
  daemonlog            get/set the log level for each daemon
  trace                view and modify Hadoop tracing settings

Most commands print help when invoked w/o parameters.
```
### 附录5：帮助文档2: $ hadoop fs --help
```
--help: Unknown command
Usage: hadoop fs [generic options]
	[-appendToFile <localsrc> ... <dst>]
	[-cat [-ignoreCrc] <src> ...]
	[-checksum <src> ...]
	[-chgrp [-R] GROUP PATH...]
	[-chmod [-R] <MODE[,MODE]... | OCTALMODE> PATH...]
	[-chown [-R] [OWNER][:[GROUP]] PATH...]
	[-copyFromLocal [-f] [-p] [-l] [-d] <localsrc> ... <dst>]
	[-copyToLocal [-f] [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
	[-count [-q] [-h] [-v] [-t [<storage type>]] [-u] [-x] <path> ...]
	[-cp [-f] [-p | -p[topax]] [-d] <src> ... <dst>]
	[-createSnapshot <snapshotDir> [<snapshotName>]]
	[-deleteSnapshot <snapshotDir> <snapshotName>]
	[-df [-h] [<path> ...]]
	[-du [-s] [-h] [-x] <path> ...]
	[-expunge]
	[-find <path> ... <expression> ...]
	[-get [-f] [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
	[-getfacl [-R] <path>]
	[-getfattr [-R] {-n name | -d} [-e en] <path>]
	[-getmerge [-nl] [-skip-empty-file] <src> <localdst>]
	[-help [cmd ...]]
	[-ls [-C] [-d] [-h] [-q] [-R] [-t] [-S] [-r] [-u] [<path> ...]]
	[-mkdir [-p] <path> ...]
	[-moveFromLocal <localsrc> ... <dst>]
	[-moveToLocal <src> <localdst>]
	[-mv <src> ... <dst>]
	[-put [-f] [-p] [-l] [-d] <localsrc> ... <dst>]
	[-renameSnapshot <snapshotDir> <oldName> <newName>]
	[-rm [-f] [-r|-R] [-skipTrash] [-safely] <src> ...]
	[-rmdir [--ignore-fail-on-non-empty] <dir> ...]
	[-setfacl [-R] [{-b|-k} {-m|-x <acl_spec>} <path>]|[--set <acl_spec> <path>]]
	[-setfattr {-n name [-v value] | -x name} <path>]
	[-setrep [-R] [-w] <rep> <path> ...]
	[-stat [format] <path> ...]
	[-tail [-f] <file>]
	[-test -[defsz] <path>]
	[-text [-ignoreCrc] <src> ...]
	[-touchz <path> ...]
	[-truncate [-w] <length> <path> ...]
	[-usage [cmd ...]]

Generic options supported are:
-conf <configuration file>        specify an application configuration file
-D <property=value>               define a value for a given property
-fs <file:///|hdfs://namenode:port> specify default filesystem URL to use, overrides 'fs.defaultFS' property from configurations.
-jt <local|resourcemanager:port>  specify a ResourceManager
-files <file1,...>                specify a comma-separated list of files to be copied to the map reduce cluster
-libjars <jar1,...>               specify a comma-separated list of jar files to be included in the classpath
-archives <archive1,...>          specify a comma-separated list of archives to be unarchived on the compute machines

The general command line syntax is:
command [genericOptions] [commandOptions]
```
