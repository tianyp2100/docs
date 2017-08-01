Ubuntu14.04.5源码安装MySQL数据库mysql-5.7.17.tar.gz
======================================================
#### Tony 2017年3月10日14:50:09 ####
---------------------------------

#### 1.依赖软件下载(已上传ftp):
|名称|下载链接|
|----|----
| m4 | http://ftp.gnu.org/gnu/m4/
| bison | http://ftp.gnu.org/gnu/bison/
| cmake | https://cmake.org/download/ 
| ncurses | ftp://invisible-island.net/ncurses/
| boost | http://www.boost.org/
| mysql | http://ftp.kaist.ac.kr/mysql/Downloads/
#### 2.此笔记使用版本和简介:
```
m4-1.4.18.tar.gz
bison-3.0.tar.gz   
ncurses-6.0.tar.gz   
cmake-3.7.2.tar.gz  
boost_1_59_0.tar.gz
mysql-5.7.17.tar.gz (推荐:需自己安装boost)
mysql-boost-5.7.17.tar.gz (含boost)
---------------------------------
GNU M4的实现传统Unix宏处理器。
GNU bison 是属于 GNU 项目的一个语法分析器生成器。
Ncurses是提供字符终端处理库，提供功能键定义(快捷键),屏幕绘制以及基于文本终端的图形互动功能的动态库。
CMake是一个跨平台的安装（编译）工具，可以用简单的语句来描述所有平台的安装(编译过程)。
Boost库是一个可移植、提供源代码的C++库，作为标准库的后备，是C++标准化进程的开发引擎之一。
MySQL是一个关系型数据库管理系统。
```
#### 3.依赖安装(部分顺序依赖--默认安装不需要指定目录):
```
C compiler:
apt-get install gcc build-essential
--------------------------------------------------------------
m4:
tar zxvf m4-1.4.18.tar.gz
cd m4-1.4.18 
./configure   
make && make install  
man m4  
--------------------------------------------------------------
bison:
tar zxvf bison-3.0.tar.gz  
cd bison-3.0  
./configure  
make && make install  
man bison
--------------------------------------------------------------
ncurses:
tar zxvf ncurses-6.0.tar.gz  
cd ncurses-6.0  
./configure  
make && make install  
man ncurses 
--------------------------------------------------------------
cmake:
tar zxvf cmake-3.7.2.tar.gz  
cd cmake-3.7.2 
./bootstrap  
make && make install  
cmake --version 
--------------------------------------------------------------
boost((若安装需耐心等待)--此处先不安装，mysql编译时后俩参数，会自动编译安装boost.):
tar -zxvf boost_1_59_0
cd boost_1_59_0
./bootstrap.sh
./bjam --prefix==./prefix/install
./b2 install
dpkg --list |grep boost*
#完成后就代表安装成功!
--------------------------------------------------------------
```
\<br>附录日志:<br>
..................<br>
common.copy /usr/local/lib/libboost_test_exec_monitor.a<br>
...failed updating 56 targets...<br>
...skipped 6 targets...<br>
...updated 13469 targets...<br>
#### 4.安装目录和数据目录:
```
mkdir -p /usr/local/mysql  
mkdir /data   
mkdir -p /home/mysql/boost  
``` 
注：-p参数：如果一个目录的父目录不存在，就创建它
#### 5.用户和组:
``` 
groupadd mysql
useradd mysql -g mysql -d /usr/local/mysql -M -s /sbin/nologin 
#检查
grep mysql /etc/group 
grep mysql /etc/passwd
``` 
注：-g：指定新用户所属的用户组(group)； -M：不建立根目录；-s：定义其使用的shell,/sbin/nologin代表用户不能登录系统。
#### 6.解压目录(此目录随意，具体安装目录为指定的编译目录:cmake_install_prefix参数指定):
``` 
tar zxvf mysql-5.7.17.tar.gz
cd mysql-5.7.17
ls -t
#所含文件
Docs  scripts  storage  support-files  unittest  win   mysql-test  mysys_ssl  plugin  regex       BUILD   cmake           dbug   include          libbinlogstandalone  libmysql   libservices     config.h.cmake   COPYING              INSTALL  VERSION
man   sql      strings  testclients    vio       zlib  mysys       packaging  rapid   sql-common  client  cmd-line-utils  extra  libbinlogevents  libevent             libmysqld  CMakeLists.txt  configure.cmake  Doxyfile-perfschema  README
``` 
#### 7.归属目录mysql用户:
``` 
chown -R mysql.mysql /usr/local/mysql  
chown -R mysql.mysql /data
chown -R mysql.mysql /home/mysql/boost 
``` 
#### 8.cmake编译工具编译mysql源代码(耐心等待):
``` 
cp /home/temp/boost_1_59_0.tar.gz /home/mysql/boost
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data -DSYSCONFDIR=/etc -DMYSQL_UNIX_ADDR=/data/mysql.sock -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_bin -DEXTRA_CHARSETS=all -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/home/mysql/boost
``` 
注:<br>cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data -DSYSCONFDIR=/etc -DMYSQL_UNIX_ADDR=/data/mysql.sock -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_bin -DEXTRA_CHARSETS=all -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/home/mysql/boost
#### 9.编译和安装(耐心等待):
``` 
make && make install
``` 
注：建议磁盘大小：30G以上，安装编译安装前可以：make test:检查安装最佳(Errors，请直接编译安装)!
\<br>附录日志:<br>
...........<br>
-- Installing: /usr/local/mysql/support-files/mysqld_multi.server<br>
-- Installing: /usr/local/mysql/support-files/mysql-log-rotate<br>
-- Installing: /usr/local/mysql/support-files/magic<br>
-- Installing: /usr/local/mysql/share/aclocal/mysql.m4<br>
-- Installing: /usr/local/mysql/support-files/mysql.server<br>
#### 10.进入安装目录下:
``` 
cd /usr/local/mysql
``` 
#### 11.初始化MySQL数据库(简解:`附录2`(最后日志是root在localhost上的密码：root@localhost: if*LYwssy8D,))---`初始化无日志，初始化失败`:
``` 
bin/mysqld --initialize --basedir=/usr/local/mysql --datadir=/data --user=mysql
``` 
#### 12.脚本工具生成密钥文件:
``` 
bin/mysql_ssl_rsa_setup
``` 
#### 13.配置文件移动(内容:`附录1`)---`MySQL服务器第一次安装完毕后，再替换默认的，否则，安装可能失败`:
``` 
cp support-files/my-default.cnf /etc/my.cnf
``` 
#### 14.启动脚本文件移动:
``` 
cp support-files/mysql.server /etc/init.d/mysqld
``` 
#### 15.所有MySQL涉及文件归属目录mysql用户:
``` 
chown -R mysql.mysql /usr/local/mysql  
chown -R mysql.mysql /data
chown -R mysql.mysql /home/mysql/boost 
chown -R mysql.mysql /etc/my.cnf 
chown -R mysql.mysql /etc/init.d/mysqld
``` 
#### 16.启动数据库(其他脚本:`附录3`):
``` 
chown -R mysql.mysql /data
service mysqld start
``` 
#### 注:`数据库服务成功后，先stop停止服务，替换或配置my.cnf文件，再次启动数据库服务！`
#### 17.检查启动:
``` 
#端口(默认3306)
netstat -tunlp
-------------------------------------------
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name      
tcp6       0      0 :::3306                 :::*                    LISTEN      18426/mysqld
-------------------------------------------
#进程
ps -ef |grep mysql
-------------------------------------------
root     18509     1  0 20:18 pts/0    00:00:00 /bin/sh /usr/local/mysql/bin/mysqld_safe --datadir=/data --pid-file=/data/mysql.pid
mysql    18764 18509 12 20:18 pts/0    00:00:00 /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/data --plugin-dir=/usr/local/mysql/lib/plugin --user=mysql --log-error=/var/log/mysqld.log --pid-file=/data/mysql.pid --socket=/data/mysql.sock --port=3306
-------------------------------------------
``` 
#### 16.配置MySQL首选项:
``` 
vim /etc/profile
#最后加入
--------------------------------
#MySQL
export MYSQL_HOME=/usr/local/mysql  
export PATH=$MYSQL_HOME/bin:$PATH
--------------------------------
#生效
source /etc/profile
#版本
mysql --version
mysql  Ver 14.14 Distrib 5.7.17, for Linux (x86_64) using  EditLine wrapper
```
#### 17.新密码登录方式及密码策略(错误见: `附录4`):
``` 
#客户端登录MySQL(使用第11步初始化的密码就好)
mysql -h localhost -u root -p
#第一次登录要重置root密码:
#重置密码
alter user root@'localhost' identified by '123456hhXXX';
#授权用户dba所有库所有权限所有ip(自定义)
grant all on *.* to dba@'%' Identified by '123456hhXXX';
#mysql数据库的用户信息/权限表中的设置提取到内存里，直接生效。
flush privileges;
select user,host,authentication_string,password_expired from user;
``` 
注:现在就可以使用客户端和SQLyog等登录操作了！
### 附录1: MySQL配置文件 [ my.cnf ]:
```
# The MySQL client
[client]
port            = 3306
socket          = /data/mysql.sock

# The MySQL server 
[mysqld]
basedir = /usr/local/mysql
datadir = /data
port = 3306
socket = /data/mysql.sock
log-error = /data/mysql-error.log
pid-file = /data/mysql.pid
user = mysql

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
group_concat_max_len = 102400
explicit_defaults_for_timestamp=true
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```
### 附录2: MySQL初始化:
```
# 原初始化命令(已废除)
bin/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/data --user=mysql
# 执行
[Error] mysql_install_db is deprecated. Please consider switching to mysqld --initialize
# mysql_install_db 从5.7.6后已被废除。
# 新初始化命令:
# 1:
bin/mysqld --initialize --basedir=/usr/local/mysql --datadir=/data --user=mysql
# 2:
如果配置文件/etc/my.cnf已有:
[mysqld]
basedir = /usr/local/mysql
datadir = /data
则，可以:
bin/mysqld --initialize --defaults-file=/etc/my.cnf --user=mysql
```
附录日志:<br>
2017-03-10T10:24:13.659181Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).<br>
2017-03-10T10:24:14.628322Z 0 [Warning] InnoDB: New log files created, LSN=45790<br>
2017-03-10T10:24:14.808861Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.<br>
2017-03-10T10:24:14.967463Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: b5f0f996-057b-11e7-acf9-080027310bd8.<br>
2017-03-10T10:24:14.970310Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.<br>
2017-03-10T10:24:14.975280Z 1 [Note] A temporary password is generated for root@localhost: if*LYwssy8D,<br>
### 附录3,服务器脚本:
```
启动:
service mysqld start
停止:
service mysqld stop
重启:
service mysqld restart
运行状态:
service mysqld status
启动数据库:
bin/mysqld_safe --user=mysql &
注:此命令，无法停止数据库，重启服务器下解决关闭! reboot.
```
### 附录4,MySQL管理密码:
```
use mysql
# 原更新密码:
update user set password=password('') where user='root';
# 出错: 没有password这个数据字段列
ERROR 1054 (42S22): Unknown column 'password' in 'field list'
# 查看mysql.user结构
desc user
+------------------------+-----------------------------------+------+-----+-----------------------+-------+
| Field                  | Type                              | Null | Key | Default               | Extra |
+------------------------+-----------------------------------+------+-----+-----------------------+-------+
| Host                   | char(60)                          | NO   | PRI |                       |       |
| User                   | char(32)                          | NO   | PRI |                       |       |

.......

| plugin                 | char(64)                          | NO   |     | mysql_native_password |       |
| authentication_string  | text                              | YES  |     | NULL                  |       |
| password_expired       | enum('N','Y')                     | NO   |     | N                     |       |
| password_last_changed  | timestamp                         | YES  |     | NULL                  |       |
| password_lifetime      | smallint(5) unsigned              | YES  |     | NULL                  |       |
| account_locked         | enum('N','Y')                     | NO   |     | N                     |       |
+------------------------+-----------------------------------+------+-----+-----------------------+-------+
# 用户账户密码信息
+-----------+-----------+-------------------------------------------+------------------+
| user      | host      | authentication_string                     | password_expired |
+-----------+-----------+-------------------------------------------+------------------+
| root      | localhost | *FE707C070F7E18BF441F6E5908F9C86F901DC9B4 | Y                |
| mysql.sys | localhost | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE | N                |
+-----------+-----------+-------------------------------------------+------------------+
注: 会看到root账户的密码已过期，还比5.6多出了一个mysql.sys用户
# 更新root密码
update user set authentication_string=password('123456hhXXX') where User='root';
# 首次root登录操作需要重置密码
ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
# 重置密码
alter user root@'localhost' identified by '123456hhXXX';
# 密码要满足制定的密码难度要求
ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
# 查看用户账户密码信息(↓)
+-----------+-----------+-------------------------------------------+------------------+
| user      | host      | authentication_string                     | password_expired |
+-----------+-----------+-------------------------------------------+------------------+
| root      | localhost | *FE707C070F7E18BF441F6E5908F9C86F901DC9B4 | N                |
| mysql.sys | localhost | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE | N                |
| dba       | %         | *FE707C070F7E18BF441F6E5908F9C86F901DC9B4 | N                |
+-----------+-----------+-------------------------------------------+------------------+
#若忘记mysql的密码:
-------------------------------------------
#先设置一下/etc/my.cnf:
user = mysql
explicit_defaults_for_timestamp=true
#然后，跳过授权验证方式启动MySQL
mysqld --skip-grant-tables &
#客户端登录(无验证)
mysql
#更新root密码
update user set authentication_string=password('123456hhXXX') where User='root';
#关闭mysql服务器正常启动
service mysqld stop
service mysqld start
-------------------------------------------
```
```
注1:
[Error] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
[Solve] 在配置文件my.cnf服务器配置:
explicit_defaults_for_timestamp=true
```
```
[Error]
2017-04-18T11:33:31.027475Z 0 [Warning] 'NO_ZERO_DATE', 'NO_ZERO_IN_DATE' and 'ERROR_FOR_DIVISION_BY_ZERO' sql modes should be used with strict mode. They will be merged with strict mode in a future release.
2017-04-18T11:33:31.027480Z 0 [Warning] 'NO_AUTO_CREATE_USER' sql mode was not set.
2017-04-18T11:33:31.027507Z 0 [Note] --secure-file-priv is set to NULL. Operations related to importing and exporting data are disabled
2017-04-18T11:33:31.027534Z 0 [Note] mysqld (mysqld 5.7.17) starting as process 30699 ...
2017-04-18T11:33:31.031538Z 0 [ERROR] Fatal error: Please read "Security" section of the manual to find out how to run mysqld as root!

2017-04-18T11:33:31.032121Z 0 [ERROR] Aborting

2017-04-18T11:33:31.032266Z 0 [Note] Binlog end
2017-04-18T11:33:31.032425Z 0 [Note] mysqld: Shutdown complete
[Solve]在配置文件my.cnf服务器配置:
user = mysql
```
```
#MySQL忘记root密码
1：[root@localhost ~]# /etc/init.d/mysql stop
Shutting down MySQL....                                    [  OK  ]
2：[root@localhost ~]# /etc/init.d/mysql start  --skip-grant-tables
Starting MySQL.                                            [  OK  ]
注：修改配置文件/etc/my.cnf,在mysqld进程配置中添加skip-grant-tables,修改完成后注释或删除！
3：[root@localhost ~]# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.
………………
注：第3步骤，直接Enter！
4：mysql> use mysql
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
5：mysql> update user set password=password("12345") where user="root"; 
Query OK, 5 rows affected (0.00 sec)
Rows matched: 5  Changed: 5  Warnings: 0

6：mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
注：第6步可以不执行***。

7：mysql> exit
Bye
8：[root@localhost ~]# /etc/init.d/mysql stop
Shutting down MySQL....                                    [  OK  ]
[root@localhost ~]# /etc/init.d/mysql start
Starting MySQL.                                            [  OK  ]
```