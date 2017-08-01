ubuntu14.04.5安装mariadb10.2.6
===========================================
###### MySQL是一个关系型数据库管理系统，由瑞典MySQL AB 公司开发，此后，公司MySQL AB卖给了SUN, 此后, 随着SUN被甲骨文收购,目前属于 Oracle 旗下产品。
###### MariaDB是流行的MySQL数据库的衍生版，也可以看成是mysql的一个分支，主要由MariaDB 基金会与开源社区的用户和开发者以自由和开源软件的精神共同负责维护。
###### MariaDB采用GPL授权许可证。MariaDB的目的是完全兼容MySQL，包括API和命令行，使之能轻松成为MySQL的代替品，对于开发者来说，几乎感觉不到任何不同。 目前MariaDB是发展最快的MySQL分支版本，新版本发布速度已经超过了Oracle官方的MySQL版本。
###### 在存储引擎方面，MariaDB使用XtraDB（英语：XtraDB）来代替MySQL的InnoDB。 MariaDB基于事务的Maria存储引擎, 替换了MySQL的MyISAM存储引擎, 它使用了Percona的 XtraDB, InnoDB的变体。
###### Maria可以支持事务, 但是默认情况下没有打开事务支持, 因为事务支持对性能会有影响。 可以通过以下语句, 转换为支持事务的Maria引擎。
```
ALTER TABLE `tablename` ENGINE=MARIA TRANSACTIONAL=1;
```
###### MariaDB与 MySQL 相比较，MariaDB 更强的地方在于：
```
Maria 存储引擎
PBXT 存储引擎
XtraDB 存储引擎
FederatedX 存储引擎
更快的复制查询处理
线程池
更少的警告和bug
运行速度更快
更多的 Extensions (More index parts, new startup options etc)
更好的功能测试
数据表消除
慢查询日志的扩展统计
支持对 Unicode 的排序
```
### 1.获取安装MariaDB:
###### 1.1 下载:[链接](https://downloads.mariadb.org/mariadb/+releases/)
```
https://downloads.mariadb.org/mariadb/+releases/
https://downloads.mariadb.org/mariadb/repositories/#mirror=neusoft&distro=Ubuntu&distro_release=trusty--ubuntu_trusty&version=10.2
```
##### 1.2 设置源:
###### 可以在页面上，操作系统14.04 LTS "trusty"下安装10.2版本(此页面可以切换OS、OSversion、DBversion、Mirror选取):
###### Here are the commands to run to install MariaDB on your Ubuntu system:
###### 下三步都不能少。
```
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.2/ubuntu trusty main'
```
##### 1.3 安装:
###### Once the key is imported and the repository added you can install MariaDB with:
```
sudo apt-get update
sudo apt-get install mariadb-server
```
###### 注：中间有设计root密码的地方，可直接设置。
##### 1.4 安装完成后数据库已经在运行:
```
ps -ef |grep mysql
root      6323     1  0 09:08 pts/0    00:00:00 /bin/bash /usr/bin/mysqld_safe
mysql     6533  6323  0 09:08 pts/0    00:00:01 /usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql --skip-log-error --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock --port=3306
root      6534  6323  0 09:08 pts/0    00:00:00 logger -t mysqld -p daemon.error
```
```
netstat -tunlp
tcp        0      0 192.168.1.230:3306      0.0.0.0:*               LISTEN      6533/mysqld 
```
```
mysql --version
mysql  Ver 15.1 Distrib 10.2.6-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2
```
### 2.设置MariaDB，运行安全安装脚本(确保MariaDB处于运行状态):
```
/usr/bin/mysql_secure_installation
```
```
注:
a.提示输入root账户的密码，如果在之前的安装过程中已经设置了，可以按“N”跳过
b.提示是否修改root账户的密码，按下“Y”可以重新设置一个
c.接着会提示是否删除匿名用户，按下“Y”确定
d.接着会提示是否不允许root账户的远程访问，按下“Y”确定
e.接着会提示是否删除test测试数据库，按下“n”确定
f.最后要求重新加载权限表，按下“Y”确定
```
### 2.登录MariaDB:
mysql -u root -p
###### 可设置一个全权限账户:
```
use mysql
grant all on *.* to dba@'%' Identified by '123456';
flush privileges;
select user,host,authentication_string,password_expired from user;
```
### 3.允许远程连接:
###### MariaDB的配置文件:
```
vim /etc/mysql/my.cnf
bind-address: 127.0.0.1
```
###### 修改此地址，允许远程访问的服务器IP。例如:bind-address: 192.168.1.230（数据库服务器ip）
### 4.重启MariaDB，就ok了。
```
sudo service mysql restart
```
