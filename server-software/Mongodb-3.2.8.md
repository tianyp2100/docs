非关系型数据库MongoDB文档存储数据库安装
=========================================
#### 1:下载
```
https://www.mongodb.com/download-center?jmp=nav#enterprise
use: mongodb-linux-x86_64-ubuntu1404-3.2.8.tgz
```
#### 2:解压移动
```
tar zxvf mongodb-linux-x86_64-ubuntu1404-3.2.8.tgz
cp -R mongodb-linux-x86_64-ubuntu1404-3.2.8/ /usr/local/
```
#### 3:创建数据和配置和日志路径
```
mkdir -p /mongodb/conf
mkdir -p /mongodb/db
mkdir -p /mongodb/log
mkdir -p /mongodb/bin
```
#### 4:创建用户和组
```
groupadd mongodb
useradd mongodb -g mongodb -d /mongodb/bin/mongodb-linux-x86_64-ubuntu1404-3.2.8 -s /sbin/nologin
chown -R mongodb.mongodb /mongodb/
```
#### 5:配置文件(`附录1`)
```
vim /mongodb/conf/mongodb.conf
```
#### 6:启动服务
```
/mongodb/bin/mongodb-linux-x86_64-ubuntu1404-3.2.8/bin/mongod -f /mongodb/conf/mongodb.conf
```
#### 7:测试启动
```
ps -ef |grep mongodb
netstat -tunlp
若28017/27017两个端口已打开则ok!
```
#### 8:Web访问
```
http://yourip:28017/
```
#### 9:停止服务
```
/mongodb/bin/mongodb-linux-x86_64-ubuntu1404-3.2.8/bin/mongo
> use admin
switched to db admin
> db.shutdownServer();
```
#### 10:简单创建数据库和文档集合
```
use hxwise_datas
db.createUser({user:"admin",pwd:"123456",roles:[{ role: "readWrite", db: "hxwise_datas" }]})
db.createCollection("session_cache")
show collections
db
```
#### 附录1(mongodb.conf--):
```
#日志文件
logpath=/mongodb/log/mongodb.log
#日志启动不追加
logappend=false
#数据库文件
dbpath=/mongodb/db
#守护进程--驻留后台
fork=true
#打开web访问(只读) --http://yourip:28017/
rest=true
#使用权限登录(true)
auth=false
```
