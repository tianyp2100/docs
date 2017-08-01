linux源码安装jdk
======================================
#### 1:下载安装(所有)
```
http://www.oracle.com/technetwork/java/javase/archive-139210.html
use: jdk-8u121-linux-x64.tar.gz
```
#### 2:解压移动
```
tar zxvf jdk-8u121-linux-x64.tar.gz
cp -R jdk1.8.0_112/ /usr/local
```
#### 3:修改环境变量
```
vim /etc/profile
#最后加入
#JDK
export JAVA_HOME=/usr/local/jdk1.8.0_112
export CLASSPATH=$JAVA_HOME/lib:.
export PATH=$JAVA_HOME/bin:$PATH
#生效
source /etc/profile
```
#### 4:检查安装
```
java -version
java version "1.8.0_112"
Java(TM) SE Runtime Environment (build 1.8.0_112-b15)
Java HotSpot(TM) 64-Bit Server VM (build 25.112-b15, mixed mode)
也可同时执行java和javac再此检查！
```
注：ubuntu系统每次登录，需要手动生效，自动生效:<br>
可在用户目录下的.profile中最后加入:<br>
source /etc/profile