Redis缓存Key-Value数据库安装（cluster模式）
================================
#### 下载
```
https://redis.io/download
wget http://download.redis.io/releases/redis-3.2.9.tar.gz
use: redis-3.2.9.tar.gz
```
#### 1：安装依赖
```
apt-get install tcl
```
#### 2：解压编译安装
```
tar zxvf redis-3.2.9.tar.gz
cd redis-3.2.9
pwd
/home/temp/redis-3.2.9
make && make install
```
#### 3：创建目录和组和用户
```
mkdir -p /redis
groupadd redis
useradd redis -g redis -d /redis/ -s /sbin/nologin

mkdir -p /redis/data
mkdir -p /redis/conf
mkdir -p /redis/log
mkdir -p /redis/pid
mkdir -p /redis/tmp
```
#### 4：配置文件redis.conf，内容见附录1，（暂2nodes）
##### 创建集群目录，创建3个节点，其对应端口7771 7772 7773
##### redis的cluster模式，需要至少3个节点，若集群，至少6个端口，3主3从
```
注：创建各个端口独立的文件夹
-------------------------
mkdir -p /redis/data/7771
mkdir -p /redis/conf/7771
mkdir -p /redis/log/7771
mkdir -p /redis/pid/7771
mkdir -p /redis/tmp/7771
mkdir -p /redis/data/7772
mkdir -p /redis/conf/7772
mkdir -p /redis/log/7772
mkdir -p /redis/pid/7772
mkdir -p /redis/tmp/7772
mkdir -p /redis/data/7773
mkdir -p /redis/conf/7773
mkdir -p /redis/log/7773
mkdir -p /redis/pid/7773
mkdir -p /redis/tmp/7773
vim redis.conf
注：复制附录1内容，到文件下:wq
-------------------------
cp redis.conf  /redis/conf/7771
cp redis.conf  /redis/conf/7772
cp redis.conf  /redis/conf/7773
注：替换7771到7772，在vim命令模式下运行:
vim /redis/conf/7772/redis.conf
vim /redis/conf/7773/redis.conf
-------------------------
:%s/7771/7772/g
:%s/7771/7773/g
-------------------------
chown -R redis.redis /redis/
-------------------------
```
#### 5：启动redis各节点
```
/usr/local/bin/redis-server /redis/conf/7771/redis.conf
/usr/local/bin/redis-server /redis/conf/7772/redis.conf
/usr/local/bin/redis-server /redis/conf/7773/redis.conf
```
#### 6：查看服务
```
注：查看启动进程
------------------
ps -ef | grep redis
root     19995     1  0 14:01 ?        00:00:00 /usr/local/bin/redis-server 192.168.100.151:7771 [cluster]
root     19997     1  0 14:01 ?        00:00:00 /usr/local/bin/redis-server 192.168.100.151:7772 [cluster]
root     20003     1  0 14:01 ?        00:00:00 /usr/local/bin/redis-server 192.168.100.151:7773 [cluster]
注：查看监听端口
------------------
netstat -tnlp | grep redis
tcp        0      0 192.168.100.151:7771    0.0.0.0:*               LISTEN      19995/redis-server 
tcp        0      0 192.168.100.151:7772    0.0.0.0:*               LISTEN      19997/redis-server 
tcp        0      0 192.168.100.151:7773    0.0.0.0:*               LISTEN      20003/redis-server 
tcp        0      0 192.168.100.151:17771   0.0.0.0:*               LISTEN      19995/redis-server 
tcp        0      0 192.168.100.151:17772   0.0.0.0:*               LISTEN      19997/redis-server 
tcp        0      0 192.168.100.151:17773   0.0.0.0:*               LISTEN      20003/redis-server 
------------------
```
#### 7：创建集群
##### 现在，我们已经准备好了搭建集群的Redis节点，然后我们要把这些节点都串连起来搭建集群。
##### 官方提供了一个工具：redis-trib.rb (例：/home/temp/redis-3.2.9/src/redis-trib.rb) ，此脚本是用ruby写的一个程序。
##### 所以，我们得安装ruby运行环境，再用gem这个命令来安装redis第三方接口, gem是ruby的一个工具包. 涉及所有机器都安装或镜像。
##### 7.1：安装ruby环境
```
sudo apt-get install ruby
```
##### 7.2：安装ruby程序和redis的第三方接口
```
sudo gem install redis
```
#### 8：创建redis cluster(redis编译安装目录的src下输入命令创建集群）
```
/home/temp/redis-3.2.9/src/redis-trib.rb create --replicas 0 192.168.1.230:7771 192.168.1.230:7772 192.168.1.230:7773
```
##### 注：#redis-trib.rb的create子命令构建  
##### 注：#--replicas 则指定了为Redis Cluster中的每个Master节点配备几个Slave节点 
##### 注：./redis-trib.rb create --replicas 1 192.168.1.230:7000 192.168.1.230:7771 192.168.1.230:7772 192.168.1.231:7773 192.168.1.231:7004 192.168.1.231:7005
##### 注：-–replicas 1 表示 自动为每一个master节点分配一个slave节点 上面有6个节点，程序会按照一定规则生成 3个master（主）3个slave(从) 
##### 注：-–replicas 0 则无从
##### 注：防火墙一定要开放监听的端口，否则会创建失败
#### 9：测试集群
```
--------------------
注：-c进入集群模式
/usr/local/bin/redis-cli -c -p 7771 -h 192.168.1.230
--------------------
注：查看信息
info
--------------------
注：查看节点信息
cluster nodes
--------------------
注：查看插槽信息
CLUSTER SLOTS
--------------------
-------------------------------------
192.168.1.230:7000> set kk dandan
-> Redirected to slot [5798] located at 192.168.1.231:7773
OK
192.168.1.231:7773> get kk
"dandan"
可见，重定向到了231节点7773端口。 
原因是redis采用hash槽的方式分发key到不同节点，算法是crc(16)%16384。
-------------------------------------
```
### 附件1:配置文件(redis.conf)
```
# 关闭保护模式
protected-mode no
# ip地址
bind 192.168.1.230
# 端口
port 7771
# 守护进程开启,默认服务从后台启动
daemonize yes
# pid文件
pidfile /redis/pid/7771/redis.pid
# 日志级别
loglevel verbose
# 日志文件位置
logfile /redis/log/7771/redis.log
## redis持久化rdb,AOF
# redis持久化文件路径,默认为当前路径
dir /redis/data/7771
# redis持久化文件名称
dbfilename dump.rdb
# 开启AOF
appendonly yes
# AOF文件名称
appendfilename "appendonly.aof"
# 子进程在做rewrite时，主进程不调用fsync（由内核默认调度）
no-appendfsync-on-rewrite yes
## REPLICATION
# 当slave与master断开连接，slave继续提供服务
slave-serve-stale-data yes
slave-read-only yes
# slave ping master的时间间隔，单位为秒
repl-ping-slave-period 1
# 复制超时，单位为秒，须大于repl-ping-slave-period的值
repl-timeout 10
## Redis cluster
# 开启集群配置
cluster-enabled yes
# 节点配置文件，这个文件是服务启动时自己配置创建的
cluster-config-file nodes-7771.conf
# 集群中各节点相互通讯时，允许"失联"的最大毫秒数，如果超过没向其它节点汇报成功，就认为该节点已挂
cluster-node-timeout 5000
# 将该项设置为0，不管slave节点和master节点间失联多久都会一直尝试failover
cluster-slave-validity-factor 0
# slave ping master的时间间隔，单位为秒
repl-ping-slave-period 1

# 其他默认值
tcp-backlog 511
timeout 0
tcp-keepalive 300
supervised no
databases 16
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendfsync everysec
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
# slaveof <masterip> <masterport>
# masterauth <master-password>
# requirepass foobared
```
### 问题记录

