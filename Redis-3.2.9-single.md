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
