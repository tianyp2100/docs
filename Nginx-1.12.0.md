Nginx高性能的HTTP、TCP、反向代理、负载均衡等服务器安装
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
apt-get install -y openssl*
3. 安装gzip: 支持zlib数据头/压缩数据
apt-get install -y zlib*
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
#### 配置文件(nginx.conf)：
```
user  nginx nginx;   # nginx所用的用户和组,windows下不指定
worker_processes  2; # nginx工作的子进程数量(通常等于CPU数量或者CPU的2倍)--每个进程消耗10~12M内存
error_log  logs/error.log  info; # nginx错误日志的存放位置和级别
pid        logs/nginx.pid;  # nginx的进程id存放地址,启动自动生成
events {
        use epoll;    # 使用网络IO模型linux建议epoll,FreeBSD建议采用kqueue,window下不指定
        worker_connections  1024; # 允许最大连接数
}
# http / https
http {
        include       mime.types;
        default_type  application/octet-stream;
# 定义日志格式 --main为日志格式名称
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                '"$status" $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for" '
                '"$gzip_ratio" $request_time $bytes_sent $request_length';
        sendfile       on;  # 开启高效文件传输模式  --tcp_nopush 和tcp_nodelay 两个设置为on,防止网络阻塞
        tcp_nopush     on;
        tcp_nodelay    on;
        keepalive_timeout  65; # 用于设置客户端连接保持活动的超时时间
		gzip  on;      # 设置开启和关闭gzip模块,此处开启gzip压缩,实时压缩输出数据流
		gzip_min_length 1k;  # 允许压缩的页面最小字节数,页面字节数从header头的Content-Length中获取。默认0,不管页面多大都进行压缩,建议设置1k的字节数,小于1k可能会越压越大
		gzip_buffers 4 16k;  # 申请4个单位为16k的内存作为压缩结果流缓存,默认申请和原始数据同大小的内存空间来存储压缩结果
		gzip_http_version 1.1;  # 用于设置识别http协议版本,默认1.1
		gzip_comp_level 2;   # 指定gzip压缩比,1压缩比最小,处理速度最快,9压缩比最大,传输速度快,处理速度慢,耗cpu
		gzip_types text/plain application/x-javascript text/css application/xml;   # 用于指定压缩多类型 --无论指定text/html类型总会被压缩
		gzip_vary on;  # 让前段的缓存服务器缓存经过gzip压缩的页面
		client_max_body_size 1024M;    # 允许客户端请求的最大的单个文件字节数,nginx上传文件大小限制
		client_body_buffer_size 512K;  # 指定来自客户端请求头的headerbuffer的大小 --大多数请求1k足够,自定义消息头或更大的cookie

		include http-conf/*.conf;   # 导入http的配置文件
                                   }
# stream TCP代理和负载均衡
stream{ 
		include stream-conf/*.conf; # 导入stream的配置文件
}
```
#### 配置：配置80跳转443(自定义404/50x错误页面)(http-conf/目录下)：
```
server {
        listen 80;
        server_name loveshare.me;
        rewrite ^(.*)$  https://$server_name$1 permanent;
}

server {
        listen 443 ssl http2;  # HTTP/2 and SPDY indicator
        server_name loveshare.me;
        ssl on;
        ssl_certificate   cert/214214467090613.pem;
        ssl_certificate_key  cert/214214467090613.key;
        ssl_session_timeout 5m;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        location / {
                proxy_set_header Host $host;
                proxy_set_header  X-Forwarded-For $remote_addr;
                proxy_set_header  X-Forwarded-Host $server_name;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass https://127.0.0.1:7688;
        }
        
        error_page  404              /404-443.html;
        location = /404-443.html{
                root /usr/local/nginx/html/443; #全路径
   	}
        error_page   500 502 503 504  /50x-443.html;
        location = /50x-443.html {
               root /usr/local/nginx/html/443;
        }
}
```
#### 配置：多域名转发(http-conf/目录下):
```
server {
        listen 80;
        server_name a.loveshare.me;
        proxy_redirect off;
        location / {
                proxy_set_header Host $host;
                proxy_set_header  X-Forwarded-For $remote_addr;
                proxy_set_header  X-Forwarded-Host $server_name;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass http://192.168.1.123:8012;
        }
}

server {
        listen 80;
        server_name b.loveshare.me;
        proxy_redirect off;
        location / {
                proxy_set_header Host $host;
                proxy_set_header  X-Forwarded-For $remote_addr;
                proxy_set_header  X-Forwarded-Host $server_name;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass http://192.168.1.124:8013;
        }
}
```
#### 配置：html页面转发(http-conf/目录下)，页面地址:/home/html，下，页面跳转逻辑自己维护好:
```
server {
        listen 80;
        server_name h.loveshare.me;
        location /{
                root /home/html;
                index  index.html index.htm;
        }
}
```
#### 配置：html页面转发(http-conf/目录下)，页面地址:/home/html，下，url路径正则转发磁盘目录（同上）:
##### 比如：http://h.loveshare.me/aaa 转发 /root/html/aaa/index.html
```
server {
        listen 80;
        server_name h.loveshare.me;
        location /{
                root /home/html/game;
                index  index.html index.htm;
        }
}
```
#### 配置：web页面和api接口同域名，正则路径，(http-conf/目录下)，页面地址:/home/html:
```
location ^~ /web/ {
        root /home/web;
        index  index.html index.htm;
}

location ^~ /api/ {
        proxy_pass   http://192.168.1.221:8080/loveshareapi/;
        proxy_set_header Host  $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto  $scheme;
}

location ~ .*\\.(html|htm|gif|jpg|jpeg|bmp|png|ico|txt|js|css)$ { 
        root /home/web;
        proxy_set_header Host  $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto  $scheme;
        client_max_body_size    10m;
        client_body_buffer_size 128k;
		#proxy_connect_timeout   90; 
		#proxy_send_timeout      90; 
		#proxy_read_timeout      90; 
        proxy_buffer_size       4k;
        proxy_buffers           4 32k;
        proxy_busy_buffers_size 64k;
        proxy_temp_file_write_size 64k;
        expires  3d;
}
```
#### 配置：PC和移动端页面切换(http-conf/目录下): 
```
server {
        listen       80;
        server_name  www.loveshare.me;
        location / {
                root   /home/website;
                if ( $http_user_agent ~ "(MIDP)|(WAP)|(UP.Browser)|(Smartphone)|(Obigo)|(Mobile)|(AU.Browser)|(wxd.Mms)|(WxdB.Browser)|(CLDC)|(UP.Link)|(KM.Browser)|(UCWEB)|(SEMC\-Browser)|(Mini)|(Symbian)|(Palm)|(Nokia)|(Panasonic)|(MOT\-)|(SonyEricsson)|(NEC\-)|(Alcatel)|(Ericsson)|(BENQ)|(BenQ)|(Amoisonic)|(Amoi\-)|(Capitel)|(PHILIPS)|(SAMSUNG)|(Lenovo)|(Mitsu)|(Motorola)|(SHARP)|(WAPPER)|(LG\-)|(LG/)|(EG900)|(CECT)|(Compal)|(kejian)|(Bird)|(BIRD)|(G900/V1.0)|(Arima)|(CTL)|(TDG)|(Daxian)|(DAXIAN)|(DBTEL)|(Eastcom)|(EASTCOM)|(PANTECH)|(Dopod)|(Haier)|(HAIER)|(KONKA)|(KEJIAN)|(LENOVO)|(Soutec)|(SOUTEC)|(SAGEM)|(SEC\-)|(SED\-)|(EMOL\-)|(INNO55)|(ZTE)|(iPhone)|(Android)|(Windows CE)|(Wget)|(Java)|(curl)|(Opera)" ){
                        root   /home/mobilesite;
                }
                index  index.html index.htm;
                proxy_set_header Host  $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto  $scheme;
                client_max_body_size    10m;
                client_body_buffer_size 128k;
				#proxy_connect_timeout   90;
				#proxy_send_timeout      90;
				#proxy_read_timeout      90;
                proxy_buffer_size       4k;
                proxy_buffers           4 32k;
                proxy_busy_buffers_size 64k;
                proxy_temp_file_write_size 64k;
                expires  3d;
        }

        error_page   404  /404.html;
        location = /404.html {
                root   html;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
                root   html;
        }
}
```
#### 配置：负载均衡(http-conf/目录下):
```
upstream wwwLoveshareMeLoadBalance {
		#ip_hash;  
        server 192.168.1.155:8080 weight=1 max_fails=2 fail_timeout=30s;
        server 192.168.1.156:8080 weight=1 max_fails=2 fail_timeout=30s;
		server 192.168.1.157:8080 weight=1 max_fails=2 fail_timeout=30s;
}       
server {
        listen 80;
        server_name www.loveshare.me;
        location / {
                proxy_set_header Host  $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-Proto  $scheme;
                proxy_set_header  X-Forwarded-For $remote_addr;
                proxy_set_header  X-Forwarded-Host $server_name;
                proxy_next_upstream http_502 http_504 error timeout invalid_header;
				#注* server段 proxy_pass定义的web_app需要跟upstream里面定义的web_app一致,否则server找不到均衡。
                proxy_pass https://wwwLoveshareMeLoadBalance;
        }
}
```
#### 配置：mysql、远程桌面等端口转发，(stream-conf/目录下):
```
upstream mysql{
        server 192.168.1.120:3306 weight=1 max_fails=2 fail_timeout=30s;
}

upstream windows_remote_desk{
        server 192.168.1.135:3389 weight=1 max_fails=2 fail_timeout=30s;
}

server{
        listen 3306;
        proxy_pass mysql;
}

server{
        listen 3389;
        proxy_pass windows_remote_desk;
}
```
