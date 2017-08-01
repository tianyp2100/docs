RabbitMQ消息队列系统安装
==========================
#### 1:下载
```
ftp://invisible-island.net/ncurses/
http://www.rabbitmq.com/download.html
use:
   ncurses-6.0.tar.gz 
   rabbitmq-server-generic-unix-3.6.5.tar.xz 
```   
#### 2:依赖软件
```
------------------------------------------------
ncurses:
tar zxvf ncurses-6.0.tar.gz  
cd ncurses-6.0  
./configure  
make && make install  
man ncurses 
------------------------------------------------
erlang(难装，请耐心等待)：
apt-get install erlang
erl -v
------------------------------------------------
```
#### 3:解压移动(解压即可使用)
```
xz -d rabbitmq-server-generic-unix-3.6.5.tar.xz 
tar xvf rabbitmq-server-generic-unix-3.6.5.tar
cp rabbitmq_server-3.6.5/ /usr/local/rabbitmq_server-3.6.5/
```
#### 4:启动服务
```
/usr/local/rabbitmq_server-3.6.5/sbin/rabbitmq-server
```
#### 5:RabbitMQ提供WEB-UI管理控制台，以下命令激活插件(服务器启动时安装)
```
/usr/local/rabbitmq_server-3.6.5/sbin/rabbitmq-plugins enable rabbitmq_management
-------------------
注:
kill -9 pid后，重启服务。
启动日志: Starting broker... completed with 6 plugins.
```
#### 6:添加管理账户密码（自定义）和权限
```
#添加用户和密码
/usr/local/rabbitmq_server-3.6.5/sbin/rabbitmqctl add_user admin 123456
#给予角色：
/usr/local/rabbitmq_server-3.6.5/sbin/rabbitmqctl set_user_tags admin administrator
#用户列表：
/usr/local/rabbitmq_server-3.6.5/sbin/rabbitmqctl  list_users
#使用户admin具有‘/’这个virtual host中所有资源的配置、写、读权限以便管理其中的资源
/usr/local/rabbitmq_server-3.6.5/sbin/rabbitmqctl set_permissions -p / admin '.*' '.*' '.*'
```
注:<br>
RabbitMQ的用户角色分类：<br>
none、management、policymaker、monitoring（推荐）、administrator