# Installer Manual Guide.
## 此安装文档，操作系统: ubuntu-14.04.5 LTS trusty.

|名称|说明|
|---|---|
Ubuntu-14.04.5 LTS trusty.md |	安装Ubuntu-14.04.5操作系统
Git-Server(non-web-html) | Ubuntu-14.04.5安装无web页面git
Jdk-1.8.0_112.md | Ubuntu-14.04.5安装jdk1.8.0_121
Mariadb-10.2.6.md |	Ubuntu-14.04.5安装mariadb-10.2.6
Mongodb-3.2.8.md | Ubuntu-14.04.5安装mongodb-3.2.8
Mysql-5.7.17.md | Ubuntu-14.04.5安装mysql-5.7.17
Nginx-1.10.3.md | Ubuntu-14.04.5安装nginx-1.10.3
Rabbitmq-3.6.5.md |	Ubuntu-14.04.5安装rabbitmq-3.6.5
Redis-3.2.1-sentinel.md | Ubuntu-14.04.5安装redis-3.2.1-sentinel
Redis-3.2.9-cluster.md | Ubuntu-14.04.5安装redis-3.2.9-cluster
Rocketmq-3.5.8.md |	Ubuntu-14.04.5安装rocketmq-3.5.8
Zookeeper-3.4.8.md | Ubuntu-14.04.5安装zookeeper-3.4.8

服务器软件安装指南
=================================
###### 服务器: Ubuntu、CentOS、RedHat、Debian、SUSE、Amazon Linux、OS X 、Windows等
###### 命名规则: 操作系统-操作系统版本-服务软件-服务软件版本-备注.md 
######           命名例如: ubuntu-14.04.5-redis-3.2.1-sentinel.md
### ------以下以Ubuntu 14.04.5 LTS trusty举例------
###### 1: Xshell、Xftp、SecureCRT、SecureFX可视化工具，或ssh、scp、sshpass等命令，连接和操作服务器。
###### 2: 服务器系统暂定镜像：ubuntu-14.04.5-server-amd64.iso，此系统root不能直接远程登录，需要用其他账户登录，例如server，也可设置root登录（不推荐）。
###### 3: 软件安装在用户目录home下创建自定义名字的文件夹，例如temp，并授权登录用户可访问（用户server，目录/home/temp为例）:
```
mkdir -p /home/temp
chown -R server:server /home/temp
```
###### 4: 可连接服务器，并上传文件到/home/temp，然后进行: 移动，解压，编译，安装，测试，检查，运行，监控等！

