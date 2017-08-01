Ubuntu14.04.5安装RocketMQ3.5.8
===========================================
###### 2016.11，阿里巴巴宣布捐赠RocketMQ到Apache软件基金会孵化项目，RocketMQ是一款开源的分布式消息系统，Metaq3.0 版本改名，产品名称改为RocketMQ。
###### GMT create: 2017-07-02 .
###### 注：以下标题：1-3，为获取源码、编译、打包alibaba-rocketmq-3.5.8.tar.gz，从：4-完，为RocketMQ的配置、安装、操作。
#### 1：安装环境参数数据 (自定义版本适合即可)
###### 1.1 安装参数: 1.ubuntu(14.04.5) 2.jdk(1.8.0_121)
###### 1.2 编译参数：1.ubuntu(14.04.5) 2.jdk(1.8.0_121) 3.git(1.9.1) 4.maven(3.3.9)
#### 2.获取RocketMQ源码
##### 2.1 github地址 [链接1](https://github.com/alibaba/RocketMQ.git) [链接2](https://github.com/apache/incubator-rocketmq)
```
1: https://github.com/alibaba/RocketMQ.git
2: https://github.com/apache/incubator-rocketmq
```
##### 2.2 download released code tar.gz地址 [链接1](https://github.com/alibaba/RocketMQ/releases) 编译好的包: [alibaba-rocketmq-3.5.8.tar.gz](https://loveshare.oss-cn-shanghai.aliyuncs.com/universal/installer/linux/mq/alibaba-rocketmq-3.5.8.tar.gz) 
```
1: https://github.com/alibaba/RocketMQ/releases
2: https://loveshare.oss-cn-shanghai.aliyuncs.com/universal/installer/linux/mq/alibaba-rocketmq-3.5.8.tar.gz
```
##### 2.3 从github上获取RocketMQ源码
```
git clone https://github.com/alibaba/RocketMQ.git
cd RocketMQ/
```
##### 2.4 查看只有master分支，且上边并无代码
```
git branch
 * master
ls -la
 .git/  README.md
```
##### 2.5 列出已有标签
```
git tag
 v3.2.2
 v3.2.4-beta1
 v3.2.6
 v3.4.6
 v3.5.8
```
##### 2.6 切换标签v3.5.8获取最新源码：
```
git checkout v3.5.8
ls -a
.   benchmark  CHANGELOG.md  conf             deploy.bat   .git        install.bat  issues   NOTICE   README.cn.md  release-client.xml  rocketmq-broker  rocketmq-common   rocketmq-filtersrv  rocketmq-remoting  rocketmq-store  sbin  .travis.yml
..  bin        checkstyle    CONTRIBUTING.md  eclipse.bat  .gitignore  install.sh   LICENSE  pom.xml  README.md     release.xml         rocketmq-client  rocketmq-example  rocketmq-namesrv    rocketmq-srvutil   rocketmq-tools  test  wiki
```
#### 3.Maven编译RocketMQ源码：
##### 3.1 编译前配置（可选）：
###### 3.1.1 编译sh文件的权限
```
chmod +x install.sh
```
###### 3.1.2 JVM启动内存参数（bin下的runserver.sh和runbroker.sh两个文件），注1.8PermGen区被移除，默认（4g），我的（1g）
``` 
cd bin/
Default: JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:PermSize=128m -XX:MaxPermSize=320m"
My:      JAVA_OPT="${JAVA_OPT} -server -Xms1g -Xmx1g -Xmn512m -XX:PermSize=128m -XX:MaxPermSize=320m"
```
###### 3.1.3 文件权限（可选）
```
chmod +x mqnamesrv mqbroker mqadmin mqfiltersrv mqshutdown
```
###### 3.1.4 DOS格式文本文件转换成UNIX格式（可选，且仅用widows2linux）
```
dos2unix mqnamesrv mqbroker mqadmin mqfiltersrv mqshutdown runserver.sh runbroker.sh tools.sh
```
##### 3.2 编译源码（源码根路径）,环境变量查看：4.3
```
./install.sh
```
##### 3.3 编译结果：
###### 3.3.1 编译结果文件夹
```
cd target/
ls -a
.  ..  alibaba-rocketmq-broker  alibaba-rocketmq-broker.tar.gz  archive-tmp  checkstyle-checker.xml  checkstyle-result.xml  effective-pom
```
###### 3.3.2 编译后的打包文件（可移动使用）
```
alibaba-rocketmq-broker.tar.gz
```
###### 3.3.3 编译后改名（可选）：
```
mv alibaba-rocketmq-broker.tar.gz alibaba-rocketmq-3.5.8.tar.gz
```
###### 注：获取RocketMQ源码，编译，打包完毕！

