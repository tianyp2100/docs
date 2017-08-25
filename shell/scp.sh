# 上传文件到远程服务器磁盘
#注: admin:是可操作上传服务器的用户名,123456:是上传服务器密码
#注：/home/manager/SpringCloud/service/*和/home/SpringCloud/api/*,是本地服务器地址
#注：/home/SpringCloudService/new和/home/SpringCloudApi/new,是远程服务器上传目录
echo -e "\033[31m ============部署服务代码开始======================  \033[0m"
sshpass -p 123456 scp -p22 -o StrictHostKeyChecking=no /home/manager/SpringCloud/service/* admin@192.168.1.231:/home/SpringCloudService/new <<sshpassupload
exit
sshpassupload
exit 0
echo -e "\033[31m ============部署服务代码结束======================  \033[0m"
echo -e "\033[35m ============部署接入代码开始======================  \033[0m"
sshpass -p 123456 scp -p22 -o StrictHostKeyChecking=no /home/SpringCloud/api/* admin@192.168.1.232:/home/SpringCloudApi/new <<sshpassupload
exit
sshpassupload
echo -e "\033[35m ============部署接入代码结束======================  \033[0m"
exit 0