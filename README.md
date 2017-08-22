# docs
Installer Manual Guide.

|名称|说明|
|---|---|
Installer-Manual-ubuntu-14.04.5 LTS trusty.md |	安装Ubuntu-14.04.5操作系统
Installer-Manual-ubuntu-14.04.5-git-server-nonweb.md | Ubuntu-14.04.5安装无web页面git
Installer-Manual-ubuntu-14.04.5-jdk-1.8.0_112.md | Ubuntu-14.04.5安装jdk1.8.0_121
Installer-Manual-ubuntu-14.04.5-mariadb-10.2.6.md |	Ubuntu-14.04.5安装mariadb-10.2.6
Installer-Manual-ubuntu-14.04.5-mongodb-3.2.8.md | Ubuntu-14.04.5安装mongodb-3.2.8
Installer-Manual-ubuntu-14.04.5-mysql-5.7.17.md | Ubuntu-14.04.5安装mysql-5.7.17
Installer-Manual-ubuntu-14.04.5-nginx-1.10.3.md | Ubuntu-14.04.5安装nginx-1.10.3
Installer-Manual-ubuntu-14.04.5-rabbitmq-3.6.5.md |	Ubuntu-14.04.5安装rabbitmq-3.6.5
Installer-Manual-ubuntu-14.04.5-redis-3.2.1-sentinel.md | Ubuntu-14.04.5安装redis-3.2.1-sentinel
Installer-Manual-ubuntu-14.04.5-redis-3.2.9-cluster.md | Ubuntu-14.04.5安装redis-3.2.9-cluster
Installer-Manual-ubuntu-14.04.5-rocketmq-3.5.8.md |	Ubuntu-14.04.5安装rocketmq-3.5.8
Installer-Manual-ubuntu-14.04.5-zookeeper-3.4.8.md | Ubuntu-14.04.5安装zookeeper-3.4.8

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
### ---------命令行: 连接、登录、操作远程服务器---------------
###### 1.sshpass 配置密码自动登录
###### 2.ssh/scp 需手动输入密码
```
举例参数：
  远程服务器ip: 192.168.1.150 用户名: tony 密码: 123456
  本地目录: /home/lctemp
  本地文件: lc.jar
  远程目录: /home/rmtemp
  远程文件: rm.jar
```
#### 3.ssh/scp使用:
##### 3.1. 登录: (ssh $remote_user@$remote_ip) :
######	ssh tony@192.168.1.150
##### 3.2. 上传: (scp local_file remote_user@remote_ip:remote_dir):
######	scp /home/lctemp/lc.jar tony@192.168.1.150:/home/rmtemp
##### 3.3. 下载: (scp remote_user@remote_ip:/remote_file /local_dir):
######	scp tony@192.168.1.150:/home/rmtemp/rm.jar /home/lctemp/
#### 4.sshpass/scp举例（安装见：6）:
##### 4.1. 登录:(sshpass -p $remote_passwd ssh -p22 -o StrictHostKeyChecking=no -tt $remote_user@$remote_ip):
######	sshpass -p 123456 ssh -p22 -o StrictHostKeyChecking=no -tt tony@192.168.1.150
##### 4.2. 上传: (sshpass -p $remote_passwd scp -p22 -o StrictHostKeyChecking=no $local_file $remote_user@$remote_ip:$remote_dir) : 
######	sshpass -p 123456 scp -p22 -o StrictHostKeyChecking=no lc.jar tony@192.168.1.150:/home/api
##### 4.3. 下载: (sshpass -p $remote_passwd scp -p22 -o StrictHostKeyChecking=no $remote_user@$remote_ip:$remote_file $local_dir):	
######	sshpass -p 123456 scp -p22 -o StrictHostKeyChecking=no tony@192.168.1.150:/home/api/rm.jar /home/temp
#### 5.若一次拷贝多个文件或者文件夹:
##### 5.1.  将多个文件放在同一个目录中，使用scp加" -r "参数来拷贝或者在文件夹下用*：
######	scp /home/lctemp/* tony@192.168.1.150:/home/rmtemp
######	scp -r /home/lctemp/ tony@192.168.1.150:/home/rmtemp
##### 5.2. 将多个文件或者目录使用tar打包后作为单个文件传输。
######	tar -zcvf a.tar.gz temp/
#### 6.安装sshpass
##### 6.1. apt-get安装
######	apt-get install sshpass
##### 6.2. 源码安装：[sshpass访问Linux服务器(sshpass)](http://blog.csdn.net/typa01_kk/article/details/42239553)
