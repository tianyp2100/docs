Nginx高性能的HTTP和反向代理服务器安装
====================================
#### 1.安装参数: ubuntu: 14.04.5; nginx: 1.12.0
#### 2:下载安装包
```
http://nginx.org/en/download.html
ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
```
```
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz
wget https://nginx.org/download/nginx-1.12.0.tar.gz
```
#### 3:安装依赖
```
1. 安装pcre: 支持rewrite等regular功能
tar zxvf pcre-8.38.tar.gz
cd pcre-8.38
./configure
make && make install
man pcre
2. 安装openssl: 支持ssl功能
apt-get install openssl*
3. 安装gzip: 支持zlib数据头/压缩数据
apt-get install zlib*
```
#### 4:创建目录、用户、组
```
mkdir -p /usr/local/nginx
groupadd nginx
useradd nginx -g nginx -d /usr/local/nginx -s /sbin/nologin
```
#### 5:解压、编译、安装
```
tar zxvf nginx-1.12.0.tar.gz
cd nginx-1.12.0
mkdir -p /usr/local/nginx
./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module --with-pcre --with-stream
make && make install
```
#### 6:设置目录所属
```
chown -R nginx:nginx /usr/local/nginx
```
#### 7:检查安装：版本和模块(若错误:`附录1`)
```
/usr/local/nginx/sbin/nginx -V
----------------------------------
nginx version: nginx/1.12.0
built by gcc 4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04.3) 
built with OpenSSL 1.0.1f 6 Jan 2014
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module --with-pcre
```
#### 8:测试配置文件是否正确(配置文件参考:`附录3`)
```
#建议每次启动检查
/usr/local/nginx/sbin/nginx -t
-------------------
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```
#### 9:启动和热启动和停止
```
# 启动服务
/usr/local/nginx/sbin/nginx
# 热重启 - 不断开请求的
kill -HUP `cat /usr/local/nginx/logs/nginx.pid`
# 停止服务(主进程退出)
kill -QUIT `cat /usr/local/nginx/logs/nginx.pid`
```
#### 10:启动测试(80端口占用:`附录2`)
```
#进程
ps -ef |grep nginx
#端口，默认80
netstat -tunlp
#web访问，简单页面就ok
http://yournginxip/
---
Welcome to nginx!
```
#### 附录1:
```
[Error]:
./nginx: error while loading shared libraries: libpcre.so.1: cannot open shared object file: No such file or directory
[Solve]:
ln -s /usr/local/lib/libpcre.so.1 /lib
ln -s /usr/local/lib/libpcre.so.1 /lib64
```
#### 附录2:
```
#查看80的pid
lsof -i:80
--------------------------
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
aolserver 949 www-data    4u  IPv4   9980      0t0  TCP localhost:http (LISTEN)
--------------------------
kill -9 949
```
#### 