##### 错误1：
```
Node 192.168.1.230:7771 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0.
```
##### 解决1：
```
1) 关闭各个节点，将每个节点下aof、rdb、nodes.conf本地备份文件删除；
2) 192.168.1.230:7771> flushdb #清空当前数据库(可省略) 
3) 之后再执行启动各个节点脚本，成功执行
```

##### 错误2：
```
>>> Creating cluster
*** ERROR: Invalid configuration for cluster creation.
*** Redis Cluster requires at least 3 master nodes.
*** This is not possible with 2 nodes and 1 replicas per node.
*** At least 6 nodes are required.
```
##### 解决2：
```
创建3个节点: 7771 7772 7773
```
### 日志记录
##### 集群无从启动日志:
```
/home/temp/redis-3.2.9/src/redis-trib.rb create --replicas 0 192.168.1.230:7771 192.168.1.230:7772 192.168.1.230:7773
>>> Creating cluster
>>> Performing hash slots allocation on 3 nodes...
Using 3 masters:
192.168.1.230:7771
192.168.1.230:7772
192.168.1.230:7773
M: 00be2829b9f0b32930450ab3feb131146db0ad81 192.168.1.230:7771
   slots:0-5460 (5461 slots) master
M: f462c93b21005b9c706c36850916b090bfc1d6a8 192.168.1.230:7772
   slots:5461-10922 (5462 slots) master
M: d789a1e190bb32a84753c1612cd9d677e4aeba02 192.168.1.230:7773
   slots:10923-16383 (5461 slots) master
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join.
>>> Performing Cluster Check (using node 192.168.1.230:7771)
M: 00be2829b9f0b32930450ab3feb131146db0ad81 192.168.1.230:7771
   slots:0-5460 (5461 slots) master
   0 additional replica(s)
M: d789a1e190bb32a84753c1612cd9d677e4aeba02 192.168.1.230:7773
   slots:10923-16383 (5461 slots) master
   0 additional replica(s)
M: f462c93b21005b9c706c36850916b090bfc1d6a8 192.168.1.230:7772
   slots:5461-10922 (5462 slots) master
   0 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
##### 集群启动日志
```
./redis-trib.rb create --replicas 1 192.168.1.230:7000 192.168.1.230:7771 192.168.1.230:7772 192.168.1.231:7773 192.168.1.231:7004 192.168.1.231:7005
>>> Creating cluster
>>> Performing hash slots allocation on 6 nodes...
Using 3 masters:
192.168.1.230:7000
192.168.1.231:7773
192.168.1.230:7771
Adding replica 192.168.1.231:7004 to 192.168.1.230:7000
Adding replica 192.168.1.230:7772 to 192.168.1.231:7773
Adding replica 192.168.1.231:7005 to 192.168.1.230:7771
M: 16518afbfcbd961aeb76ef1592007a3e7fe24b1b 192.168.1.230:7000
   slots:0-5460 (5461 slots) master