#### 4.安装RocketMQ（必须先安装jdk）
##### 4.1 安装目录选择为根目录（自定义）
```
wget https://loveshare.oss-cn-shanghai.aliyuncs.com/universal/installer/linux/mq/alibaba-rocketmq-3.5.8.tar.gz
tar zxvf alibaba-rocketmq-3.5.8.tar.gz
cp -R alibaba-rocketmq /rocketmq
```
##### 4.2 用户、组、拥有
```
groupadd rocketmq
useradd rocketmq -g rocketmq -d /rocketmq -M -s /sbin/nologin
chown -R rocketmq:rocketmq /rocketmq/
```
##### 4.3 系统环境变量配置
```
#JDK
export JAVA_HOME=/usr/local/jdk1.8.0_121
export CLASSPATH=$JAVA_HOME/lib:.
#Maven
export MAVEN_HOME=/usr/local/apache-maven-3.3.9
#RocketMQ
export ROCKETMQ_HOME=/rocketmq

export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$ROCKETMQ_HOME/bin:$PATH
```
##### 4.4 系统环境变量配置生效
```
 source /etc/profile
```
#### 5.启动RocketMQ (注：错误解决在最后，附录)：
##### 5.1 切换操作路径
```
cd /rocketmq/bin/
```
##### 5.2 执行权限设定（可选）
```
chmod +x mqnamesrv mqbroker mqadmin mqfiltersrv mqshutdown
```
##### 5.3 修改jvm启动参数，runserver.sh和runbroker.sh两个文件（可选,自定义）
```
JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:PermSize=128m -XX:MaxPermSize=320m"
JAVA_OPT="${JAVA_OPT} -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+DisableExplicitGC"
JAVA_OPT="${JAVA_OPT} -verbose:gc -Xloggc:${HOME}/rmq_srv_gc.log -XX:+PrintGCDetails"
JAVA_OPT="${JAVA_OPT} -XX:-OmitStackTraceInFastThrow"
JAVA_OPT="${JAVA_OPT} -Djava.ext.dirs=${BASE_DIR}/lib"
JAVA_OPT="${JAVA_OPT} -Xdebug -Xrunjdwp:transport=dt_socket,address=9555,server=y,suspend=n"
JAVA_OPT="${JAVA_OPT} -cp ${CLASSPATH}"
```
##### 5.4.启动nameserver
```
nohup ./mqnamesrv &
```
###### 启动日志：The Name Server boot success. serializeType=JSON
##### 5.5.启动broker（启动前需要指定nameserver地址，其中192.168.0.233为所在服务器IP）
```
export NAMESRV_ADDR=192.168.0.233:9876
nohup ./mqbroker &
```
###### 启动日志：The broker[server, 192.168.0.233:10911] boot success. serializeType=JSON and name server is 192.168.0.233:9876
#### 6.启动状态检查
##### 6.1 端口检查
```
netstat -tnlp | grep java
tcp6       0      0 :::9876                 :::*                    LISTEN      20683/java      
tcp6       0      0 :::10909                :::*                    LISTEN      20709/java      
tcp6       0      0 :::10911                :::*                    LISTEN      20709/java      
tcp6       0      0 :::10912                :::*                    LISTEN      20709/java  
```
##### 6.2 进程检查
```
ps -ef |grep java
root     15345 15343  1 17:28 pts/1    00:00:01 /usr/local/jdk1.8.0_121/bin/java -server -Xms1g -Xmx1g -Xmn512m -XX:PermSize=128m -XX:MaxPermSize=320m -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -verbose:gc -Xloggc:/root/rmq_srv_gc.log -XX:+PrintGCDetails -XX:-OmitStackTraceInFastThrow -Djava.ext.dirs=/rocketmq/bin/../lib -cp .:/rocketmq/bin/../conf:/usr/local/jdk1.8.0_121/lib:. com.alibaba.rocketmq.namesrv.NamesrvStartup
root     15368 15366 10 17:28 pts/2    00:00:04 /usr/local/jdk1.8.0_121/bin/java -server -Xms1g -Xmx1g -Xmn512m -XX:PermSize=128m -XX:MaxPermSize=320m -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -verbose:gc -Xloggc:/root/tmpfs/logs/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:-OmitStackTraceInFastThrow -XX:+AlwaysPreTouch -Djava.ext.dirs=/rocketmq/bin/../lib -cp .:/rocketmq/bin/../conf:/usr/local/jdk1.8.0_121/lib:. com.alibaba.rocketmq.broker.BrokerStartup
```
#### 7.基本操作 
##### 7.1 查看topic列表
```
root@server:/rocketmq/bin# ./mqadmin topicList -n 192.168.0.233:9876
Java HotSpot(TM) 64-Bit Server VM warning: ignoring option PermSize=128m; support was removed in 8.0
Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=128m; support was removed in 8.0
server
BenchmarkTest
OFFSET_MOVED_EVENT
TBW102
SELF_TEST_TOPIC
DefaultCluster
```
##### 7.2 清空“ts_topic”列表
```
root@server:/rocketmq/bin# ./mqadmin deleteTopic -c 192.168.0.233 -n 192.168.0.233:9876 -t ts_topic
# 然后重启rocketmq
```
### 附录：
###### [Error.1]:
```
系统内存不足。
Native memory allocation (mmap) failed to map 2147483648 bytes for committing reserved memory.
Java HotSpot(TM) 64-Bit Server VM warning: INFO: os::commit_memory(0x0000000740000000, 2147483648, 0) failed; error='Cannot allocate memory' (errno=12)
```
###### [Solve.1]：
```
修改runserver.sh runbroker.sh两个文件的JVM启动JAVA_OPT内存参数。注：上7.3
```
###### [Error.2]:
```
Rocketmq启动时找不到或无法加载主类NamesrvStartup。
Error: Could not find or load main class com.alibaba.rocketmq.namesrv.NamesrvStartup
```
###### [Solve.2]：
```
1：没有使用install.sh进行maven编译。 注：上4
2：环境变量ROCKETMQ_HOME配置的目录不正确。 注：上6
```
###### [Error.3]:
```
nohup: failed to run command ‘./mqnamesrv’: No such file or directory
```
###### [Solve.3]：windows编译在linux上运行可能出现
```
apt-get install dos2unix
dos2unix mqnamesrv mqbroker mqadmin mqfiltersrv mqshutdown runserver.sh runbroker.sh tools.sh
```
###### [Error.4]:
```
com.alibaba.rocketmq.client.exception.MQClientException: No route info of this topic, ab_message
```
###### [Solve.4]:
```
nohup sh mqbroker -n 192.168.0.233:9876 autoCreateTopicEnable=true &
```