### 附录最后(nginx.conf):
```
#nginx所用的用户和组,windows下不指定
user  nginx nginx;

#nginx工作的子进程数量(通常等于CPU数量或者CPU的2倍)--每个进程消耗10~12M内存
worker_processes  2;

#nginx错误日志的存放位置和级别
#级别 debug,info,notice,warn,error,crit
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
error_log  logs/error.log  info;

#nginx的进程id存放地址,启动自动生成
pid        logs/nginx.pid;
#一个进程可以打开的最多文件扫描符数目 --执行 ulimit -n 65535后生效
#worker_rlimit_nofile=65535;

events {
    #使用网络IO模型linux建议epoll,FreeBSD建议采用kqueue,window下不指定
    use epoll;
    #允许最大连接数
    #nginx: [warn] 4096 worker_connections exceed open file resource limit: 1024
    #Nginx中的这些和系统变量有关的，是根据系统中的配置而进行设置的，若大于了系统变量的范围的话，不会生效，会被默认成系统的值，如每个worker进行能够打开的文件数量就被默认成系统的值1024；
    worker_connections  5000;
}

http {
        ###---Http服务器配置
        include       mime.types;
        default_type  application/octet-stream;
        #定义日志格式 --main为日志格式名称
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                             '"$status" $body_bytes_sent "$http_referer" '
                             '"$http_user_agent" "$http_x_forwarded_for" '
                             '"$gzip_ratio" $request_time $bytes_sent $request_length';


        access_log  logs/access.log  main;
        #允许客户端请求的最大的单个文件字节数,nginx上传文件大小限制
        client_max_body_size    500M;
        #指定来自客户端请求头的headerbuffer的大小 --大多数请求1k足够,自定义消息头或更大的cookie
        client_header_buffer_size 512K;
        #指定客户端请求较大的消息头的缓存最大数量和大小,4个缓存为128kb
        large_client_header_buffers 4 32k;

        #开启高效文件传输模式  --tcp_nopush 和tcp_nodelay 两个设置为on,防止网络阻塞
        sendfile        on;
        tcp_nopush     on;
        tcp_nodelay    on;
        #用于设置客户端连接保持活动的超时时间
        keepalive_timeout  65;
        #用于设置客户端请求头读取超时时间
        client_header_timeout 10;
        #用于设置客户端请求主体读取超时时间 --超过这个时间客户端没有发送任何数据 nginx返回Request time out(408)
        client_body_timeout 10;
        #用于指定相应客户端的超时时间  --仅限于两个连接活动之间的时间
        #send_timeout 10;

        ###---HttpGzip服务器配置 --安装--with-http_gzip_static_module
        #设置开启和关闭gzip模块,此处开启gzip压缩,实时压缩输出数据流
        gzip  on;
        #允许压缩的页面最小字节数,页面字节数从header头的Content-Length中获取。默认0,不管页面多大都进行压缩
        #建议设置1k的字节数,小于1k可能会越压越大
        gzip_min_length 1k;
        #申请4个单位为16k的内存作为压缩结果流缓存,默认申请和原始数据同大小的内存空间来存储压缩结果
        gzip_buffers 4 16k;
        #用于设置识别http协议版本,默认1.1
        gzip_http_version 1.1;
        #指定gzip压缩比,1压缩比最小,处理速度最快,9压缩比最大,传输速度快,处理速度慢,耗cpu
        gzip_comp_level 2;
        #用于指定压缩多类型 --无论指定text/html类型总会被压缩
        gzip_types text/plain application/x-javascript text/css application/xml;
        #让前段的缓存服务器缓存经过gzip压缩的页面
        gzip_vary on;

        upstream timespacexstar443 {
           #根据ip计算将请求分配各那个后端tomcat,许多人误认为可以解决session问题,其实并不能。
           #同一机器在多网情况下,路由切换,ip可能不同
               #182.92.184.157
           ip_hash;
           server 127.0.0.1:7443 weight=1 max_fails=2 fail_timeout=30s;
           #server 121.41.80.174:8443 weight=1 max_fails=2 fail_timeout=30s;
        }

        #include    hxwise/prod_hxwise.conf;

        #server虚拟主机配置
        # HTTP server
        server {
            #此server虚拟主机的服务器端口
            listen       80;
            #用于指定ip地址或域名，多个域名逗号隔开
            # server_name  localhost;
            server_name  www.timespacexstar.com;
            rewrite ^(.*) https://$server_name$1 permanent;
        }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

    server {
            listen 80;
            server_name www.hxwise.com;
            proxy_redirect off;
            location / {
             proxy_set_header Host $host;
             proxy_set_header X-Real-IP $remote_addr;
             proxy_set_header REMOTE_HOST $server_name;
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
             proxy_pass http://www.hxwise.com:27180;  #在/etc/hosts已配置: 36.110.13.137  www.hxwise.com
            }
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                    root   html;
            }
    }



    # HTTPS server

    server {
        # HTTP/2 and SPDY indicator
        listen       443 ssl http2;
        #server_name  localhost;
        server_name  www.timespacexstar.com;

        keepalive_timeout   70;

        ssl_certificate      /usr/local/nginx/conf/rsakey/1_timespacexstar.com_bundle.crt;
        ssl_certificate_key  /usr/local/nginx/conf/rsakey/2_timespacexstar.com.key;

        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  10m;

        #ssl_ciphers  HIGH:!aNULL:!MD5;
        #ssl_prefer_server_ciphers  on;
        #ssl_protocols  SSLv2 SSLv3 TLSv1;
        #ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
        #ssl_prefer_server_ciphers   on;

        charset utf-8;
        #客户端通过 SSL 请求过来的访问被反向代理 nginx 接收,nginx 结束了 SSL 并将请求以纯 HTTP 提交 tomcat!
        location / {
           # root   html;
           index  index.html index.htm;
           proxy_next_upstream http_502 http_504 error timeout invalid_header;
           proxy_set_header Host  $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto  $scheme;
           #注* server段 proxy_pass定义的web_app需要跟upstream 里面定义的web_app一致,否则server找不到均衡。
           proxy_pass https://timespacexstar443;
           #expires定义用户浏览器缓存的时间为3天,如果静态页面不常更新,可以设置更长,这样可以节省带宽和缓解服务器的压力
           expires      3d;
        }
        location ^~ /static/{
           root /home/data;
           proxy_store on;
           proxy_store_access user:rw group:rw all:rw;
           proxy_redirect          off;
           proxy_set_header        Host $host;
           proxy_set_header        X-Real-IP $remote_addr;
           proxy_set_header        X-Forwarded-For $remote_addr;
           client_max_body_size    20m;
           client_body_buffer_size 128k;
           proxy_connect_timeout   90;
           proxy_send_timeout      90;
           proxy_read_timeout      90;
           proxy_buffer_size       4k;
           proxy_buffers           4 32k;
           proxy_busy_buffers_size 64k;
           proxy_temp_file_write_size 64k;
           proxy_temp_path        /home/data;
           expires 4d;
        }
        error_page  404              /404-443.html;
        location = /404-443.html{
                root /home/data/static/nginx-warmtips/443;
        }
        error_page   500 502 503 504  /50x-443.html;
        location = /50x-443.html {
                root /home/data/static/nginx-warmtips/443;
        }
    }

}
```
