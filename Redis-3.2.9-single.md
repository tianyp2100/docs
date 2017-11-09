Redis缓存Key-Value数据库安装（单机模式）
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

mkdir -p /redis/bin
mkdir -p /redis/data
mkdir -p /redis/pid
mkdir -p /redis/conf
mkdir -p /redis/log
mkdir -p /redis/tmp
```
#### 4：配置文件redis.conf，内容见附录1
```
注：配置文件，复制附录1内容，到文件下:wq
vim redis.conf
-------------------------
cp redis.conf  /redis/conf/redis_6379.conf
-------------------------
chown -R redis.redis /redis/
-------------------------
```
#### 5：启动redis各节点
```
/usr/local/bin/redis-server /redis/conf/redis_6379.conf
```
#### 6：查看服务
```
注：查看启动进程
------------------
ps -ef | grep redis
root     17295     1  0 10:15 ?        00:00:11 /usr/local/bin/redis-server 192.168.1.230:6379
注：查看监听端口
------------------
netstat -tnlp | grep redis
tcp        0      0 192.168.1.230:6379      0.0.0.0:*               LISTEN      17295/redis-server  
------------------
```
### 附录1：
```
# 关闭保护模式
protected-mode no
# ip地址
bind 192.168.1.230
# 端口
port 6379
# 守护进程开启,默认服务从后台启动
daemonize yes
# pid文件
pidfile /redis/pid/redis-6379.pid
# 日志级别
loglevel verbose
# 日志文件位置
logfile /redis/log/redis-6379.log
## redis持久化rdb,AOF
# redis持久化文件路径,默认为当前路径
dir /redis/data
# redis持久化文件名称
dbfilename dump-6379.rdb
# 开启AOF
appendonly yes
# AOF文件名称
appendfilename "appendonly-6379.aof"
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
# 关闭集群配置
# cluster-enabled yes
# 节点配置文件，这个文件是服务启动时自己配置创建的
cluster-config-file nodes-6379.conf
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
# redis访问密码
requirepass 123456                      
```
