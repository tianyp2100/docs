# Installer Manual Guide.

|名称|说明|
|---|---|
Ubuntu-14.04.5 LTS trusty.md |	安装Ubuntu-14.04.5操作系统
server-software |	服务器软件安装手册指南
big-data |	大数据安装手册指南

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