M: 524219969118a57ceaac753ecef7585f634cdf26 192.168.1.230:7771
   slots:10923-16383 (5461 slots) master
S: ea4519ff0083a13cef8262490ee9e61e5a4b14b1 192.168.1.230:7772
   replicates 82c0e591b9bc7a289026dff2873a254d1c49d285
M: 82c0e591b9bc7a289026dff2873a254d1c49d285 192.168.1.231:7773
   slots:5461-10922 (5462 slots) master
S: baf74dd89c0605d2a71a8d1d3706005ff668563b 192.168.1.231:7004
   replicates 16518afbfcbd961aeb76ef1592007a3e7fe24b1b
S: f8192314d2232e12ba9f558e9ecbfcc890f4fb73 192.168.1.231:7005
   replicates 524219969118a57ceaac753ecef7585f634cdf26
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join.....
>>> Performing Cluster Check (using node 192.168.1.230:7000)
M: 16518afbfcbd961aeb76ef1592007a3e7fe24b1b 192.168.1.230:7000
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
S: ea4519ff0083a13cef8262490ee9e61e5a4b14b1 192.168.1.230:7772
   slots: (0 slots) slave
   replicates 82c0e591b9bc7a289026dff2873a254d1c49d285
S: f8192314d2232e12ba9f558e9ecbfcc890f4fb73 192.168.1.231:7005
   slots: (0 slots) slave
   replicates 524219969118a57ceaac753ecef7585f634cdf26
S: baf74dd89c0605d2a71a8d1d3706005ff668563b 192.168.1.231:7004
   slots: (0 slots) slave
   replicates 16518afbfcbd961aeb76ef1592007a3e7fe24b1b
M: 524219969118a57ceaac753ecef7585f634cdf26 192.168.1.230:7771
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
M: 82c0e591b9bc7a289026dff2873a254d1c49d285 192.168.1.231:7773
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
