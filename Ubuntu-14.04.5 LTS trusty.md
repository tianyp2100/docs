安装ubuntu-14.04.5-server-amd64.iso操作系统
===============================================
#### 1:安装参考:
|名称|下载链接|
|----|----
| Ubuntu官网中文 | http://www.ubuntu.org.cn/download/alternative-downloads
| Ubuntu官网英文 | https://www.ubuntu.com/download/alternative-downloads
| Ubuntu Server 14.04 安装手册 | http://support.huawei.com/huaweiconnect/enterprise/thread-333163.html
| ubuntu server手动分区 | http://blog.csdn.net/chang_ge/article/details/52653033
| Ubuntu 12.04 分区方案 | http://www.cnblogs.com/maso1987/archive/2012/07/14/2591495.html
#### 2:分区推荐方案
|名称|位置|大小(自定义)|文件格式|
|----|----|----|----
| 根目录 | / | 20G | ext4
| 交换空间 | swap | 2048M | swap
| 系统文件 | /boot | 200M | ext4
| 临时文件 | /tmp | 5G | ext4
| 用户软件工具 | /usr | 10G | ext4
| 用户工作目录 | /home | 15G | ext4
#### 3:安装完成后执行
##### 3.1:ubuntu使用安全的账户管理，所以操作前先要初始化root，登录必须用非root的shell登录，也可设置root登录，不推荐，以下为初始化root密码:
```
server@server:~$sudo passwd root
[sudo] password for server:
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```
##### 3.2 设置静态ip
```
vim /etc/network/interfaces
------------------------------------------
auto eth0
iface eth0 inet static
address 192.168.1.233
netmask 255.255.255.0
gateway 192.168.1.1
```
注: static. 静态 address.地址 netmask.子网掩码 gateway.默认网关
##### 3.3 设置DNS
```
vim /etc/resolvconf/resolv.conf.d/base
------------------------------------------
nameserver 192.168.1.1
```
##### 3.4 设置主机名称
```
hostname nginx
#重启终端可见!
# 永久修改: vim /etc/hostname，重启！
```
##### 3.5:更新软件包
```
apt-get update
```
##### 3.6:安装源的索引
```
apt-get upgrade
```
##### 3.7:安装gcc编译器和开发工具
```
apt-get install gcc build-essential
```
### 然后，可以安装其他软件了！
