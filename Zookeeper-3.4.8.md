DUBBO分布式RPC SOA服务框架注册中心zookeeper-3.4.8.tar.gz的安装
======================================================
#### 安装jdk和下载
```
参考:JDK.md
http://www.apache.org/dist/zookeeper/
```
#### 1:解压移动
```
tar zxvf zookeeper-3.4.8.tar.gz
```
#### 2:移动到部署目录
```
cp -R zookeeper-3.4.8 /usr/local
```
#### 3:修改配置
```
cd /usr/local/zookeeper-3.4.8/conf
mv zoo_sample.cfg zoo.cfg
```
#### 4: 创建data和log文件
```
mkdir -p /home/zookeeper/data
mkdir -p /home/zookeeper/log
```
#### 5:用户和组和所属
```
groupadd zookeeper
useradd zookeeper -g zookeeper -d /home/zookeeper/ -s /bin/sh
chown -R zookeeper.zookeeper /home/zookeeper/data
chown -R zookeeper.zookeeper /home/zookeeper/log
```
#### 6:配置文件(`附录1)
#### 7:启动zookeeper
```
/usr/local/zookeeper-3.4.8/bin/zkServer.sh start
```
#### 8.检查启动
```
netstat -tunlp
查看2181端口启动就ok!
或
/usr/local/zookeeper-3.4.8/bin/zkCli.sh
[zk: localhost:2181(CONNECTED) 0] ls /
[]
```
#### 附录1(zoo.cfg):
```
# The number of milliseconds of each tick
# Zookeeper服务器心跳时间，单位毫秒
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
# 投票选举新leader的初始化时间
#zookeeper集群中的包含多台server, 其中一台为leader, 集群中其余的server为follower. initLimit参数配置初始化连接时, follower和leader之间的最长心跳时间. 此时该参数设置为5, 说明时间限制为5倍tickTime, 即5*2000=10000ms=10s.
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
# Leader与Follower之间的最大响应时间单位，响应超过syncLimit*tickTime，Leader认为Follwer死掉，从服务器列表中删除Follwer
#syncLimit: 该参数配置leader和follower之间发送消息, 请求和应答的最大时间长度. 此时该参数设置为2, 说明时间限制为2倍tickTime, 即4000ms.
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
#dataDir=/tmp/zookeeper
# 数据持久化路径
dataDir=/home/zookeeper/data
#日志保存路径
dataLogDir=/home/zookeeper/log
# the port at which the clients will connect
# 连接端口
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
```